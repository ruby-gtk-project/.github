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
  bash: ["cat *", "jq *"]
  github:
    toolsets: [repos, issues]

steps:
  - name: Inventory the org
    env:
      GH_TOKEN: ${{ github.token }}
      PROJECT_TOKEN: ${{ secrets.GH_AW_PROJECT_GITHUB_TOKEN }}
    run: |
      mkdir -p /tmp/gh-aw/agent
      ORG=ruby-gtk-project

      gh repo list "$ORG" --limit 300 --json name,isArchived,isFork,hasIssuesEnabled,defaultBranchRef \
        --jq '.[] | {name, archived: .isArchived, fork: .isFork, issues_enabled: .hasIssuesEnabled, default_branch: .defaultBranchRef.name}' \
        > /tmp/gh-aw/agent/repos.jsonl

      : > /tmp/gh-aw/agent/detail.jsonl
      while read -r line; do
        name=$(echo "$line" | jq -r .name)
        parent=$(gh api "repos/$ORG/$name" --jq '{parent: (.parent.full_name // null), upstream_branch: (.parent.default_branch // null)}' 2>/dev/null || echo '{}')
        ruby=$(gh api "repos/$ORG/$name/git/trees/ruby?recursive=1" \
               --jq '[.tree[].path] | {scaffolding: (map(select(. == "AGENTS.md" or startswith(".claude/skills/ruby-gtk"))) | length), app: (map(select((startswith("lib/") or startswith("bin/")) and endswith(".rb"))) | length)}' 2>/dev/null || echo '{"scaffolding":0,"app":0,"no_ruby_branch":true}')
        echo "$line $parent $ruby" | jq -s add >> /tmp/gh-aw/agent/detail.jsonl
      done < /tmp/gh-aw/agent/repos.jsonl

      GH_TOKEN="$PROJECT_TOKEN" gh project list --owner "$ORG" --format json \
        > /tmp/gh-aw/agent/projects.json 2>/dev/null || echo '{"projects":[]}' > /tmp/gh-aw/agent/projects.json

      num=$(jq -r --arg t "Initial port" '.projects[]? | select(.title==$t) | .number' /tmp/gh-aw/agent/projects.json)
      if [ -n "$num" ]; then
        GH_TOKEN="$PROJECT_TOKEN" gh project item-list "$num" --owner "$ORG" --limit 500 --format json \
          > /tmp/gh-aw/agent/project-items.json 2>/dev/null || echo '{"items":[]}' > /tmp/gh-aw/agent/project-items.json
      else
        echo '{"items":[]}' > /tmp/gh-aw/agent/project-items.json
      fi

      wc -l /tmp/gh-aw/agent/detail.jsonl

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

The inventory has already been gathered for you. Read these files:

- `/tmp/gh-aw/agent/detail.jsonl` — one line per org repo: `name`, `archived`,
  `fork`, `issues_enabled`, `default_branch`, `parent`, `upstream_branch`, and
  from its `ruby` branch a `scaffolding` count (how many of `AGENTS.md` and the
  `.claude/skills/ruby-gtk` files are present) and an `app` count (`.rb` files
  under `lib/` or `bin/`). `no_ruby_branch: true` means there is no `ruby`
  branch at all.
- `/tmp/gh-aw/agent/project-items.json` — what is already on the board.

The name tells you nothing — plenty of repos here end in `-rb` and are not port
targets, and the org also holds tooling, demos and infrastructure. Judge on the
inventory:

A repo **is** a port target when all of these hold:

- `parent` is not null — it is a fork of an upstream app.
- `default_branch` is `ruby`.
- `scaffolding` is non-zero and `app` is zero — the branch is set up for the
  port but the port has not been written.
- `archived` is false.

A repo is **not** a port target when any of these hold:

- `parent` is null — it is someone's own project, tooling, demos or org
  infrastructure.
- `no_ruby_branch`, or `default_branch` is not `ruby`.
- `app` is non-zero — that port has started, and this issue is only for ones
  that have not.
- `archived` is true.
- `issues_enabled` is false — the issue cannot be filed there. List these
  separately under "Blocked — issues disabled" so they can be fixed.

If a repo is genuinely ambiguous, **leave it alone** and list it at the end of
your run under "Skipped — unclear". Do not guess. A wrong issue in someone's
repo is worse than a missing one.

## Step 2 — The project

`/tmp/gh-aw/agent/projects.json` lists the org's projects. If none is titled
**Initial port**, create it with `create_project`, titled exactly that.

`/tmp/gh-aw/agent/project-items.json` is what is already on the board — every
port target already there is done, skip it.

## Step 3 — The issues

For each port target with no item on the board, call `create_issue` with
`repo` set to that fork, title exactly `Initial port`, and this body, with
`<upstream>` replaced by that repo's `upstream_branch` from the inventory:

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
