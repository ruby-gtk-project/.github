---
description: |
  Weekly fleet report. Reads every fork's PORTING.md ledger, computes port
  completion, commits the report to reports/, and opens a review issue on the
  org's Reports project.

on:
  schedule: weekly on monday
  workflow_dispatch:

engine:
  id: copilot

model: gpt-5

timeout-minutes: 20

permissions: read-all

network:
  allowed: [defaults, github]

tools:
  edit:
  bash: ["cat *", "jq *", "ls *", "head *", "wc *"]
  github:
    toolsets: [repos, issues, pull_requests]

steps:
  - name: Read the fleet ledgers
    env:
      GH_TOKEN: ${{ github.token }}
    run: |
      set -euo pipefail
      mkdir -p /tmp/gh-aw/agent reports
      ORG=ruby-gtk-project

      REPORT_DATE=$(date -u +%F)
      echo "REPORT_DATE=$REPORT_DATE" >> "$GITHUB_ENV"
      echo "$REPORT_DATE" > /tmp/gh-aw/agent/report-date.txt

      # One pass over the org: fork status, the ruby branch's PORTING.md
      # ledger, open [port] PRs, and when the branch last moved.
      gh api graphql --paginate --slurp -F org="$ORG" -f query='
        query($org: String!, $endCursor: String) {
          organization(login: $org) {
            repositories(first: 25, after: $endCursor, isArchived: false) {
              pageInfo { hasNextPage endCursor }
              nodes {
                name
                isArchived
                parent { nameWithOwner defaultBranchRef { name } }
                defaultBranchRef {
                  name
                  target { ... on Commit { committedDate } }
                }
                ledger: object(expression: "ruby:PORTING.md") { ... on Blob { text } }
                portPRs: pullRequests(states: OPEN, first: 20, labels: ["port"]) {
                  totalCount
                  nodes { number title url isDraft createdAt updatedAt }
                }
              }
            }
          }
        }' > /tmp/gh-aw/agent/raw.json

      # Whether the port has actually started. The enumerated ledger is not
      # written yet in most forks, so app files on the ruby branch are the
      # only state signal that exists across the whole fleet.
      : > /tmp/gh-aw/agent/app-files.jsonl
      for name in $(jq -r '.[].data.organization.repositories.nodes[].name' /tmp/gh-aw/agent/raw.json); do
        gh api "repos/$ORG/$name/git/trees/ruby?recursive=1" \
          --jq "{name: \"$name\", app_files: ([.tree[].path | select((startswith(\"lib/\") or startswith(\"bin/\")) and endswith(\".rb\"))] | length)}" \
          2>/dev/null || echo "{\"name\":\"$name\",\"app_files\":0,\"no_ruby_branch\":true}"
      done >> /tmp/gh-aw/agent/app-files.jsonl

      # Percentages are computed here, not by the agent. A unit is a checkbox
      # in PORTING.md; ticked means ported, run and screenshotted.
      jq --arg date "$REPORT_DATE" --slurpfile apps /tmp/gh-aw/agent/app-files.jsonl '
        ($apps | INDEX(.name)) as $app
        | [ .[].data.organization.repositories.nodes[] ]
        | map(
            (.ledger.text // "") as $t
            | ($t | [scan("(?im)^[ \t]*[-*] \\[[xX]\\]")] | length) as $done
            | ($t | [scan("(?im)^[ \t]*[-*] \\[ \\]")] | length) as $todo
            | {
                name,
                port_target: (.parent != null and (.defaultBranchRef.name // "") == "ruby"),
                upstream: (.parent.nameWithOwner // null),
                default_branch: (.defaultBranchRef.name // null),
                last_commit: (.defaultBranchRef.target.committedDate // null),
                has_ledger: (.ledger != null),
                units_done: $done,
                units_total: ($done + $todo),
                percent: (if ($done + $todo) > 0
                          then (($done * 1000 / ($done + $todo)) | round / 10)
                          else null end),
                app_files: ($app[.name].app_files // 0),
                started: (($app[.name].app_files // 0) > 0),
                open_port_prs: .portPRs.totalCount,
                prs: [ .portPRs.nodes[] | {number, title, url, isDraft, updatedAt} ]
              }
          )
        | { report_date: $date,
            generated_at: (now | todate),
            repos: (. | sort_by(-(.percent // -1))) }
      ' /tmp/gh-aw/agent/raw.json > /tmp/gh-aw/agent/fleet.json

      # Last week's report, for the deltas. Empty on the first ever run.
      prev=$(ls -1 reports/*.md 2>/dev/null | grep -v "/${REPORT_DATE}\.md$" | tail -1 || true)
      if [ -n "$prev" ]; then
        cp "$prev" /tmp/gh-aw/agent/previous-report.md
        echo "$prev" > /tmp/gh-aw/agent/previous-report-path.txt
      else
        : > /tmp/gh-aw/agent/previous-report.md
        : > /tmp/gh-aw/agent/previous-report-path.txt
      fi

      jq -r '"\(.repos | length) repos, \(.repos | map(select(.port_target)) | length) port targets, \(.repos | map(select(.has_ledger)) | length) with ledgers"' \
        /tmp/gh-aw/agent/fleet.json

post-steps:
  - name: Commit the report
    env:
      # Repo-scoped, contents:write on this repo only. strict mode forbids
      # giving the agent job that permission, so the push carries its own token.
      GITHUB_TOKEN: ${{ secrets.GH_AW_REPORT_GITHUB_TOKEN }}
    run: |
      set -euo pipefail
      f="reports/${REPORT_DATE}.md"
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
      git commit -m "reports: weekly fleet report ${REPORT_DATE}"
      url="https://x-access-token:${GITHUB_TOKEN}@github.com/${{ github.repository }}.git"
      git pull --rebase --autostash "$url" main
      git push "$url" HEAD:main

safe-outputs:
  create-issue:
    max: 1
    labels: [report]
    deduplicate-by-title: true
  update-project:
    max: 1
    project: https://github.com/orgs/ruby-gtk-project/projects/3
    github-token: ${{ secrets.GH_AW_PROJECT_GITHUB_TOKEN }}
---

# Weekly fleet report

Once a week you write the port campaign's report: where the fleet actually is,
what moved since last week, and what is stuck. The campaign ports every app in
the org to Ruby GTK4/Libadwaita — one fork per app, the port written on the
fork's `ruby` branch. A **unit** is the smallest piece of the app that can be
ported, run and seen: one window, one dialog, one page, one menu item, one
shortcut, one error state. Each fork's `PORTING.md` is the ledger of those
units and the source of truth on progress — agent memory is a cache of it, not
a replacement.

The numbers have already been gathered for you. Do not re-count anything and do
not estimate — read these files:

- `/tmp/gh-aw/agent/fleet.json` — one entry per live org repo: `name`,
  `port_target`, `upstream`, `default_branch`, `last_commit`, `has_ledger`,
  `units_done`, `units_total`, `percent`, `app_files`, `started`,
  `open_port_prs`, and the open `[port]` PRs themselves. Sorted by `percent`,
  highest first.
- `/tmp/gh-aw/agent/previous-report.md` — last week's report. **Empty means this
  is the first run**; say so and skip every delta.
- `/tmp/gh-aw/agent/report-date.txt` — today's date, `YYYY-MM-DD`. Call it
  `<DATE>` below.

### What the numbers mean, and what they do not

`percent` is `units_done / units_total`, counted from the enumerated checkboxes
every fork's `PORTING.md` carries.

**Most forks do not have that ledger.** Where they have a `PORTING.md` at all it
is usually retrospective porting notes — a file map, deliberate divergences,
what was not ported — with no enumerated units and no cursor. Those forks come
through as `has_ledger: true` but `units_total: 0` and `percent: null`.

So:

- `percent: null` means **unknown**. Never print it as 0%, never estimate it,
  and never substitute a guess from file counts — the file counts do not track
  completeness (a finished port can have half the upstream file count, or more).
- `started` / `app_files` is the one completion signal that exists fleet-wide:
  `.rb` files under `lib/` or `bin/` on the `ruby` branch. It tells you a port
  has begun. It does **not** tell you how far along it is.
- A fork with `has_ledger: true` and `units_total: 0` has notes, not a ledger.
  Count it under ledger health, not under progress.

Report the coverage gap as a finding every week until it closes. Until the
ledgers exist there is no fleet percentage, and the report says so in the
Fleet section rather than inventing one.

Only repos with `port_target: true` belong in the fleet table. Everything else
in the org is tooling, demos or infrastructure.

## Step 1 — Write the report

Write it to `reports/<DATE>.md` in the repo. Exactly this shape:

```markdown
# Weekly fleet report — <DATE>

## Fleet

<One line of counts: N port targets, N started, N with an enumerated ledger,
N with notes only, N with no PORTING.md at all, N open [port] PRs.>

<Then the fleet percentage: total units done / total units, across the forks
that have an enumerated ledger — and the count of forks that number covers. If
no fork has one, write that no fleet percentage can be computed yet and why,
in one sentence. Do not estimate one.>

<One short paragraph on the week. What actually changed, and what that means for
the campaign. No filler — if it was a quiet week, say it was a quiet week.>

## Movement since <previous report date>

| Repo | Last week | This week | Δ units |
|---|---|---|---|

<Only repos whose numbers changed. Plus a line each for PRs opened, merged and
closed this week. Omit this whole section on the first run and say why.>

## Ports

| Repo | State | Units | % | Open PRs | Last commit |
|---|---|---|---|---|---|

<Every port target, started ones first. `State` is one of `in flight` (started),
`not started`, or `no ruby branch`. `Units` is `done/total` from the ledger, or
`—`. `%` is `percent`, or `—` when it is unknown — which is most of them. Do not
fill a `—` with a guess.>

## Pilot set

<The pilot forks are `console-rb`, `gnome-contacts-rb`, `gnome-logs-rb`,
`tally-rb` and `binary-rb`. Nothing runs fleet-wide until the pilots produce
merged PRs a human would have written the same way. Give each pilot a line:
where it is, what is blocking it, and state plainly whether the gate to go
fleet-wide is met.>

## Stalled

<Bullet each of these, with the repo name and the number. Omit a bullet that has
no entries:>
- At the 4 open `[port]` PR cap — no new work is scheduled there until one clears.
- No commit on `ruby` in 14+ days, despite an incomplete ledger.
- Open PRs not updated in 7+ days — waiting on review.

## Ledger health

<This is the report's main finding until it stops being one. A skipped feature
that was never written down is the only failure mode that matters, and the
ledger is what catches it. Three groups, each with its count and its
repo names — collapse a long list in a <details> block, but give the count in
the open:>

- **Enumerated ledger** — `has_ledger: true`, `units_total > 0`. These are the
  only forks with a real percentage.
- **Notes only** — `has_ledger: true`, `units_total == 0`. A `PORTING.md`
  exists but carries no enumerated units, so the port's completeness is
  unverifiable. Started forks in this group are the ones to fix first.
- **No ledger** — `has_ledger: false`.

<One sentence on whether the gap moved since last week.>

## Next week

<3–5 concrete recommendations. Which repos get the effort, which stalls a human
has to clear, which ledgers need writing. Each one names a repo.>
```

Keep it factual. Every number comes from `fleet.json`. If something is unknown,
write that it is unknown.

## Step 2 — The review issue

Call `create_issue` with title exactly:

`Review weekly report — <DATE>`

and this body, with the placeholders filled from your own report:

```markdown
[Weekly fleet report — <DATE>](https://github.com/${{ github.repository }}/blob/main/reports/<DATE>.md)

- Ports in flight: **<N>** of <N> targets · <N> not started
- Measurable: **<N>%** across the <N> forks with an enumerated ledger <or: "no fork has an enumerated ledger, so there is no fleet percentage yet">
- Change since last week: **<+N units>** (<N> repos moved)
- Open `[port]` PRs: **<N>** — <N> waiting on review 7+ days
- Stalled: **<N>** · notes-only ledgers: **<N>** · no ledger: **<N>**

### To review

- [ ] Spot-check one in-flight fork: does its ledger match what is actually on the `ruby` branch?
- [ ] Ledger gap: <N> forks cannot be measured — <name the started ones, they come first>
- [ ] Clear the stalls: <name the repos, or "none this week">
- [ ] Confirm next week's priorities in the report's "Next week" section
- [ ] Pilot gate: <met / not met — one clause on why>

Close this issue once the report has been reviewed and next week's priorities
are confirmed.
```

Then add it to the board with `update_project`, using the project URL
`https://github.com/orgs/ruby-gtk-project/projects/3` and status `Todo`.

## Rules

- Write `reports/<DATE>.md`. The commit is automatic — if the file is missing the
  run fails, so write it before you finish.
- Never edit an older report. They are the record the deltas are computed from.
- One issue per week. The title carries the date, so re-running today updates
  nothing rather than piling up duplicates.
- Every number is from `fleet.json`. Do not estimate a percentage, and do not
  report a repo as 0% when it simply has no ledger.
