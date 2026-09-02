---
description: |
  Ports one GNOME app to Ruby GTK4/Libadwaita. The upstream implementation is
  on this repo's other branch. Two passes per run: port, then prove nothing
  was skipped.

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
        if [[ "$GITHUB_EVENT_NAME" != "schedule" ]]; then exit 0; fi
        COUNT=$(gh pr list --repo "$GITHUB_REPOSITORY" --state open --search 'in:title "[port]"' --json number --jq 'length' 2>/dev/null || echo 0)
        [[ "$COUNT" -lt 4 ]]

if: needs.pre_activation.outputs.check_result == 'success'

engine: claude

timeout-minutes: 60

permissions: read-all

network:
  allowed: [defaults, github, ruby]

checkout:
  fetch: ["*"]
  fetch-depth: 0

imports:
  - shared/ruby-gtk.md

tools:
  github:
    toolsets: [all]

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
    max: 4
  create-issue:
    title-prefix: "[port] "
    labels: [automation, port]
    max: 2
  upload-asset:

steps:
  - name: Find the upstream branch
    env:
      GH_TOKEN: ${{ github.token }}
    run: |
      mkdir -p /tmp/gh-aw/agent
      gh api "repos/$GITHUB_REPOSITORY" --jq '.parent.default_branch // "main"' \
        > /tmp/gh-aw/agent/upstream_branch.txt
      cat /tmp/gh-aw/agent/upstream_branch.txt
---

# Port Improver

`${{ github.repository }}` is a fork of a GNOME app. The default branch `ruby`
holds a Ruby GTK4/Libadwaita port. **The original implementation is in this
repo**, on the branch named in `/tmp/gh-aw/agent/upstream_branch.txt`. Read it
with `git show origin/<upstream>:<path>`.

That branch is the specification. Read it, understand the behaviour, write
Ruby. Do not copy its code.

## Instructions: "${{ steps.sanitized.outputs.text }}"

If that is non-empty, do exactly what it says, under the rules below, then stop.

## Pass 1 — Port

If `PORTING.md` does not exist, create it first: read the whole upstream tree
and enumerate **every** user-visible feature — every window, dialog, page, menu
item, keyboard shortcut, preference, action, empty state, error state. One
checkbox each, each naming its upstream file. That list is the definition of
done for this app; an incomplete list is the only way this port can fail
silently, so be exhaustive before you write a line of Ruby.

Then take the next unticked entry and port it:

- Read that feature's upstream implementation in full, including its `.ui` file.
- Read the `ruby-gtk` skill's `references/` for the widgets involved.
- Branch `port/<slug>` off `ruby`, write it in the house style, `bundle exec
  rubocop` clean.
- Run the app with the `ruby-gtk-testing` skill, drive the feature, capture a
  screenshot, attach it with `upload-asset`.
- Draft PR: what it is, the upstream files it came from, the screenshot. Tick
  the box in `PORTING.md` in the same PR.

One feature per PR. If the app does not build yet, that is the only thing you
work on this run.

## Pass 2 — Prove nothing was skipped

Before you finish, go back to the upstream source — not to `PORTING.md`, not to
your own diff — and check the feature you just ported against it, line by line.

Answer these in the PR body, explicitly:

- Every branch of the upstream code path for this feature: which ones did you
  implement, and which did you not?
- Every signal, action, shortcut and menu entry upstream wires to it: ported,
  or not?
- Every error and empty state upstream handles: ported, or not?

Anything not ported is either **listed as a new unticked entry in
`PORTING.md`** or named in the PR under "Deliberately not carried over" with a
reason. Silence is not an option — a missing feature that nobody wrote down is
the one failure mode that matters here.

If that check finds you skipped something small, fix it now rather than filing
it. If it finds you skipped something large, say so plainly in the PR.

## Rules

- Draft PRs only. Never merge. Never edit `.github/workflows`.
- Screenshot or it did not happen.
- Every ported file names the upstream file it derives from. `COPYING` stays.
- No new gems without an issue first.
- 🤖 Port Improver, in everything you write.
