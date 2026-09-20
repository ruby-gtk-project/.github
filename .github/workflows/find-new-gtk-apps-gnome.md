---
description: |
  Reads apps.gnome.org, finds the apps that have no fork in the org, and opens
  a pull request adding them to registry.yml.

on:
  schedule: daily
  workflow_dispatch:

engine:
  id: copilot
  model: gpt-5

timeout-minutes: 30

permissions: read-all

network:
  # Without these the upstream URLs are redacted out of your own output as
  # `(gitlab.gnome.org/redacted)`, which is exactly the URL the registry needs.
  allowed: [defaults, github, "gitlab.gnome.org", "gitlab.com", "codeberg.org", "apps.gnome.org"]

tools:
  edit:
  bash: ["cat *", "ls *", "wc *", "grep *", "curl *", "jq *", "gh repo view *", "gh api *", "git diff*", "git status*"]
  github:
    toolsets: [repos, search]

safe-outputs:
  create-pull-request:
    title-prefix: "[registry] "
    labels: [registry]
    max: 1
    allowed-files: ["registry.yml"]
    if-no-changes: "ignore"
---

# Check the GNOME apps site

Every GNOME Core and Circle app should end up with a fork in this org.
`registry.yml` at the root of this repo is the list, three keys per entry:

```yaml
- app: Apostrophe
  repo: https://github.com/ApostropheEditor/Apostrophe
  fork: https://github.com/ruby-gtk-project/Apostrophe-rb
```

Your job is to find apps that are not in it and add them.

## Step 1 — List the apps

`https://apps.gnome.org/en-GB/` lists them in three sections. You want the
**core** and **circle** ones, not development tools. Each app links to its own
page at `https://apps.gnome.org/en-GB/<Name>/`.

The page is minified and its attributes are unquoted, so a pattern expecting
`href="x"` matches nothing — `href=Amberol/` is what it actually looks like.
Fetch it and work out the list yourself:

```sh
curl -sS https://apps.gnome.org/en-GB/ | grep -o 'id=[a-z-]*'
```

Sections run core, then circle, then development. Say how many apps you found
in each before going on.

## Step 2 — Find where each app's source lives

Read the app's own page. It links to the project's homepage or repository,
and that is the authority:

```sh
curl -sS https://apps.gnome.org/en-GB/Amberol/ | grep -o 'href=[^ >]*'
```

Most are not on GitHub — gitlab.gnome.org, gitlab.com and codeberg.org are
all common, and that is fine. The `repo` field records wherever the source
actually is; it does not have to be GitHub.

## Step 3 — Does it already have a fork

Before proposing anything, check both:

1. Is the app already in `registry.yml`? Compare the `repo` URL, not just the
   name — names collide, and a different project called Commit is a different
   project.
2. Does a fork already exist in the org that this file has simply not caught
   up with? Look for it:

```sh
gh repo view ruby-gtk-project/<name>-rb --json name,parent
```

Be careful here, because the obvious check is the one that fails. An app's
page usually points at GitLab while its fork was made from its GitHub home —
`Apostrophe` shows `gitlab.gnome.org/World/apostrophe` on the page and is
already forked as `Apostrophe-rb` from `ApostropheEditor/Apostrophe`. Matching
those two URLs against each other finds nothing, and you would propose an app
we have had all along. Check the fork name and the app identity, not just the
URL.

Anything that already has a fork is not new. Skip it silently.

## Step 4 — Add the new ones

For each genuinely new app, add an entry to `registry.yml` with the three
keys:

- `app` — the app's name as the site gives it
- `repo` — where its source actually lives, from Step 2
- `fork` — `https://github.com/ruby-gtk-project/<name>-rb`, the fork that will
  be created. It does not exist yet. That is the point: `check-and-fork-registry-apps` reads
  this file and creates whatever is missing, forking it when `repo` is on
  GitHub and mirroring it when it is not.

Keep the file's existing shape and ordering. Nothing else goes in it — no
status fields, no notes, no sections.

Then open one pull request with all of them. In the body, per app: what it is,
where its source is, and how you know it has no fork yet. Someone approves
this by reading it, and merging it is what causes the fork to be created.

## Rules

- If every app already has a fork, open no pull request and say so. That is a
  normal result, not a failure.
- Never remove or edit an existing entry. You only add.
- Never fork anything yourself.
