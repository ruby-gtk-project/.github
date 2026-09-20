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

timeout-minutes: 25

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
      echo "${MIN_APPS}" > /tmp/gh-aw/agent/min-apps.txt

      # Last week's gaps.json, carried on the memory branch. Absent on the
      # first ever run, which the agent is told to treat as "no deltas".
      PREV=/tmp/gh-aw/repo-memory/default/gaps.json
      [ -f "$PREV" ] || PREV=""

      .github/aw/binding-scan.sh ruby-gtk-project \
        .github/aw/namespace-map.json /tmp/gh-aw/agent/scan "$PREV"

      cp /tmp/gh-aw/agent/scan/gaps.json /tmp/gh-aw/agent/gaps.json

      # The issue list, already filtered and already ranked. The agent writes
      # the bodies for exactly these and invents no others.
      jq --argjson min "${MIN_APPS}" '
        .gaps | map(select(.app_count >= $min))
      ' /tmp/gh-aw/agent/gaps.json > /tmp/gh-aw/agent/to-file.json

      # Carry this run forward for next week's deltas.
      mkdir -p /tmp/gh-aw/repo-memory/default
      cp /tmp/gh-aw/agent/gaps.json /tmp/gh-aw/repo-memory/default/gaps.json

      jq -r '"\(.gaps|length) gaps, \(.coverage.namespaces) namespaces covered, \(.unclassified|length) unclassified"' \
        /tmp/gh-aw/agent/gaps.json
      echo "to file: $(jq 'length' /tmp/gh-aw/agent/to-file.json) issues (min_apps=${MIN_APPS})"

post-steps:
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
  create-issue:
    max: 40
    labels: [binding]
    title-prefix: "[binding] "
    deduplicate-by-title: true
  update-project:
    max: 40
    project: https://github.com/orgs/ruby-gtk-project/projects/4
    github-token: ${{ secrets.GH_AW_PROJECT_GITHUB_TOKEN }}
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

- `/tmp/gh-aw/agent/gaps.json` — the whole scan. Fields you will use:
  - `gaps[]` — one entry per missing namespace, **sorted by `app_count`,
    highest first**. Each has `namespace`, `app_count`, `apps` (the fork names),
    `pkgconfig` (the names the scan matched), `evidence` (which of `meson`,
    `import`, `cargo` it was seen in).
  - `covered[]` — namespaces ruby-gnome already ships, with the `gem` that
    provides each. These are **not** gaps; never file an issue for one.
  - `per_app` — fork name → the namespaces it is waiting on.
  - `delta` — `new`, `closed` and `moved` since last week, plus
    `had_previous`. **`had_previous: false` means this is the first run**: say
    so and skip every delta.
  - `unclassified[]` — names the scan found but `namespace-map.json` does not
    classify. This matters: see below.
  - `rust_not_bindings[]` — Rust crates that are not bindings at all.
  - `fleet`, `coverage` — counts and where coverage was read from.
- `/tmp/gh-aw/agent/to-file.json` — **exactly the gaps you open issues for.**
  Already filtered and already ranked. File one issue per entry, no more, no
  fewer.
- `/tmp/gh-aw/agent/scan-date.txt` — today's date, `YYYY-MM-DD`. Call it
  `<DATE>`.
- `/tmp/gh-aw/agent/min-apps.txt` — the threshold that produced `to-file.json`.

### What a gap is, and what it is not

A gap is a **GObject Introspection namespace** that an upstream app depends on
and ruby-gnome does not bind. The unit is the namespace, not the app: `Soup`
is one gem that unblocks every app waiting on it, so it is one issue naming all
of them — never one issue per app.

Two things that look like gaps and are not:

- **Rust crates.** `rust_not_bindings` lists dependencies of the Rust upstreams
  that are pure Rust — `regex`, `reqwest`, `serde` and the like. They have no C
  library and no typelib behind them, so no gem has to be written; a port finds
  a Ruby equivalent instead. Mention the category once in the report. Never open
  an issue for one.
- **Unclassified names.** The scan refuses to guess at a name
  `namespace-map.json` does not know, so it reports it instead. While that list
  has entries the gap count is a **floor, not a total**, and the report has to
  say so.

