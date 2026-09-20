---
description: |
  Weekly binding scan. Reads every fork's upstream build files, works out which
  GObject Introspection namespaces the ports need, subtracts what ruby-gnome
  already ships, opens one issue per missing gem on the Bindings project, and
  commits a report to reports/.

on:
  schedule: weekly on monday
  workflow_dispatch:
    inputs:
      min_apps:
        description: "Only open issues for gaps blocking at least this many apps"
        required: false
        default: "2"
        type: string

engine:
  id: copilot

model: gpt-5

timeout-minutes: 45

permissions: read-all

network:
  allowed: [defaults, github]

tools:
  edit:
  bash: ["cat *", "jq *", "ls *", "head *", "wc *"]
  github:
    toolsets: [repos, issues]
  repo-memory:
    branch-name: memory/binding-gaps
    description: "Previous run gap set, so deltas are read rather than recomputed"
    allowed-extensions: [".json"]
    max-file-count: 2

steps:
  - name: Scan the fleet for missing bindings
    env:
      GH_TOKEN: ${{ github.token }}
      MIN_APPS: ${{ inputs.min_apps || '2' }}
    run: |
      set -euo pipefail
      mkdir -p /tmp/gh-aw/agent reports

      SCAN_DATE=$(date -u +%F)
      echo "SCAN_DATE=$SCAN_DATE" >> "$GITHUB_ENV"
      export SCAN_DATE
      echo "$SCAN_DATE" > /tmp/gh-aw/agent/scan-date.txt

      # Last week's gaps.json, carried on the memory branch. Absent on the
      # first ever run, which the agent is told to treat as "no deltas".
      PREV=/tmp/gh-aw/repo-memory/default/gaps.json
      [ -f "$PREV" ] || PREV=""

      .github/aw/binding-scan.sh ruby-gtk-project \
        .github/aw/namespace-map.json /tmp/gh-aw/agent/scan "$PREV"

      G=/tmp/gh-aw/agent/scan/gaps.json

      # The agent gets two purpose-built slices, never the whole scan. Its
      # conversation carries whatever it reads on every single turn, and at
      # ~70 tool calls a 40 KB file is what actually costs the run.

      # The issue list: already filtered, already ranked, and carrying only the
      # fields an issue body uses.
      jq --argjson min "${MIN_APPS}" '{
        scan_date,
        coverage_source: .coverage.source,
        gaps: [ .gaps[] | select(.app_count >= $min)
                | {namespace, app_count, apps, pkgconfig, evidence} ]
      }' "$G" > /tmp/gh-aw/agent/to-file.json

      # The report's facts, with `filed` already decided so the agent does not
      # have to re-apply the threshold, and the tail already trimmed.
      jq --argjson min "${MIN_APPS}" '
        (.gaps | map(select(.app_count >= $min) | .namespace)) as $filed
        | {
            scan_date,
            fleet,
            coverage: {source: .coverage.source, namespaces: .coverage.namespaces},
            counts: {
              gaps_total: (.gaps | length),
              gaps_filed: ([.gaps[] | select(.app_count >= $min)] | length),
              gaps_tail: ([.gaps[] | select(.app_count < $min)] | length),
              ports_blocked: (.per_app | length),
              ports_clear: (.fleet.apps_fully_covered),
              covered_namespaces: (.coverage.namespaces),
              top4_unblocks: ([.gaps[:4][].apps] | flatten | unique | length),
              top4_names: [.gaps[:4][].namespace]
            },
            delta,
            ranked: [ .gaps[] | {namespace, app_count, evidence,
                                 filed: (.namespace | IN($filed[]))} ],
            per_app,
            rust_top: [ .rust_not_bindings[:6][].crate ],
            unclassified: [ .unclassified[] | select(.app_count >= 2)
                            | {name, app_count} ],
            unclassified_total: (.unclassified | length)
          }' "$G" > /tmp/gh-aw/agent/report.json

      # Carry this run forward for next week's deltas. Only the namespace and
      # its app count are needed, and the memory branch has a patch-size limit
      # the whole of gaps.json (40 KB) does not fit inside.
      mkdir -p /tmp/gh-aw/repo-memory/default
      jq '{scan_date, gaps: [.gaps[] | {namespace, app_count}]}' \
        "$G" > /tmp/gh-aw/repo-memory/default/gaps.json

      jq -r '"\(.gaps|length) gaps, \(.coverage.namespaces) namespaces covered, \(.unclassified|length) unclassified"' "$G"
      echo "to file: $(jq '.gaps|length' /tmp/gh-aw/agent/to-file.json) issues (min_apps=${MIN_APPS})"
      echo "agent inputs: $(wc -c < /tmp/gh-aw/agent/to-file.json) + $(wc -c < /tmp/gh-aw/agent/report.json) bytes (scan was $(wc -c < "$G"))"

