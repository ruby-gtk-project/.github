---
description: |
  Runs the test-parity census on one port: counts every upstream test, maps
  each to a named Ruby test, and opens a pull request writing .reports/TEST_PARITY.md
  into the fork. Triggered by hand.

on:
  workflow_dispatch:
    inputs:
      repo:
        description: "Fork to census, e.g. console-rb"
        required: true
        type: string
      upstream_branch:
        description: "Branch holding the original app (blank = the fork parent's default branch)"
        required: false
        type: string

engine: copilot
model: gpt-5

timeout-minutes: 30

permissions: read-all

network:
  allowed: [defaults, github]

checkout:
  - repository: ruby-gtk-project/${{ inputs.repo }}
    path: ./target
    fetch-depth: 0
    fetch: ["*"]
    github-token: ${{ secrets.GH_AW_PROJECT_GITHUB_TOKEN }}

tools:
  edit:
  bash: ["*"]
  github:
    toolsets: [repos]

steps:
  - name: Census the test suites
    env:
      GH_TOKEN: ${{ github.token }}
      REPO: ${{ inputs.repo }}
      UPSTREAM_BRANCH: ${{ inputs.upstream_branch }}
    run: |
      set -euo pipefail
      ORG=ruby-gtk-project
      OUT=/tmp/gh-aw/agent/test-parity
      mkdir -p "$OUT"

      # The original and the port are two branches of the same fork, so one
      # clone and two worktrees give both trees side by side.
      git clone --quiet "https://github.com/$ORG/$REPO" /tmp/gh-aw/agent/trees/src
      cd /tmp/gh-aw/agent/trees/src

      if [ -z "$UPSTREAM_BRANCH" ]; then
        UPSTREAM_BRANCH=$(gh api "repos/$ORG/$REPO" --jq '.parent.default_branch // empty')
      fi
      if [ -z "$UPSTREAM_BRANCH" ]; then
        echo "Could not determine the upstream branch for $REPO — pass it explicitly." >&2
        exit 1
      fi

      git worktree add --quiet --detach /tmp/gh-aw/agent/trees/upstream "origin/$UPSTREAM_BRANCH"
      git worktree add --quiet --detach /tmp/gh-aw/agent/trees/port "origin/ruby"

      {
        echo "repo=$ORG/$REPO"
        echo "upstream_branch=$UPSTREAM_BRANCH"
        echo "upstream_sha=$(git rev-parse --short "origin/$UPSTREAM_BRANCH")"
        echo "port_sha=$(git rev-parse --short origin/ruby)"
        echo "date=$(date -u +%Y-%m-%d)"
      } > "$OUT/context.env"

      # The skill's census script: one row per test case, per side.
      bash "$GITHUB_WORKSPACE/port-scaffold/.claude/skills/test-parity/scripts/test-census.sh" \
        /tmp/gh-aw/agent/trees/upstream > "$OUT/upstream-tests.tsv"
      bash "$GITHUB_WORKSPACE/port-scaffold/.claude/skills/test-parity/scripts/test-census.sh" \
        /tmp/gh-aw/agent/trees/port > "$OUT/port-tests.tsv"

      wc -l "$OUT/upstream-tests.tsv" "$OUT/port-tests.tsv"
      cat "$OUT/context.env"

safe-outputs:
  create-pull-request:
    target-repo: "*"
    github-token: ${{ secrets.GH_AW_PROJECT_GITHUB_TOKEN }}
    title-prefix: "[test-parity] "
    labels: [test-parity]
    max: 1
    draft: false
    # The census document and nothing else. An exclusive allowlist means a PR
    # carrying anything but it is refused rather than reviewed.
    allowed-files: [".reports/TEST_PARITY.md"]
    if-no-changes: "error"
---

# Test parity report

**Read `port-scaffold/.claude/skills/test-parity/SKILL.md` first.** It defines
what test parity means, the document you are writing, and the two states every
test lives in. This run is that skill, applied to one repo by machine.

A census has already run. `/tmp/gh-aw/agent/test-parity/` holds:

- `context.env` — `repo`, `upstream_branch`, `upstream_sha`, `port_sha`, `date`.
- `upstream-tests.tsv` — every test case in the original, one row per case:
  file, identifier, line.
- `port-tests.tsv` — the same for the port's `ruby` branch.

The trees are on disk too: the original at `/tmp/gh-aw/agent/trees/upstream`,
the port at `/tmp/gh-aw/agent/trees/port`. Read them — the census tells you
what exists, not what it tests.

## The job

Map the census. For **every** row in `upstream-tests.tsv`, find the port test
that pins the same behaviour and name it, or mark it a `gap` with the
behaviour still owed, phrased as something the app does for a person. The
skill is absolute about this: there is no third state, no `n/a`, no "does not
carry over". If a test looks harness-only or duplicated, open both files and
look — the census is a lead, not a verdict.

The port's rows are under the same discipline: a port test no upstream test
names is noted as such (it is not a problem, but it is recorded).

## Write the document

Write `.reports/TEST_PARITY.md` under `./target` (the port's `ruby` branch),
in exactly the shape the skill gives — with one campaign convention on top:
generated parity documents live in `.reports/`, so where the skill says the
branch root, the path here is `.reports/`. Create the directory first. The header table (upstream and port
branch@sha from `context.env`, the counts, the test command) and one section
per suite with the mapping table. Every count in it must be the count of rows
in your mapping — never a number you did not derive from the census files.

Then open the pull request: `create_pull_request` with `repo` from
`context.env`, adding only `.reports/TEST_PARITY.md`, titled `Test parity <date>`. The
body is the header table's numbers and one sentence on where the gaps cluster.

## Rules

- Never edit anything but `.reports/TEST_PARITY.md`.
- If the port has no application code, stop and say so — there is nothing to
  map, and no pull request should be opened.
- If upstream has no tests, the document says exactly that — zero owed, zero
  ported — and that is still a fact worth committing. Open the PR.
