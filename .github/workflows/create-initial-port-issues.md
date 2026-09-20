---
description: |
  Finds org repos that are waiting to be ported and gives each one an
  "Initial port" issue on the org's Initial port project.

on:
  schedule: weekly
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
inventory, and on what the upstream repo actually is.

A repo **is** a port target when all of these hold:

- `parent` is not null — it is a fork of an upstream app.
- `archived` is false.
- the upstream is an **application** — something a user launches. A toolkit, a
  demo collection, an examples repo or a set of design files is not, however
  much GTK code it contains.
- no other fork in the org has the same `parent`. Where two do, exactly one is
  the port: keep whichever is already on the board, and if neither is, keep the
  one whose name follows the `<app>-rb` convention.

A repo is **not** a port target when any of these hold:

- `parent` is null — it is someone's own project, tooling, demos or org
  infrastructure.
- `archived` is true.
- the upstream is not an application, by the test above.
- another fork of the same upstream is already the port target.

Deliberately absent from that list: how much has been ported, and whether the
`ruby` branch is scaffolded.

- **Port progress is not a condition.** A fork with a half-written port is
  still a port target and still needs its issues — that is what the board's
  Status field is for. Gating the issue on `app == 0` is how `console-rb`,
  `gnome-contacts-rb` and `gnome-logs-rb` — the three pilots — sat off the
  board for a month while this workflow reported success every day.
- **Scaffolding is not a condition, and not your job.** The `Scaffold port forks`
  workflow creates the orphan `ruby` branch and keeps `port-scaffold/` in sync
  on it for every fork on the board. An unscaffolded fork is one you
  should add, not skip; adding it is what causes it to be scaffolded.

The `scaffolding` and `app` counts in the inventory are there to tell you what
state a port is in, not whether it belongs on the board.

If a repo is genuinely ambiguous, **leave it alone** and list it at the end of
your run under "Skipped — unclear". Do not guess. A wrong issue in someone's
repo is worse than a missing one.

## Step 2 — The project

`/tmp/gh-aw/agent/projects.json` lists the org's projects. If none is titled
**Initial port**, create it with `create_project`, titled exactly that.

`/tmp/gh-aw/agent/project-items.json` is what is already on the board. Each
port target gets **two** issues, so check for them by title separately — a
repo with `Initial port: <repo>` on the board may still be missing its
`Gem release: <repo>`.

## Step 3 — The issues

The issues live **here**, in `${{ github.repository }}` — one per port target,
all on the board. Do not create issues in the forks.

Each port target gets two issues: the port itself, and the release checklist
that says when it is finished. Create whichever of the two is not already on
the board.

### The two bodies

Both bodies are files in this repo. **Copy the file's contents verbatim** into
the issue:

- `.github/port-issues/initial-port.md` for `Initial port: <repo>`, label
  `port`
- `.github/port-issues/gem-release.md` for `Gem release: <repo>`, label
  `gem-release`

Substitute only two placeholders: `{{REPO}}` with the fork's name, and
`{{UPSTREAM}}` with its `upstream_branch` from the inventory.

Do not summarise, shorten, reword or improve them. This is not a style
preference. A previous run wrote its own versions instead and produced 79
issues averaging 860 characters against a 2310 character template, with the
whole release checklist paraphrased away — `Gem release: console-rb` came out
as "Release console-rb to rubygems.org." and nothing else.

Then add each issue to the project with `update_project`. **Always pass the
project's real full URL in every call** — the configured default contains a
`<PORT_PROJECT_NUMBER>` placeholder and is not a real board.

## Rules

- Two issues per port target — `Initial port: <repo>` and `Gem release: <repo>`
  — always in this repo. Titles are deduplicated, so a target that already has
  one of them keeps it and only the missing one is created. Check for the two
  **separately**: at the time of writing every target on the board has its
  `Initial port` issue and not one has its `Gem release` issue, which is what
  happens when a target is treated as done because one of the pair exists.
- Never create issues in repos you could not positively identify as port
  targets.
- If every port target already has both issues on the board, do nothing and
  say so.
