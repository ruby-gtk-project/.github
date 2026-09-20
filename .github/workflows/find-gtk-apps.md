---
description: |
  Hunts GitHub for a GTK app worth porting that the campaign does not already
  have, and opens a pull request adding it to the port registry.

on:
  schedule: daily
  workflow_dispatch:
    inputs:
      how_many:
        description: "How many apps to propose this run"
        required: false
        default: "1"
        type: string

engine:
  id: copilot
  model: gpt-5

timeout-minutes: 30

permissions: read-all

network:
  allowed: [defaults, github]

tools:
  bash: ["cat *", "jq *", "ls *", "head *", "wc *", "grep *", "python3 *", "git diff*", "git status*"]
  github:
    toolsets: [repos, issues, pull_requests, search]

steps:
  - name: What the campaign already has
    env:
      GH_TOKEN: ${{ github.token }}
    run: |
      set -euo pipefail
      mkdir -p /tmp/gh-aw/agent
      ORG=ruby-gtk-project

      # Deliberately NOT copied to /tmp: an agent handed a copy there edits
      # the copy, and the pull request comes out empty.

      # Every upstream already claimed, one per line, lowercased — the cheap
      # check before spending a search on something we have.
      gh repo list "$ORG" --limit 300 --json name,parent \
        --jq '.[] | select(.parent != null) | "\(.parent.owner.login)/\(.parent.name)" | ascii_downcase' \
        | sort -u > /tmp/gh-aw/agent/claimed-upstreams.txt

      gh issue list -R "$ORG/.github" --state all --limit 500 --json title \
        --jq '.[].title' > /tmp/gh-aw/agent/issue-titles.txt

      gh pr list -R "$ORG/.github" --state all --limit 200 --json title,body \
        --jq '.[] | "\(.title)\n\(.body)"' > /tmp/gh-aw/agent/pr-text.txt

      wc -l /tmp/gh-aw/agent/claimed-upstreams.txt /tmp/gh-aw/agent/issue-titles.txt

safe-outputs:
  create-issue:
    max: 1
    labels: [registry-proposal]
---

# Find GTK apps

Every GTK app that is worth a Ruby port should end up in
`.github/port-registry.yml`. `Scan app sources` covers the ones listed on
apps.gnome.org. Your job is the rest of GitHub: find **${{ inputs.how_many || 1 }}**
app the campaign does not have, judge whether it is worth porting, and propose
it.

## What you have

- `.github/port-registry.yml` — the registry, in the working directory. This
  is the real file and the only copy: read and write it **at that path**.
  `forked` is what we have, `candidates` is what is queued.
- `/tmp/gh-aw/agent/claimed-upstreams.txt` — every upstream already forked,
  as `owner/repo`, lowercased.
- `/tmp/gh-aw/agent/issue-titles.txt` and `pr-text.txt` — every issue and pull
  request in this repo, so you can see what has already been proposed or
  rejected.

## Step 1 — Go looking

There is no single index of GTK apps, so do not lean on one search. Some
routes, roughly in order of how much signal they carry:

- **Topic search.** `gtk4`, `libadwaita`, `gtk`, `gnome`, `gtk-rs`,
  `pygobject`. Topics are self-declared, so they are high precision and poor
  recall — plenty of GTK apps never set one.
- **Code search for the things a GTK app cannot avoid.** A `meson.build`
  naming `libadwaita-1` or `gtk4`; a `.desktop` file; a `*.gresource.xml`; a
  `.blp` blueprint file; `Adw.ApplicationWindow` in Python or `adw::` in Rust.
  This finds apps that never set a topic.
- **Awesome lists.** Search for repositories and READMEs along the lines of
  "awesome gtk", "awesome gnome", "awesome libadwaita". These are curated by
  people who care, so the hit rate is good — but they go stale, so check each
  entry is still alive rather than trusting the list.
- **Flathub.** Apps published there are real, installable and maintained
  enough to ship. Many list their source repo, and many of those are GitHub.
- **Sideways from what we have.** The upstreams already in the registry have
  authors, and authors who write one GTK app often write several. Look at
  what they publish, and at who stars and forks those repos.

Use more than one route. If the first thing you find is already claimed, go
find another — that is the normal case, not a failure.

## Step 2 — Is it already ours

Before spending any judgement on an app, check all four:

1. its `owner/repo`, lowercased, in `claimed-upstreams.txt`
2. its name in `issue-titles.txt` (`Initial port: <name>-rb`)
3. its name or URL in `pr-text.txt` — it may be proposed and not yet merged
4. its name or URL anywhere in `.github/port-registry.yml`, in either section

Any hit means move on and find another app. Names collide, so compare the
repository URL, not just the name: a different project called Commit is a
different project.

## Step 3 — Is it worth porting

Judge it against these. Nothing here is a hard gate on its own except the
licence, but an app that fails several is not a good use of a port.

**Fit**
- Built on **GTK4**. A GTK3 app is a rewrite, not a port — the house skills
  target GTK4 and Libadwaita.
- Uses **Libadwaita**. Strong signal it is a modern GNOME app that will look
  right ported.
- It is an **application with a window**, not a library, a daemon, a CLI, a
  shell extension or a theme. Something a person launches and clicks.

**Size**
- Roughly 2,000 to 20,000 lines of application source. Below that there is
  not much to port; far above it and the port never finishes. Count source,
  not vendored dependencies, translations or generated files.
- Count its windows, dialogs and pages. Ten or fewer is a port someone can
  actually complete.

**Health**
- Commits in the last year, and more than one contributor if possible. A dead
  upstream means no one to compare against when the port is ambiguous.
- Has releases or is packaged somewhere — evidence it works, not just builds.
- Open issue count that suggests use rather than abandonment.

**Portability**
- Written in Vala, C, Python, GJS or Rust. All five are readable as a spec.
- Check what it links against beyond GTK and Libadwaita. GStreamer, WebKit,
  libsecret, Poppler and friends need ruby-gnome bindings that may not exist
  — see the `Bindings` project and the `binding-gaps` workflow. An app whose
  core feature needs a binding we do not have is blocked, not portable, and
  should be proposed only with that stated plainly.
- A test suite upstream is a bonus: `test-parity` needs something to count.

**Licence — the one hard gate**
- It must carry a licence that permits a derivative work, and the port
  inherits it. GPL, LGPL, MIT, Apache are all fine. **No licence file at all
  means no port** — propose it only if you can point at an explicit licence.

## Step 4 — Propose it

You cannot edit files in this workflow — writes from the agent container never
reach the checkout, so a pull request built from them comes out empty. Report
instead; a script applies it.

Open one issue whose body contains a fenced `yaml` block. That block is what
gets applied:

```yaml
- app: Save Desktop
  status: ready-to-fork
  github: vikdevelop/SaveDesktop
```

Outside the block, for each app:

- what it is, in a sentence
- the licence, and where you saw it
- how it scored against Step 3 — the numbers you actually found, not
  adjectives. "Vala, 6,400 lines, 7 dialogs, last commit 3 weeks ago, GPL-3.0,
  needs libsecret" is a proposal. "Well maintained and a good fit" is not.
- anything that worries you, stated plainly
- which searches you ran, so the next run can go somewhere else

Merging the pull request the script opens is what authorises the fork. You
never fork anything yourself.

## Rules

- Propose only apps you have actually checked against all four dedupe sources.
- If you cannot find anything new that clears Step 3, open no pull request and
  say what you searched and what you rejected. An honest empty run is fine.
  Padding the registry with an app you would not want to port is not.
- Never edit the `forked` section.
