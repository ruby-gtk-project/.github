---
description: |
  Reads registry.yml and makes every fork in it exist — forking the ones on
  GitHub, mirroring the ones that are not.

on:
  schedule: daily
  workflow_dispatch:
    inputs:
      only:
        description: "Act on a single app by name (blank = all)"
        required: false
        type: string

engine:
  id: copilot
  model: gpt-5

timeout-minutes: 45

permissions: read-all

network:
  allowed: [defaults, github, "gitlab.gnome.org", "gitlab.com", "codeberg.org"]

tools:
  bash:
    - "cat *"
    - "ls *"
    - "wc *"
    - "grep *"
    - "gh repo view *"
    - "gh repo fork *"
    - "gh repo create *"
    - "gh api *"
    - "git clone *"
    - "git ls-remote *"
    - "git push *"
    - "git -C *"
    - "rm -rf /tmp/*"
  github:
    toolsets: [repos]
---

# Check and fork registry apps

`registry.yml` at the root of this repo lists every app the campaign covers:
its name, where its source lives upstream, and the fork we keep in the org.
Your job is to make every one of those forks exist.

## What to do

Read `registry.yml`. For each entry, check whether the repository named by
`fork` exists:

```sh
gh repo view ruby-gtk-project/<name> --json name
```

**If it exists, do nothing at all.** Do not update it, do not re-fork it, do
not touch its branches. Most runs will find everything already there and
should finish having changed nothing. That is success, not a wasted run.

If it does not exist, create it from `repo`:

**When `repo` is on github.com** — fork it into the org under the exact name
the `fork` URL ends with:

```sh
gh repo fork <owner>/<name> --org ruby-gtk-project --fork-name <name>-rb --clone=false
```

**When `repo` is anywhere else** — gitlab.gnome.org, gitlab.com, codeberg.org
— it cannot be forked, because forking is a GitHub operation. Mirror it in
instead:

```sh
git ls-remote --symref <repo> HEAD          # learn its default branch first
git clone --mirror <repo> /tmp/m
gh repo create ruby-gtk-project/<name>-rb --public --description "Ruby GTK4 port of <app>. Upstream: <repo>"
git -C /tmp/m push https://github.com/ruby-gtk-project/<name>-rb "refs/heads/*:refs/heads/*" "refs/tags/*:refs/tags/*"
rm -rf /tmp/m
```

Push branches and tags only, as above. A plain `--mirror` push also carries
the forge's own refs — GitLab merge-request refs and similar — and GitHub
rejects those, failing the whole push.

Keep the upstream's default branch name as it is. The port issue for each app
tells whoever picks it up that the original is on that branch, and that has to
stay true after a mirror.

Delete each clone as soon as you have pushed it. Some of these repositories
are large and they do not all fit on the runner at once, so do them one at a
time rather than cloning everything first.

## Rules

- Never delete or overwrite a repository that already exists.
- If a `repo` URL is unreachable, say so and move on to the next entry. One
  dead upstream must not stop the rest.
- Never edit `registry.yml`. Entries arrive there by pull request; you only
  act on what is already in it.
- At the end, say exactly what you created and what you skipped, with counts.
  If you created nothing because everything existed, say that plainly.
