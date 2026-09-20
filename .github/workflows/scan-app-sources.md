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
  edit:
  bash: ["cat *", "jq *", "ls *", "head *", "wc *", "grep *", "python3 *", "git diff*", "git status*"]
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

      # Deliberately NOT copied to /tmp. An earlier version handed the agent
      # a copy there and it edited the copy, so every run produced a perfect
      # pull request body and an empty patch.
      wc -l .github/port-registry.yml

safe-outputs:
  create-issue:
    max: 1
    labels: [registry-proposal]
---

# Scan app sources

Every GNOME Core and Circle app gets ported. `\.github/port-registry.yml` is the
list of the ones we know about. Your job is to find the apps that are missing
from it and add them.

## What you have

- `/tmp/gh-aw/agent/apps.json` — every app on apps.gnome.org, with its group
  (`core` or `circle`), its app ID, and whatever `vcs_browser`, `homepage` and
  `bugtracker` Flathub holds for it.
- `.github/port-registry.yml` — the registry, in the working directory. This
  is the real file and the only copy: read it and write it **at that path**.
  There is deliberately no copy under `/tmp`, because a previous run edited
  one and its pull request came out empty. `forked` entries are apps we
  already have; `candidates` are apps we know about but have no GitHub home
  for yet.

## Step 0 — Count what you were given

`jq length /tmp/gh-aw/agent/apps.json` and say the number. Every app in that
file is in scope. A previous run reported working through "all 83 apps" when
the file held 99 — if your count and the file disagree, the file is right.

## Step 1 — What needs work this run

Two kinds of app need you, and most runs will have both:

1. **Candidates with `status: needs-github-home`.** These are already in the
   registry and are the main event — a port cannot start until one of them has
   a GitHub home. Work through every single one.
2. **Apps on the page that the registry does not mention at all.** Match on
   substance, not string equality: `Apostrophe` on the page is the same app as
   fork `Apostrophe-rb` with upstream `ApostropheEditor/Apostrophe`, and is not
   new.

An app already being listed as a candidate is **not** a reason to skip it.
Being listed with no `github:` field is the problem you are here to solve. A
run that finds every app "already represented" and opens no pull request has
done nothing.


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

## Step 3 — Report what you found

You cannot edit files in this workflow. Do not try: every attempt so far has
produced a flawless pull request body and an empty patch, because the agent
container's writes never reach the checkout. Report instead, and a script
applies it.

Open one issue. Its body must contain a fenced `yaml` block, and that block is
what gets applied — everything outside it is for the human reading it.

```yaml
- app: Amberol
  status: ready-to-import
  vcs: https://gitlab.gnome.org/World/amberol
- app: Bustle
  status: ready-to-fork
  github: bustle/bustle
- app: Something
  status: needs-github-home
  checked: 2026-09-20 searched GitHub for the app id and the author, nothing live
```

One entry per candidate you resolved, using the exact `app` name from the
registry. `status` is one of the three from Step 2. `ready-to-fork` needs a
`github:` field; `ready-to-import` needs a `vcs:` field; `needs-github-home`
needs a `checked:` line saying what you tried.

Outside the block, give the evidence per app: what convinced you that repo is
that app, with links. Someone approves this by reading it.

Do not list candidates you did not resolve this run.

## Rules

- One pull request per run, covering every new app.
- An app you are unsure about still goes in, as `needs-github-home`, with your
  doubt written down. Leaving it out entirely is how an app goes missing for a
  month with nobody noticing.
- Never fork anything yourself, and never edit any file but the registry.
  Merging the pull request is what authorises a fork.
