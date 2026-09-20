---
description: |
  Every fork in registry.yml has a scaffolded `ruby` branch matching
  port-scaffold/.

on:
  schedule: daily
  workflow_dispatch:
    inputs:
      only:
        description: "Reconcile a single fork by name (blank = all)"
        required: false
        type: string

engine:
  id: copilot
  model: gpt-5

timeout-minutes: 60

permissions: read-all

network:
  allowed: [defaults, github]

tools:
  bash:
    - "cat *"
    - "ls *"
    - "wc *"
    - "grep *"
    - "diff *"
    - "cp *"
    - "sed *"
    - "rm -rf /tmp/*"
    - "gh repo view *"
    - "gh api *"
    - "git clone *"
    - "git -C *"
    - ".github/aw/apply-port-scaffold.sh *"
  github:
    toolsets: [repos, issues]
---

# Reconcile forks

`registry.yml` lists every app and its fork. For each fork, two things have
to be true. Work through them fork by fork, and change nothing that is already
correct — most runs should find almost everything in order.

## 1 — The `ruby` branch exists

`ruby` is an orphan branch: no upstream history, the port is written on it,
and it is the fork's default branch. If a fork has no `ruby` branch, create it
with the script, which does the whole setup in one go:

```sh
.github/aw/apply-port-scaffold.sh <fork-name>
```

It refuses if `ruby` already exists, so it is safe to be wrong about this.

## 2 — The scaffold on it is current

`port-scaffold/` in this repo is what every `ruby` branch starts from. Two
parts of it are ours outright and must match exactly:

- `.claude/skills/` — the six skills
- `cops/` — the custom rubocop cops

Clone the fork's `ruby` branch shallowly, compare those two against
`port-scaffold/`, and if they differ, copy ours over, commit and push.

**Everything else in `port-scaffold/` is seeded once and never overwritten** —
`flake.nix`, `Gemfile`, `.rubocop.yml`, `.envrc`, `.gitignore`, `AGENTS.md`,
`CLAUDE.md`. A real port grows these: `console-rb`'s `flake.nix` is 229 lines
away from the scaffold's and `gnome-contacts-rb` has its own gems. Overwriting
them breaks working ports. Copy them only when the file is absent, and when
you write `AGENTS.md` replace `{{APP}}` with the app name.

Delete each clone once you are done with it, and do one at a time — the whole
fleet does not fit on the runner.

## Rules

- Never delete a repository, a branch or an issue.
- Never touch a fork's `lib/`, `bin/`, `test/` or any other port code. You
  maintain the scaffold, nothing else. The two port issues belong to
  `initial-port`, not to you.
- Never edit `registry.yml`.
- If a fork in the registry does not exist, say so and move on — `Fork or
  mirror` creates it, not you.
- Report counts at the end: how many forks were already correct, what you
  changed, and anything that failed.
