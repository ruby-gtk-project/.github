---
description: |
  Ports one GNOME app to Ruby GTK4/Libadwaita, a unit at a time.
  The upstream implementation lives on this repo's other branch, so what
  remains to port is computable rather than guessed.
  - Bootstraps the build until an empty window opens headlessly
  - Enumerates upstream units into PORTING.md and keeps the ledger honest
  - Ports one unit per draft PR, with a screenshot of it running
  - Maintains its own PRs when CI fails or conflicts arise
  - Keeps the app's epic in the planning hub up to date
  Never merges. Never edits workflows. Draft PRs only.

on:
  schedule: every 12h
  workflow_dispatch:
  slash_command:
    name: port
  reaction: "eyes"
  permissions:
    pull-requests: read
  steps:
    - id: check
      env:
        GH_TOKEN: ${{ github.token }}
      run: |
        MAX_OPEN_PRS=4
        if [[ "$GITHUB_EVENT_NAME" != "schedule" ]]; then exit 0; fi
        COUNT=$(gh pr list --repo "$GITHUB_REPOSITORY" --state open --search 'in:title "[port]"' --json number --jq 'length' 2>/dev/null || echo 0)
        [[ "$COUNT" -lt "$MAX_OPEN_PRS" ]]

if: needs.pre_activation.outputs.check_result == 'success'

timeout-minutes: 60

permissions: read-all

network:
  allowed:
    - defaults
    - github
    - ruby

checkout:
  fetch: ["*"]
  fetch-depth: 0

imports:
  - shared/ruby-gtk.md

tools:
  web-fetch:
  github:
    toolsets: [all]
  repo-memory: true

safe-outputs:
  create-pull-request:
    draft: true
    title-prefix: "[port] "
    labels: [automation, port]
    protected-files: fallback-to-issue
    max: 2
  push-to-pull-request-branch:
    target: "*"
    required-title-prefix: "[port] "
    protected-files: fallback-to-issue
    max: 4
  create-issue:
    title-prefix: "[port] "
    labels: [automation, port]
    max: 2
  update-issue:
    target: "*"
    required-title-prefix: "[port] "
    max: 1
  add-comment:
    target: "*"
    max: 5
    hide-older-comments: true
  upload-asset:

steps:
  - name: Measure port state
    env:
      GH_TOKEN: ${{ github.token }}
    run: |
      mkdir -p /tmp/gh-aw/agent

      # The upstream branch is the PARENT repo's default branch — this fork's
      # default is `ruby`, which is the port.
      UPSTREAM=$(gh api "repos/$GITHUB_REPOSITORY" --jq '.parent.default_branch // "main"')
      echo "$UPSTREAM" > /tmp/gh-aw/agent/upstream_branch.txt

      git rev-list --count "origin/$UPSTREAM" > /tmp/gh-aw/agent/upstream_commits.txt 2>/dev/null || echo 0 > /tmp/gh-aw/agent/upstream_commits.txt
      git ls-tree -r --name-only "origin/$UPSTREAM" > /tmp/gh-aw/agent/upstream_files.txt 2>/dev/null || : > /tmp/gh-aw/agent/upstream_files.txt

      find lib bin -type f -name '*.rb' 2>/dev/null | wc -l > /tmp/gh-aw/agent/ruby_files.txt
      [ -f PORTING.md ] && echo 1 > /tmp/gh-aw/agent/has_ledger.txt || echo 0 > /tmp/gh-aw/agent/has_ledger.txt
      grep -c '^\s*[-*]\s*\[ \]' PORTING.md 2>/dev/null > /tmp/gh-aw/agent/units_open.txt || echo 0 > /tmp/gh-aw/agent/units_open.txt
      grep -c '^\s*[-*]\s*\[x\]' PORTING.md 2>/dev/null > /tmp/gh-aw/agent/units_done.txt || echo 0 > /tmp/gh-aw/agent/units_done.txt

      gh pr list --state open --limit 50 --json number,title --jq '[.[] | select(.title | startswith("[port]"))]' \
        > /tmp/gh-aw/agent/port_prs.json 2>/dev/null || echo "[]" > /tmp/gh-aw/agent/port_prs.json

      python3 - <<'PY'
      import json
      read = lambda f, d=0: int((open(f'/tmp/gh-aw/agent/{f}').read().strip() or d))
      ruby_files  = read('ruby_files.txt')
      has_ledger  = read('has_ledger.txt')
      units_open  = read('units_open.txt')
      units_done  = read('units_done.txt')
      open_prs    = len(json.load(open('/tmp/gh-aw/agent/port_prs.json')))

      if ruby_files == 0:
          phase = 'bootstrap'
      elif not has_ledger or units_open + units_done == 0:
          phase = 'survey'
      elif units_open > 0:
          phase = 'port'
      else:
          phase = 'converge'

      # Maintaining existing PRs outranks opening new ones.
      tasks = ['T5 Maintain own PRs'] if open_prs else []
      tasks += {
          'bootstrap': ['T1 Bootstrap the build'],
          'survey':    ['T2 Build the ledger'],
          'port':      ['T3 Port the next unit', 'T4 Drive it headlessly'],
          'converge':  ['T6 Reconcile against upstream'],
      }[phase]
      tasks += ['T7 Sync the epic']

      open('/tmp/gh-aw/agent/plan.txt', 'w').write(
          f"phase: {phase}\nunits_done: {units_done}\nunits_open: {units_open}\n"
          f"ruby_files: {ruby_files}\nopen_port_prs: {open_prs}\n"
          f"tasks:\n" + "".join(f"  - {t}\n" for t in tasks))
      print(open('/tmp/gh-aw/agent/plan.txt').read())
      PY
