---
description: |
  Weekly excuse audit. Runs the accountability-ensurance scan over every
  fork's ruby branch and reports every phrase that presents missing work as a
  settled decision — "dropped deliberately", "not applicable", "out of scope".
  Commits the report to reports/ and opens a review issue.

on:
  schedule: weekly on thursday
  workflow_dispatch:

engine: copilot
model: gpt-5

timeout-minutes: 30

permissions: read-all

network:
  allowed: [defaults, github]

tools:
  edit:
  bash: ["*"]
  github:
    toolsets: [repos, issues]

steps:
  - name: Scan the fleet for excuses
    env:
      GH_TOKEN: ${{ github.token }}
    run: |
      set -euo pipefail
      mkdir -p /tmp/gh-aw/agent/hits reports

      REPORT_DATE=$(date -u +%F)
      echo "REPORT_DATE=$REPORT_DATE" >> "$GITHUB_ENV"
      echo "$REPORT_DATE" > /tmp/gh-aw/agent/report-date.txt

      # The fleet: port targets are forks whose default branch is ruby.
      gh api graphql --paginate --slurp -F org=ruby-gtk-project -f query='
        query($org: String!, $endCursor: String) {
          organization(login: $org) {
            repositories(first: 25, after: $endCursor, isArchived: false) {
              pageInfo { hasNextPage endCursor }
              nodes { name defaultBranchRef { name } parent { name } }
            }
          }
        }' > /tmp/gh-aw/agent/org-repos.json

      jq -r '[.[].data.organization.repositories.nodes[]]
        | map(select(.parent != null and .defaultBranchRef.name == "ruby"))
        | .[] | .name' /tmp/gh-aw/agent/org-repos.json > /tmp/gh-aw/agent/forks.txt

      # One shallow clone per fork, scanned with the skill's script. Hits land
      # in per-fork files; the agent gets counts precomputed, never the job of
      # recounting.
      SCAN="$GITHUB_WORKSPACE/port-scaffold/.claude/skills/accountability-ensurance/scripts/find-excuses.sh"
      scan_one() {
        local name=$1
        local tmp; tmp=$(mktemp -d)
        if git clone --quiet --depth 1 --branch ruby \
             "https://github.com/ruby-gtk-project/$name" "$tmp/r" 2>/dev/null; then
          bash "$SCAN" "$tmp/r" --quiet > "/tmp/gh-aw/agent/hits/$name.txt"
        else
          : > "/tmp/gh-aw/agent/hits/$name.txt"
          echo "$name" >> /tmp/gh-aw/agent/clone-failed.txt
        fi
        rm -rf "$tmp"
      }
      : > /tmp/gh-aw/agent/clone-failed.txt
      while read -r name; do
        scan_one "$name" &
        while [ "$(jobs -r | wc -l)" -ge 12 ]; do wait -n; done
      done < /tmp/gh-aw/agent/forks.txt
      wait

      for f in /tmp/gh-aw/agent/hits/*.txt; do
        printf '%s\t%s\n' "$(basename "$f" .txt)" "$(grep -c '' "$f")"
      done | sort -t$'\t' -k2 -nr > /tmp/gh-aw/agent/hit-counts.tsv

      # Last week's report, for the delta. Empty on the first run.
      prev=$(ls -1 reports/excuse-audit-*.md 2>/dev/null | grep -v "/${REPORT_DATE}\.md$" | tail -1 || true)
      if [ -n "$prev" ]; then
        cp "$prev" /tmp/gh-aw/agent/previous-report.md
      else
        : > /tmp/gh-aw/agent/previous-report.md
      fi

      echo "forks scanned: $(wc -l < /tmp/gh-aw/agent/forks.txt)"
      echo "forks with hits: $(awk -F'\t' '$2 > 0' /tmp/gh-aw/agent/hit-counts.tsv | wc -l)"
      echo "total hits: $(awk -F'\t' '{s+=$2} END {print s}' /tmp/gh-aw/agent/hit-counts.tsv)"
      echo "clone failures: $(grep -c '' /tmp/gh-aw/agent/clone-failed.txt || true)"

post-steps:
  - name: Commit the report
    env:
      # The one PAT with write access. strict mode forbids giving the agent
      # job contents:write, so the push carries its own token.
      GITHUB_TOKEN: ${{ secrets.GH_AW_PROJECT_GITHUB_TOKEN }}
    run: |
      set -euo pipefail
      f="reports/excuse-audit-${REPORT_DATE}.md"
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
      git commit -m "reports: excuse audit ${REPORT_DATE}"
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

# Excuse audit

**Read `port-scaffold/.claude/skills/accountability-ensurance/SKILL.md`
first.** It defines the failure this report exists to kill: a phrase that
presents missing work as a settled decision, written by the same party that
skipped the work, inherited as fact by everyone who reads it after.

Once a week you count those phrases across the whole fleet. The scan has
already run — every fork's `ruby` branch was cloned and searched. You read
three things:

- `/tmp/gh-aw/agent/hit-counts.tsv` — fork name, hit count, sorted highest
  first. **Every count you print comes from this file.**
- `/tmp/gh-aw/agent/hits/<fork>.txt` — the hits for one fork, each as
  `file:line:phrase:verdict`. Read a fork's file when you write about it.
- `/tmp/gh-aw/agent/previous-report.md` — last week's report. **Empty means
  this is the first run**; say so and skip every delta.

`/tmp/gh-aw/agent/report-date.txt` holds today's date, `YYYY-MM-DD`. Call it
`<DATE>`.

Clone failures are listed in `/tmp/gh-aw/agent/clone-failed.txt` — those forks
were not scanned, and the report must say so by name.

## Write the report

Write `reports/excuse-audit-<DATE>.md`. Exactly this shape:

```markdown
# Excuse audit — <DATE>

## Summary

<Counts from hit-counts.tsv: forks scanned, forks with hits, total hits. Then
the delta against last week's summary counts — new hits, destroyed hits — or
the first-run sentence.>

## The ports

| Port | Hits | Phrases | Worst of them |
|---|---:|---|---|

<One row per fork with hits, worst first. "Phrases" is the distinct matched
phrases, comma-separated. "Worst" is the hit whose verdict matters most, as
`file:line` plus the phrase in backticks — pick by verdict, not by order.
Forks with zero hits get one line above the table saying how many are clean,
not a row each.>

## Destroyed this week

<Hits in last week's report that are gone now. The audit exists to make this
section non-empty — an excuse destroyed is a debt admitted, which is the first
step of the work. Omit on the first run.>

## What a hit means

<One short paragraph from the skill: every hit is rewritten, never deleted;
first person; the behaviour owed, named as something the app does for a
person. This paragraph is the same every week and that is the point.>
```

Keep it factual. A port with hits is not shamed — it is carrying confessions
that have not been rewritten yet. The day a port's hits reach zero and stay
there, its ledger can be read as a map instead of a list of alibis.

## The review issue

Call `create_issue` with title exactly:

`Review excuse audit — <DATE>`

and a body of the summary counts, the delta, and a link to the report at
`https://github.com/${{ github.repository }}/blob/main/reports/excuse-audit-<DATE>.md`.
Then add it to the board with `update_project`, using the project URL
`https://github.com/orgs/ruby-gtk-project/projects/3` and status `Todo`.

## Rules

- Write `reports/excuse-audit-<DATE>.md`. The commit is automatic — if the
  file is missing the run fails, so write it before you finish.
- Never edit an older report. They are the record the delta is read against.
- Every number comes from `hit-counts.tsv`. Do not count hits yourself.
- Forks on the clone-failed list are unknown, not clean — say which they are.