post-steps:
  - name: Sync the Bindings board
    env:
      # Project-scoped. The agent job is read-all, so this carries its own.
      GITHUB_TOKEN: ${{ secrets.GH_AW_PROJECT_GITHUB_TOKEN }}
      MIN_APPS: ${{ inputs.min_apps || '2' }}
    run: |
      set -euo pipefail
      .github/aw/project-sync.sh ruby-gtk-project 4 "${{ github.repository }}" \
        /tmp/gh-aw/agent/scan/gaps.json "${MIN_APPS}"

  - name: Commit the report
    env:
      # Repo-scoped, contents:write on this repo only. strict mode forbids
      # giving the agent job that permission, so the push carries its own token.
      GITHUB_TOKEN: ${{ secrets.GH_AW_REPORT_GITHUB_TOKEN }}
    run: |
      set -euo pipefail
      f="reports/binding-gaps-${SCAN_DATE}.md"
      if [ ! -s "$f" ]; then
        echo "::error::agent did not write $f"
        exit 1
      fi
      git config user.name  "github-actions[bot]"
      git config user.email "41898282+github-actions[bot]@users.noreply.github.com"
      git add "$f"
      if git diff --cached --quiet; then
        echo "nothing to commit"
        exit 0
      fi
      git commit -m "reports: binding gaps ${SCAN_DATE}"
      url="https://x-access-token:${GITHUB_TOKEN}@github.com/${{ github.repository }}.git"
      git pull --rebase --autostash "$url" main
      git push "$url" HEAD:main

safe-outputs:
  # The board is synced in post-steps, not here. A deduplicated issue registers
  # no temporary id, so update_project had nothing to attach to on any run
  # after the first, and the per-run safe output budget is shared - 35 issues
  # plus 35 board updates overran it and the last ten failed outright.
  create-issue:
    max: 40
    labels: [binding]
    title-prefix: "[binding] "
    deduplicate-by-title: true
---

# Binding gaps

Once a week you work out which Ruby gems the port campaign needs and nobody has
written yet, open an issue for each one, and write the report that ranks them.

Read `PLAN.md` in this repo first — it defines the campaign. The short version
for this job: each fork carries the upstream GNOME app on its original branch
and the Ruby port on `ruby`, so the upstream build files say exactly which
libraries a port will have to reach. A library with no Ruby binding is a port
that cannot be finished.

**Every number has already been computed. Do not re-count anything, do not
open a repository to check a figure, and do not estimate.** If something is not
in these files, it is unknown — write that it is unknown and print `—`.

You read two files and nothing else. Both are slices of the scan, cut to what
each step needs — the full scan is 40 KB and would ride along on every turn.

**`/tmp/gh-aw/agent/to-file.json`** — Step 1's input. `scan_date`,
`coverage_source`, and `gaps[]`: **exactly the gaps you open issues for**,
sorted by `app_count` highest first, each with `namespace`, `app_count`,
`apps` (the fork names), `pkgconfig` (the names the scan matched) and
`evidence` (which of `meson`, `import`, `cargo` it was seen in). One issue per
entry — no more, no fewer.

**`/tmp/gh-aw/agent/report.json`** — Step 2's input:

- `ranked[]` — **every** gap, in order, with `namespace`, `app_count`,
  `evidence` and `filed` (whether it got an issue). The threshold has already
  been applied; do not re-apply it.
- `per_app` — fork name → the namespaces it is waiting on.
- `counts` — **every figure the Summary line needs, already counted**:
  `gaps_total` (all gaps, not just the filed ones), `gaps_filed`, `gaps_tail`,
  `ports_blocked`, `ports_clear`, `covered_namespaces`, and `top4_unblocks` /
  `top4_names` for the concentration sentence. Use these verbatim. Do not
  count rows in `ranked` — it is the whole list, not the filed ones.
- `fleet`, `coverage` — where coverage was read from, and the fleet totals.
- `delta` — `new`, `closed`, `moved`, and `had_previous`. **`had_previous:
  false` means this is the first run**: say so and skip every delta.
- `unclassified[]` — names the scan found but `namespace-map.json` does not
  classify, those blocking 2+ ports only; `unclassified_total` is the full
  count. This matters: see below.
- `rust_top[]` — the most common Rust crates that are not bindings at all.

`/tmp/gh-aw/agent/scan-date.txt` holds today's date, `YYYY-MM-DD`. Call it
`<DATE>`.

### What a gap is, and what it is not

