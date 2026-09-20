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
  # Without these, every non-GitHub URL is redacted out of the agent's output
  # as `(gitlab.gnome.org/redacted)` — which is precisely the upstream URL the
  # import route needs.
  allowed: [defaults, github, "gitlab.gnome.org", "gitlab.com", "codeberg.org", "flathub.org", "apps.gnome.org"]

tools:
  edit:
  # Scheduled workflow with no untrusted input (no issue/PR bodies, no
  # comments) — per the gh-aw bash allowlist decision rule, "*" is acceptable.
  # A hand-rolled narrow list here compiles to bare-command entries that deny
  # ordinary commands like `grep -o`, which is how the GNOME-apps run died.
  bash: ["*"]
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

      # GitHub's GraphQL flakes often enough that one transient 500 must not
      # kill the run — retry each read a few times before failing for real.
      fetch() { # fetch <output-file> <command...>
        local out=$1; shift
        local n
        for n in 1 2 3 4; do
          if "$@" > "$out.tmp" 2>/dev/null; then mv "$out.tmp" "$out"; return 0; fi
          sleep $((n * 5))
        done
        echo "::error::read failed after 4 attempts: $*" >&2
        return 1
      }

      # Deliberately NOT copied to /tmp: an agent handed a copy there edits
      # the copy, and the pull request comes out empty.

      # Every upstream already claimed, one per line, lowercased — the cheap
      # check before spending a search on something we have.
      fetch /tmp/gh-aw/agent/claimed-raw.txt gh repo list "$ORG" --limit 300 --json name,parent \
        --jq '.[] | select(.parent != null) | "\(.parent.owner.login)/\(.parent.name)" | ascii_downcase'
      sort -u /tmp/gh-aw/agent/claimed-raw.txt > /tmp/gh-aw/agent/claimed-upstreams.txt

      fetch /tmp/gh-aw/agent/issue-titles.txt gh issue list -R "$ORG/.github" --state all --limit 500 --json title \
        --jq '.[].title'

      fetch /tmp/gh-aw/agent/pr-text.txt gh pr list -R "$ORG/.github" --state all --limit 200 --json title,body \
        --jq '.[] | "\(.title)\n\(.body)"'

      wc -l /tmp/gh-aw/agent/claimed-upstreams.txt /tmp/gh-aw/agent/issue-titles.txt

safe-outputs:
  create-pull-request:
    title-prefix: "[registry] "
    labels: [registry, discovery]
    max: 1
    draft: false
    allowed-files: ["registry.yml"]
    if-no-changes: "ignore"
---

# Find new GTK apps

Every GTK app that is worth a Ruby port should end up in
`registry.yml`. `find-new-gtk-apps-gnome` covers the ones listed on
apps.gnome.org. Your job is the rest of GitHub: find **${{ inputs.how_many || 1 }}**
app the campaign does not have, judge whether it is worth porting, and propose
it.

## What you have

- `registry.yml` — the registry, at the root of the working directory. Three
  keys per entry and nothing else:

  ```yaml
  - app: Apostrophe
    repo: https://github.com/ApostropheEditor/Apostrophe
    fork: https://github.com/ruby-gtk-project/Apostrophe-rb
  ```
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

Use more than one route. Candidates come from searches you ran and pages you
opened **in this run** — never from memory, and never from a URL you can
guess. If the first thing you find is already claimed, go find another — that
is the normal case, not a failure.

## Step 2 — Is it already ours

Before spending any judgement on an app, check all four:

1. its `owner/repo`, lowercased, in `claimed-upstreams.txt`
2. its name in `issue-titles.txt` (`Initial port: <name>-rb`)
3. its name or URL in `pr-text.txt` — it may be proposed and not yet merged
4. its name or URL anywhere in `registry.yml`

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
  — see the `Bindings` project and the `report-binding-gaps` workflow. An app whose
  core feature needs a binding we do not have is blocked, not portable, and
  should be proposed only with that stated plainly.
- A test suite upstream is a bonus: `test-parity` needs something to count.

**Licence — the one hard gate**
- It must carry a licence that permits a derivative work, and the port
  inherits it. GPL, LGPL, MIT, Apache are all fine. **No licence file at all
  means no port** — propose it only if you can point at an explicit licence.

## Step 4 — Verify it exists, and verify your evidence

A proposal is only as good as its links. Before anything goes in a pull
request:

1. **The repository must resolve.** Open the candidate's GitHub page or run
   `gh repo view <owner>/<repo>`. A 404, a redirect to a differently named
   project, or an owner that did not appear in your search results is the end
   of that candidate — go back to Step 1. Never propose a repository you have
   not opened this run. A previous run proposed `OdyseeTeam/MissionCenter` — a
   plausible-looking URL that has never existed — with a paragraph of
   fabricated evidence linking to files that 404.
2. **Every claim in the PR body must come from something you read this run.**
   The licence from its `LICENSE` file, the size from a count you ran, the
   last-commit date from the actual history, the toolkit from its actual
   build files. If you cannot point at the fetched page or API response a fact
   came from, the fact does not exist. Never cite a URL you did not fetch.

## Step 5 — Propose it

Add an entry to `registry.yml` at the root of the working directory, with the
three keys:

- `app` — what the app is called
- `repo` — where its source lives, the URL you found it at
- `fork` — `https://github.com/ruby-gtk-project/<name>-rb`, the fork that will
  be created. It does not exist yet; `check-and-fork-registry-apps` reads this file and
  creates whatever is missing.

Nothing else goes in the file — no status, no notes, no sections.

Then open one pull request. In the body, for each app:

- what it is, in a sentence
- the licence, and where you saw it
- how it scored against Step 3 — the numbers you actually found, not
  adjectives. "Vala, 6,400 lines, 7 dialogs, last commit 3 weeks ago, GPL-3.0,
  needs libsecret" is a proposal. "Well maintained and a good fit" is not.
- anything that worries you, stated plainly
- which searches you ran, so the next run can go somewhere else

Merging the pull request is what authorises the fork. You never fork anything
yourself.

## Rules

- Propose only repositories you opened and verified this run — never one you
  remember, and never one whose URL you constructed without fetching it.
- Propose only apps you have actually checked against all four dedupe sources.
- If you cannot find anything new that clears Step 3, open no pull request and
  say what you searched and what you rejected. An honest empty run is fine.
  Padding the registry with an app you would not want to port is not.
- Never remove or edit an existing entry. You only add.