## Step 1 — The issues

For every entry in `to-file.json`, call `create_issue`. Give each one a
`temporary_id` so you can reference it from `update_project` — the issue has no
number yet.

Title, exactly — the prefix is added for you, so do not type it:

`<namespace>: Ruby binding needed`

Body:

```markdown
`<namespace>` has no Ruby binding. **<app_count>** ports in the fleet need it.

### Blocked ports

<Bullet each name in `apps`, linked as https://github.com/ruby-gtk-project/<name>.
More than 12, put them in a <details> block but give the count in the open.>

### What the scan saw

- Matched as: <join `pkgconfig` in backticks>
- Found in: <join `evidence` — `meson` is a `dependency()` call in the upstream
  build, `import` is a `gi.require_version`/`imports.gi`/`gi://` in the upstream
  source, `cargo` is a gtk-rs crate>
- ruby-gnome coverage read from `<coverage.source>` on <DATE>

---
Opened by `binding-gaps`. The scan is in
[reports/binding-gaps-<DATE>.md](https://github.com/${{ github.repository }}/blob/main/reports/binding-gaps-<DATE>.md).
```

Then add each one to the board with `update_project`: the project URL
`https://github.com/orgs/ruby-gtk-project/projects/4`, no `operation` (adding
an item is what it does when `operation` is omitted), `content_type` `issue`,
the issue's `temporary_id`, and `fields`:

- `Status` — `Todo`
- `Apps blocked` — `app_count`
- `Namespace` — `namespace`

Titles are deduplicated, so a gap that was filed last week updates nothing
rather than filing twice. Do not close, rename or re-file an existing issue.

## Step 2 — The report

Write `reports/binding-gaps-<DATE>.md`. Exactly this shape:

```markdown
# Binding gaps — <DATE>

## Summary

<One line: N gaps across N ports, N namespaces already covered by ruby-gnome,
N ports needing nothing beyond what exists. All from `fleet` and `coverage`.>

<Then the headline: how concentrated the demand is. Name how many gems it takes
to unblock the most ports — count it off the sorted `gaps` list, do not
estimate. This is the report's reason to exist: the issues each say who they
block, but only the report says what to build first.>

<If `unclassified` is non-empty, one sentence saying the gap count is a floor
and how many names are unclassified.>

## Ranked gaps

| Namespace | Ports blocked | Seen in | Issue |
|---|---|---|---|

<Every entry in `gaps`, in the order given. `Issue` is `filed` for the ones in
`to-file.json` and `—` for the rest. Do not reorder.>

## Since last week

<`delta.new`, `delta.closed`, `delta.moved`, each with its namespaces. A closed
gap means ruby-gnome shipped a gem or the last app needing it changed — say
which if `covered` shows a gem for it, otherwise say it is unexplained. Omit
this whole section when `delta.had_previous` is false and say why.>

## Ports by what they are waiting on

| Port | Waiting on | Count |
|---|---|---|

<From `per_app`, most-blocked first. This is the view the issues cannot give:
an issue says who it blocks, this says what each port is short of.>

<Then one line naming how many port targets have no gaps at all.>

## Not bindings

<One short paragraph on `rust_not_bindings`: these are pure-Rust dependencies of
the Rust upstreams, they need a Ruby equivalent rather than a gem, and no issue
was opened. Name the four or five most common.>

## Unclassified

<Every entry in `unclassified` with `app_count` of 2 or more, as a table of name
and count. These are names `namespace-map.json` does not classify. Say plainly
that each one is either a missing gap or a name that should be marked as not a
binding target, and that until they are classified the numbers above are a
floor. Omit the section only when the list is empty.>
```

## Rules

- Write `reports/binding-gaps-<DATE>.md`. The commit is automatic — if the file
  is missing the run fails, so write it before you finish.
- Never edit an older report. They are the record the deltas are read against.
- One issue per entry in `to-file.json`. Not one per app, not one per repo.
- Every number comes from `gaps.json`. If it is not there, print `—`. An
  invented number is the only failure here that matters.
