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
  # Without these, every non-GitHub URL is redacted out of the agent's output
  # as `(gitlab.gnome.org/redacted)` — which is precisely the upstream URL the
  # import route needs.
  allowed: [defaults, github, "gitlab.gnome.org", "gitlab.com", "codeberg.org", "flathub.org", "apps.gnome.org"]

tools:
  edit:
  bash: ["cat *", "jq *", "ls *", "head *", "wc *", "grep *", "python3 *", "curl *", "git diff*", "git status*"]
  github:
    toolsets: [repos, search]

steps:
  - name: Catalogue the apps
    env:
      GH_TOKEN: ${{ github.token }}
    run: |
      set -euo pipefail
      mkdir -p /tmp/gh-aw/agent
      curl -sS --max-time 60 https://apps.gnome.org/en-GB/ -o /tmp/gh-aw/agent/index.html

      # This step only catalogues what is on the page: name, app id, and the
      # URL of the app's own page. It deliberately does NOT try to work out
      # where the source lives — that is the agent's job, by reading each
      # app page, because no rule maps an app to its repository reliably.
      #
      # The page is minified with unquoted attributes, so patterns expecting
      # href="x" match nothing. Sections run core -> circle -> development.
      python3 - <<'PY'
      import re, json
      h = open('/tmp/gh-aw/agent/index.html', encoding='utf-8').read()
      def cards(a, b):
          seg = h[h.index('id=' + a):h.index('id=' + b)]
          return re.findall(r'href=([A-Za-z0-9._-]+)/>\s*<img[^>]*app-icon/scalable/([A-Za-z0-9._-]+)\.svg', seg)
      out = []
      for group, cs in {'core': cards('core', 'circle'), 'circle': cards('circle', 'development')}.items():
          for name, appid in cs:
              out.append({'group': group, 'app': name, 'id': appid,
                          'page': f'https://apps.gnome.org/en-GB/{name}/'})
      json.dump(out, open('/tmp/gh-aw/agent/apps.json', 'w'), indent=1)
      print(len(out), 'apps catalogued')
      PY

safe-outputs:
  create-pull-request:
    title-prefix: "[registry] "
    labels: [registry]
    max: 1
    allowed-files: ["port-registry.yml"]
    if-no-changes: "ignore"
---

# Scan app sources

Every GNOME Core and Circle app gets ported. `\.github/port-registry.yml` is the
list of the ones we know about. Your job is to find the apps that are missing
from it and add them.

## What you have

- `/tmp/gh-aw/agent/apps.json` — every app on apps.gnome.org: its group
  (`core` or `circle`), its app ID, and `page`, the URL of its own page on
  apps.gnome.org. Where its source lives is **not** in this file. You find
  that by reading the pages.
- `port-registry.yml` — the registry, at the root of the working directory.
  This is the real file and the only copy: read it and write it **at that
  path**. There is deliberately no copy under `/tmp`. `forked` entries are
  apps we already have; `candidates` are apps we know about but have no
  GitHub home for yet.

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


## Step 2 — Read each app's page to find its source

Every app has a page at the `page` URL in `apps.json`, and that page links to
the project's own homepage or repository. Fetch it and read it:

```sh
curl -sS https://apps.gnome.org/en-GB/Amberol/ | grep -o 'href=[^ >]*'
```

That page is the authority on where the app lives. Do not guess from the app
ID, and do not assume a Flathub record is current.

What you find there is usually not GitHub, and that is the whole difficulty:

- `gitlab.gnome.org/GNOME/<x>` is usually mirrored to `github.com/GNOME/<x>`.
  Usually — check the mirror exists and is not years behind, do not assume it.
- `gitlab.gnome.org/World/<x>` is a third-party app hosted on GNOME's GitLab.
  Its GitHub home, if it has one, is under the **author's** account, not
  GNOME's. Apostrophe lives at `gitlab.gnome.org/World/apostrophe` and its
  GitHub home is `ApostropheEditor/Apostrophe`. No rewrite of the URL gets you
  there — you have to search for it.
- A custom domain is usually a redirect or a project site. Follow it.
- Some genuinely have no GitHub presence. That is a fine answer, and it means
  the app gets imported rather than forked.

When a page points somewhere other than GitHub, search GitHub for the app
name, the app ID and the author before concluding there is no GitHub home.
Check what you find is the same app and not a namesake, a fork of a fork, or
a mirror that stopped updating years ago.

## Step 3 — Update the registry and open the pull request

Edit `port-registry.yml` at the root of the working directory, then open one
pull request with all of your changes.

For each candidate you resolved, set its `status` and add the field that
status requires:

- `ready-to-fork` — a real GitHub home. Add `github: owner/repo`.
- `ready-to-import` — no GitHub home, but the upstream git URL works. Keep
  the existing `vcs:`; it is already correct in the registry, and non-GitHub
  URLs are redacted out of your output anyway.
- `needs-github-home` — nothing works. Add `checked:` with today's date and
  one line on what you tried, so the next run does not repeat it.

**A candidate that turns out to be an app we already forked should be deleted
from `candidates` entirely, not given a status.** This happens often: the
first candidate list was built by matching Flathub's `vcs_browser` against
fork parents, which misses every app whose page lists GitLab while its fork
came from a GitHub home. 27 of the first 50 candidates were already forked.
Check `forked` and the fork names before proposing anything — `Apostrophe` is
already there as `Apostrophe-rb`.

Never edit the `forked` section otherwise. Entries move there when a fork or
import actually succeeds.

In the pull request body, give the evidence per app: what convinced you that
repo is that app, with links. Someone approves this by reading it, and
merging it is what causes the fork or import to happen.

## Rules

- One pull request per run, covering every new app.
- An app you are unsure about still goes in, as `needs-github-home`, with your
  doubt written down. Leaving it out entirely is how an app goes missing for a
  month with nobody noticing.
- Never fork anything yourself, and never edit any file but the registry.
  Merging the pull request is what authorises a fork.
