---
description: |
  Scans apps.gnome.org for GNOME Core and Circle apps, works out where each
  one's source actually lives, and opens a pull request adding any app the
  port registry does not have yet.

on:
  schedule: weekly on tuesday
  workflow_dispatch:

engine:
  id: copilot
  model: gpt-5

timeout-minutes: 30

permissions: read-all

network:
  allowed: [defaults, github]

tools:
  bash: ["cat *", "jq *", "ls *", "head *", "wc *", "grep *"]
  github:
    toolsets: [repos, search]

steps:
  - name: Inventory apps.gnome.org
    env:
      GH_TOKEN: ${{ github.token }}
    run: |
      set -euo pipefail
      mkdir -p /tmp/gh-aw/agent
      curl -sS --max-time 60 https://apps.gnome.org/en-GB/ -o /tmp/gh-aw/agent/apps.html

      # The page is minified with unquoted attributes, so patterns that expect
      # href="x" match nothing. Sections run core -> circle -> development.
      python3 - <<'PY'
      import re, json, urllib.request, time
      h = open('/tmp/gh-aw/agent/apps.html', encoding='utf-8').read()
      def cards(a, b):
          seg = h[h.index('id=' + a):h.index('id=' + b)]
          return re.findall(r'href=([A-Za-z0-9._-]+)/>\s*<img[^>]*app-icon/scalable/([A-Za-z0-9._-]+)\.svg', seg)
      groups = {'core': cards('core', 'circle'), 'circle': cards('circle', 'development')}
      out = []
      for group, cs in groups.items():
          for name, appid in cs:
              urls = {}
              try:
                  with urllib.request.urlopen(f'https://flathub.org/api/v2/appstream/{appid}', timeout=20) as r:
                      urls = json.load(r).get('urls') or {}
              except Exception:
                  pass
              out.append({'group': group, 'app': name, 'id': appid,
                          'vcs': urls.get('vcs_browser') or '',
                          'homepage': urls.get('homepage') or '',
                          'bugtracker': urls.get('bugtracker') or ''})
              time.sleep(0.05)
      json.dump(out, open('/tmp/gh-aw/agent/apps.json', 'w'), indent=1)
      print(len(out), 'apps')
      PY

      cp .github/port-registry.yml /tmp/gh-aw/agent/registry.yml
      wc -l /tmp/gh-aw/agent/registry.yml

safe-outputs:
  create-pull-request:
    title-prefix: "[registry] "
    labels: [registry]
    max: 1
    allowed-files: [".github/port-registry.yml"]
    if-no-changes: "ignore"
---

# Scan app sources

Every GNOME Core and Circle app gets ported. `\.github/port-registry.yml` is the
list of the ones we know about. Your job is to find the apps that are missing
from it and add them.

## What you have

- `/tmp/gh-aw/agent/apps.json` — every app on apps.gnome.org, with its group
  (`core` or `circle`), its app ID, and whatever `vcs_browser`, `homepage` and
  `bugtracker` Flathub holds for it.
- `/tmp/gh-aw/agent/registry.yml` — the current registry. `forked` entries are
  apps we already have; `candidates` are apps we know about but have no GitHub
  home for yet.

## Step 1 — Which apps are new

An app is new if neither its name nor its source repo appears anywhere in the
registry. Match on substance, not string equality: `Apostrophe` in the registry
as fork `Apostrophe-rb` with upstream `ApostropheEditor/Apostrophe` is the same
app as `Apostrophe` on the page, and is not new.

## Step 2 — Find where it really lives on GitHub

This is the part that needs you, and the reason this is not a script.

Only about a quarter of these apps list a GitHub URL. The rest sit on
`gitlab.gnome.org`, `gitlab.com` or `codeberg.org` — and a good number of those
*also* have a GitHub home that the page never mentions. There is no rule that
derives one from the other:

- `gitlab.gnome.org/GNOME/<x>` is usually mirrored to `github.com/GNOME/<x>`.
  Usually — verify it, do not assume it.
- `gitlab.gnome.org/World/<x>` is a third-party app hosted on GNOME's GitLab.
  Its GitHub home, if it has one, is under the **author's** account, not
  GNOME's. Apostrophe lives at `gitlab.gnome.org/World/apostrophe` and its
  GitHub home is `ApostropheEditor/Apostrophe`. No rewrite of the URL gets you
  there; you have to go and look.
- Some genuinely have no GitHub presence at all. That is a fine answer.

Search GitHub for the app name, the app ID, the upstream author. Check that
what you find is the same app and not a namesake, a fork of a fork, or an
abandoned copy — compare the description, the language, the recent commits
against the upstream you started from. A mirror that stopped updating two years
ago is not a home; say so rather than registering it.

## Step 3 — The pull request

Add each new app to `.github/port-registry.yml` and open one pull request with
all of them. Keep the file's existing shape and ordering.

- Found a GitHub home you are confident in → add it under `candidates` with
  `status: ready-to-fork` and a `github:` field naming `owner/repo`.
- Found nothing, or nothing you trust → add it under `candidates` with
  `status: needs-github-home` and leave `github` out.
- Put what convinced you in the PR body, per app, with links. Someone approves
  this by reading it, so a bare list of names is not enough.

Never edit the `forked` section. Those are existing forks; this workflow only
proposes additions.

If nothing is new, say so and open no pull request.

## Rules

- One pull request per run, covering every new app.
- An app you are unsure about still goes in, as `needs-github-home`, with your
  doubt written down. Leaving it out entirely is how an app goes missing for a
  month with nobody noticing.
- Never fork anything yourself, and never edit any file but the registry.
  Merging the pull request is what authorises a fork.