A gap is a **GObject Introspection namespace** that an upstream app depends on
and ruby-gnome does not bind. The unit is the namespace, not the app: `Soup`
is one gem that unblocks every app waiting on it, so it is one issue naming all
of them — never one issue per app.

Two things that look like gaps and are not:

- **Rust crates.** `rust_top` lists dependencies of the Rust upstreams
  that are pure Rust — `regex`, `reqwest`, `serde` and the like. They have no C
  library and no typelib behind them, so no gem has to be written; a port finds
  a Ruby equivalent instead. Mention the category once in the report. Never open
  an issue for one.
- **Unclassified names.** The scan refuses to guess at a name
  `namespace-map.json` does not know, so it reports it instead. While that list
  has entries the gap count is a **floor, not a total**, and the report has to
  say so.

**Do all of Step 1 before you start Step 2.** The issues are the output that
matters; the report is written from the same files and can be rewritten next
week if the run runs long.

## Step 1 — The issues

For every entry in `to-file.json`'s `gaps[]`, call `create_issue`. Nothing else
references the issue afterwards, so it needs no `temporary_id`.

Title, exactly — the prefix is added for you, so do not type it:

`<namespace>: Ruby binding needed`

Body — keep to exactly this, it is the same shape 30-odd times and every extra
line costs budget you need for the rest of the run:

```markdown
`<namespace>` has no Ruby binding. **<app_count>** ports need it.

Matched as <join `pkgconfig` in backticks>, seen in <join `evidence`>.
ruby-gnome coverage read from `<coverage_source>`.

### Blocked ports

<Comma-separated `apps`, each as a plain repo name in backticks. One paragraph,
no bullets, no links.>

---
[Scan for <DATE>](https://github.com/${{ github.repository }}/blob/main/reports/binding-gaps-<DATE>.md)
```

You do not touch the project board. It is synced from the same scan after you
finish, so an issue that already exists still lands on it with its fields set.

Titles are deduplicated, so a gap that was filed last week updates nothing
rather than filing twice. Do not close, rename or re-file an existing issue.

## Step 2 — The report

Write `reports/binding-gaps-<DATE>.md`. Exactly this shape:

```markdown
# Binding gaps — <DATE>

## Summary

<One line, every number straight from `counts`: `gaps_total` gaps across
`ports_blocked` ports, `gaps_filed` of them with an issue and `gaps_tail`
blocking a single port each, `covered_namespaces` namespaces already covered by
ruby-gnome, `ports_clear` ports needing nothing beyond what exists.>

<Then the headline, from `counts` as well: the top four gaps (`top4_names`)
unblock `top4_unblocks` of the `ports_blocked` blocked ports between them. This
is the report's reason to exist — the issues each say who they block, but only
the report says what to build first.>

<If `unclassified` is non-empty, one sentence saying the gap count is a floor
and how many names are unclassified.>

## Ranked gaps

| Namespace | Ports blocked | Seen in | Issue |
|---|---|---|---|

<Every entry in `ranked`, in the order given. `Issue` is `filed` when `filed`
is true and `—` when it is false. Do not reorder.>

## Since last week

<`delta.new`, `delta.closed`, `delta.moved`, each with its namespaces. A closed
gap means ruby-gnome shipped a gem or the last port needing it changed; say
which if you can tell from `ranked`, otherwise say it is unexplained. Omit this
whole section when `delta.had_previous` is false and say why.>

## Ports by what they are waiting on

| Port | Waiting on | Count |
|---|---|---|

<From `per_app`, most-blocked first. This is the view the issues cannot give:
an issue says who it blocks, this says what each port is short of.>

<Then one line naming how many port targets have no gaps at all.>

## Not bindings

<One short paragraph on `rust_top`: these are pure-Rust dependencies of the
Rust upstreams, they need a Ruby equivalent rather than a gem, and no issue was
opened. Name the four or five most common.>

## Unclassified

<Every entry in `unclassified`, as a table of name and count — it already holds
only those blocking 2+ ports, and `unclassified_total` is how many there are in
all. These are names `namespace-map.json` does not classify. Say plainly
that each one is either a missing gap or a name that should be marked as not a
binding target, and that until they are classified the numbers above are a
floor. Omit the section only when the list is empty.>
```

## Rules

- Write `reports/binding-gaps-<DATE>.md`. The commit is automatic — if the file
  is missing the run fails, so write it before you finish.
- Never edit an older report. They are the record the deltas are read against.
- One issue per entry in `to-file.json`. Not one per app, not one per repo.
- Every number comes from these two files. If it is not there, print `—`. An
  invented number is the only failure here that matters.
