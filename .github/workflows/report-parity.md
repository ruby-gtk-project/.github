---
description: |
  Reviews a Ruby GTK4 port against the original app it was ported from and
  writes a dated PARITY_REPORT into that repo as a pull request. Triggered by
  hand once a port is believed finished.

on:
  workflow_dispatch:
    inputs:
      repo:
        description: "Fork to review, e.g. Commit-rb"
        required: true
        type: string
      upstream_branch:
        description: "Branch holding the original app (blank = the fork parent's default branch)"
        required: false
        type: string

engine:
  id: copilot
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
  bash:
    ["cat *", "ls *", "find *", "grep *", "head *", "tail *", "sed -n *",
     "wc *", "sort *", "jq *", "git log *", "git show *", "git diff *"]
  github:
    toolsets: [repos]

steps:
  - name: Scan the port against its upstream
    env:
      GH_TOKEN: ${{ github.token }}
      REPO: ${{ inputs.repo }}
      UPSTREAM_BRANCH: ${{ inputs.upstream_branch }}
    run: |
      set -euo pipefail
      ORG=ruby-gtk-project
      OUT=/tmp/gh-aw/agent/parity
      mkdir -p "$OUT"

      # The original and the port are two branches of the same fork, so one
      # clone and two worktrees give us both trees side by side.
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

      bash "$GITHUB_WORKSPACE/.github/aw/parity-scan.sh" \
        /tmp/gh-aw/agent/trees/upstream /tmp/gh-aw/agent/trees/port "$OUT"

      cat "$OUT/context.env"

safe-outputs:
  create-pull-request:
    target-repo: "*"
    github-token: ${{ secrets.GH_AW_PROJECT_GITHUB_TOKEN }}
    title-prefix: "[parity] "
    labels: [parity-review]
    max: 1
    draft: false
    # A review reports; it does not fix. An exclusive allowlist means a PR
    # carrying anything but the report is refused rather than reviewed.
    allowed-files: [".reports/PARITY_REPORT-*.md"]
    if-no-changes: "error"
---

# Parity review

A port is finished when the Ruby app does everything the original does. Your
job is to say whether that is true for one repo, on the evidence, and write it
down as a report that the next person can re-run and compare against.

You are not judging code quality, idiom or style. Only: is anything the
original does missing from the port.

## Step 1 — What the scan found

A scan has already run. `/tmp/gh-aw/agent/parity/` holds:

- `context.env` — `repo`, `upstream_branch`, `upstream_sha`, `port_sha`, `date`.
- `metrics.json` — per category: how many items the original has, how many were
  found in the port, how many were not, and the coverage percentage.
- `upstream-<category>.txt` — every item found in the original.
- `found-<category>.txt` / `missing-<category>.txt` — the split.

The categories, and what a missing item means:

| Category | Items | A miss means |
|---|---|---|
| `actions` | `app.*` / `win.*` GAction names | a command the original exposes that the port does not |
| `accels` | keyboard accelerators | a shortcut that does nothing in the port |
| `settings` | GSettings keys | a preference the original has |
| `menulabels` | menu and UI labels | a menu entry or control |
| `widgets` | Gtk/Adw types used | a kind of UI element — often a whole dialog or page |
| `cli` | command line flags | an invocation the original supports |
| `strings` | translatable strings | user-visible text, so usually a feature |
| `datafiles` | desktop entry, metainfo, schemas, resources | something the packaged app needs |

The two trees are on disk: the original at `/tmp/gh-aw/agent/trees/upstream`, the port at
`/tmp/gh-aw/agent/trees/port`. Read them.

## Step 2 — Judge every miss

The scan matches literals, so it is a lead, not a verdict. For **each** item in
each `missing-*.txt`, open both trees and decide which it is:

- **Missing** — the original has this and the port does not. A real gap.
- **Present** — the port has it under a different spelling. Ruby bindings
  rename things (`AdwAboutDialog` is `Adwaita::AboutDialog`), and a label may
  be built rather than declared. Say where you found it.
- **Not applicable** — it does not carry over. Build-system strings, enum type
  names, GJS/Vala-specific plumbing, translator credits. Say why.

Do not classify an item without looking. "Probably fine" is not a judgement,
and a report that waves misses through is worse than no report, because it
tells the next person the port was checked when it was not.

When a cluster of misses points at one feature — an accelerator, its menu
label and its strings all absent together — report it once as that feature,
not as three items.

## Step 3 — Look for what the scan cannot see

The scan compares names. It cannot see behaviour. Spend real effort here,
working from the original's source:

- **Flows** — does each multi-step path (open → edit → save, first run, an
  error and its recovery) exist end to end in the port?
- **States** — empty, loading, error and offline states. These are frequently
  the parts a port leaves out, and they rarely have distinctive strings.
- **Window plumbing** — geometry saved and restored, close confirmation,
  modality, focus.
- **Data** — file formats read and written, config file locations, migration
  of existing user data.
- **Integrations** — D-Bus services, portals, notifications, the clipboard,
  drag and drop, network APIs.

## Step 4 — Write the report

Write `.reports/PARITY_REPORT-<date>.md` under `./target` (which is the port's
`ruby` branch), where `<date>` is from `context.env`. Generated parity
documents live in `.reports/` — create the directory first. Exactly this
shape, so that two reports on the same repo can be compared:

```markdown
# Parity report — <repo>

| | |
|---|---|
| Reviewed | <date> |
| Port | `ruby` @ `<port_sha>` |
| Original | `<upstream_branch>` @ `<upstream_sha>` |
| Verdict | **PASS** / **FAIL** |

## Summary

<Two or three sentences. If FAIL, lead with what is missing.>

## Metrics

| Category | Original | Found | Gaps | Coverage |
|---|---:|---:|---:|---:|
<one row per category from metrics.json, with Gaps being the count that
survived your judgement in Step 2, not the raw missing count>

## Gaps

<One `### <feature>` per real gap, ordered by how much of the app it is.
Each gives: what the original does, where in the original source it lives,
and what the port has instead. If there are none, write "None found.">

## Behaviour checked

<What you checked in Step 3 and what you concluded, including the things
that were fine. Name the flows and states by name.>

## Dismissed

<Every scan miss you judged Present or Not applicable, one line each with
the reason. This is what makes the report auditable.>

## Not verifiable here

<Anything that needs the app running — visual layout, animation, input
handling, performance. This review is static; say plainly what it did not
cover.>

​```json
<the metrics.json contents, with a "verdict" and "gaps" field added>
​```
```

The verdict is **PASS** only when every category's surviving gap count is zero
and Step 3 turned up nothing. Anything else is **FAIL** with the gaps listed.
A port with one missing dialog is not a pass with a note.

## Step 5 — Open the pull request

Call `create_pull_request` with `repo` set to `<repo>` from `context.env`,
titled `Parity report <date>`, adding only the report file. The body is the
Summary and the Verdict, and a line saying which commits were compared.

## Rules

- Never edit anything but the report file.
- If the port has no application code, stop and say so — there is nothing to
  review yet, and no report should be written.
- If you could not complete the review, say why in the report and mark the
  verdict FAIL. Do not open a PR carrying a report you know is incomplete
  without saying so in it.