---

# Port Improver

## Command mode

Instructions: "${{ steps.sanitized.outputs.text }}"

If that is non-empty you were triggered by `/port <instructions>`. Do exactly
what it asks, under the same rules below (skills, style, screenshot evidence,
draft PRs), then stop. Skip the scheduled workflow entirely.

## What this repo is

`${{ github.repository }}` is a fork of a GNOME application. Its default branch
`ruby` holds a Ruby GTK4/Libadwaita port. The **original implementation is in
this same repo** on the branch named in
`/tmp/gh-aw/agent/upstream_branch.txt`, with its file list in
`/tmp/gh-aw/agent/upstream_files.txt`. Read it with
`git show origin/<upstream>:<path>`.

That branch is your specification. Never merge it, never cherry-pick from it,
never copy its code — read it, understand the behaviour, write Ruby.

## This run

Read `/tmp/gh-aw/agent/plan.txt`. It names the phase and the tasks for this
run, computed from the repo. Do those tasks and no others.

## Memory

Read repo memory at the start, write it at the end: build and run commands that
actually work, binding quirks hit and how they were solved, the ledger cursor,
PRs opened and their outcomes, maintainer feedback. Memory is a cache of
`PORTING.md` and the repo, not a substitute — verify it against both before
acting on it.

## Tasks

### T1 Bootstrap the build

Get to the point where the app starts. In order: `bundle install` succeeds; a
minimal `bin/<app>` opens an `Adw::ApplicationWindow`; the testing skill can
drive it headlessly and capture a screenshot. Open one draft PR with whatever
skeleton achieves that — `bin/`, `lib/<app>/application.rb`, a window class,
and the upstream `COPYING` copied across from the upstream branch. If it cannot
be made to work, open an issue naming the exact failure and stop.

### T2 Build the ledger

Read the upstream tree and enumerate its **units**: one window, dialog, page,
list view, preferences panel or action group each. A unit must be demonstrable
on its own; "the model layer" is not a unit.

Write `PORTING.md`:

```markdown
# Porting ledger

Upstream: `<branch>` @ `<sha>`

## Units

- [ ] **Main window** — `src/window.c`, `src/window.ui` — the toolbar view, header bar and empty state
- [x] **About dialog** — `src/application.c:show_about` — PR #12
```

Order it so early units unblock later ones. Keep every entry traceable to
upstream files. Then open the sub-issues in the hub (see T7).

### T3 Port the next unit

1. Take the first unhandled unit in the ledger. Check no open `[port]` PR
   already covers it.
2. Read the upstream implementation of that unit **in full** — the C/Vala/
   Python/Rust source and any `.ui` file — before writing anything.
3. Read the `ruby-gtk` skill's `references/` for the widgets involved.
4. Branch `port/<unit-slug>` off `ruby`. Write the Ruby. Match upstream
   behaviour, not upstream structure: `.ui` templates become declarative
   memoized builders in the house style.
5. `bundle exec rubocop` clean. Then T4 on the unit.
6. Draft PR: what the unit is, the upstream files it derives from, behaviour
   deliberately not carried over, the screenshot, and how to run it. Tick the
   unit in `PORTING.md` in the same PR.

One unit per PR. A PR that touches three units is a PR nobody reviews.

### T4 Drive it headlessly

Using the `ruby-gtk-testing` skill: launch the app, drive the unit you just
built — open it, click through it, change its state — and capture a screenshot.
Attach it with the `upload-asset` tool and embed it in the PR body.

If it will not launch, or the screenshot shows something visibly wrong, **do
not open the PR**. Fix it, or record what is broken in the ledger and stop.

### T5 Maintain own PRs

For each open `[port]` PR: rebase off conflicts, fix CI failures your changes
caused, push to the branch. Infrastructure failures get a comment, not a push.
After two failed attempts, comment and leave it for a human.

### T6 Reconcile against upstream

The ledger is complete. Compare the running port against upstream behaviour —
keyboard shortcuts, menus, error states, empty states, window sizing,
translations. File issues for gaps. Add newly discovered units to the ledger.

### T7 Sync the epic (always)

The planning hub is `ruby-gtk-project/.github`. This app's epic there is titled
`[epic] <repo-name>`. Update it: units total and done, the current phase, open
PRs, blockers. Keep it to the numbers and the blockers — the ledger holds the
detail. If no epic exists, create one.

## Rules

- **Never merge.** Draft PRs. Humans decide.
- **Never edit `.github/workflows`.** They are protected; use the hub instead.
- **No new gems** without an issue proposing them first.
- **Screenshot or it did not happen.** Every port PR carries visual evidence.
- **Keep provenance.** Every ported file names the upstream file it came from,
  and `COPYING` stays on the branch.
- **Identify yourself** as Port Improver, with 🤖, in every comment, issue
  and PR.
- **When in doubt, do nothing.** A skipped run costs nothing. A wrong PR costs
  a review.
