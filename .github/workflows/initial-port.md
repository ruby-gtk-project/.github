---
description: |
  Finds org repos that are waiting to be ported and gives each one an
  "Initial port" issue on the org's Initial port project.

on:
  schedule: daily
  workflow_dispatch:

engine:
  id: copilot
  model: gpt-5

timeout-minutes: 20

permissions: read-all

network:
  allowed: [defaults, github]

tools:
  bash: ["gh *", "jq *"]
  github:
    toolsets: [repos, issues]

safe-outputs:
  create-project:
    target-owner: ruby-gtk-project
    github-token: ${{ secrets.GH_AW_PROJECT_GITHUB_TOKEN }}
  update-project:
    max: 100
    project: https://github.com/orgs/ruby-gtk-project/projects/<PORT_PROJECT_NUMBER>
    github-token: ${{ secrets.GH_AW_PROJECT_GITHUB_TOKEN }}
  create-issue:
    max: 100
    labels: [port]
    deduplicate-by-title: true
    allowed-repos: ["ruby-gtk-project/*"]
---

# Initial port

Every app in this org gets ported to Ruby GTK4. Your job is to work out which
repos are still waiting for that work to start, and make sure each one has an
issue on the org's **Initial port** project.

## Step 1 — Which repos are port targets

List the org's repos with `gh repo list ruby-gtk-project --limit 300 --json
name,isArchived,isFork,description`. The name tells you nothing — plenty of
repos here end in `-rb` and are not port targets, and the org also holds
tooling, demos and infrastructure. Look at each repo instead:

A repo **is** a port target when all of these hold:

- It is a fork of an upstream app (`gh api repos/ruby-gtk-project/<repo> --jq
  '.parent.full_name'` returns something).
- Its default branch is `ruby`.
- That `ruby` branch carries the port scaffolding and no application yet:
  `AGENTS.md`, `.claude/skills/ruby-gtk/`, `flake.nix`, `Gemfile`, `cops/` —
  but nothing meaningful under `lib/` or `bin/`.
- The upstream branch (`.parent.default_branch`) holds a real GUI application.

A repo is **not** a port target when any of these hold:

- It is not a fork — it is someone's own project, tooling, demos or org
  infrastructure.
- It has no `ruby` branch, or `ruby` is not the default.
- The `ruby` branch already has an app under `lib/`/`bin/` — that port has
  started, and this issue is only for ones that have not.
- It is archived.

If a repo is genuinely ambiguous, **leave it alone** and list it at the end of
your run under "Skipped — unclear". Do not guess. A wrong issue in someone's
repo is worse than a missing one.

## Step 2 — The project

Find the org project titled **Initial port**
(`gh project list --owner ruby-gtk-project`). If it does not exist, create it
with `create_project`, titled exactly `Initial port`.

Read its current items so you do not duplicate work: every port target that
already has an item on the board is done, skip it.

## Step 3 — The issues

For each port target with no item on the board, call `create_issue` with
`repo` set to that fork, title exactly `Initial port`, and this body, with
`<upstream>` replaced by that repo's actual upstream branch name:

```markdown
Port this app to Ruby GTK4/Libadwaita.

1. Clone the repo. The default branch `ruby` is the port — it has the dev shell, rubocop config and skills, but no app code yet.
2. The original implementation is on the `<upstream>` branch of this same repo. That is the spec: read it, don't copy it.
3. Port it using the `ruby-gtk` skill in `.claude/skills/`, and check it actually runs with `ruby-gtk-testing`.
4. Push to `ruby`.

This is a full parity port. Nothing is left out: every window, dialog, page, menu item, keyboard shortcut, preference, action, empty state and error state the original has, the port has. Working through the `<upstream>` source file by file is the only way to know you have them all.

It is done when the app does everything the original does.
```

Then add each issue to the project with `update_project`. **Always pass the
project's real full URL in every call** — the configured default contains a
`<PORT_PROJECT_NUMBER>` placeholder and is not a real board.

## Rules

- Only ever create the one issue per repo, with that exact title. It is
  deduplicated by title, so a repo that already has one is untouched.
- Never create issues in repos you could not positively identify as port
  targets.
- If every port target is already on the board, do nothing and say so.
