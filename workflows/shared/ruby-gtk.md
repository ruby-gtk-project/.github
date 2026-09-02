---
# Ruby GTK4 environment and house rules.
#
# Usage:
#   imports:
#     - shared/ruby-gtk.md

tools:
  bash: true

steps:
  - name: Install GTK4 and Ruby
    run: |
      sudo apt-get update
      sudo apt-get install -y --no-install-recommends \
        ruby ruby-dev build-essential pkg-config \
        libgtk-4-dev libadwaita-1-dev gobject-introspection \
        libgirepository1.0-dev libvte-2.91-gtk4-dev
      gem install --no-document bundler
  - name: Install gems
    run: |
      bundle config set --local path vendor/bundle
      bundle install --jobs 4 || echo "BUNDLE_FAILED" > /tmp/gh-aw/agent/bundle_failed
---

## Ruby GTK4 environment

GTK4, Libadwaita and their introspection typelibs are installed; gems are in
`vendor/bundle`. The repo's `flake.nix` is for humans on NixOS — do not invoke
nix here, the apt toolchain above is what CI uses.

GTK4 renders to an offscreen surface with no display attached, so the app runs
and screenshots correctly **without Xvfb and without setting `GDK_BACKEND`**.
If a run seems to need either, the problem is elsewhere.

## Skills — load them before writing GTK code

Two skills live in `.claude/skills/`:

- **`ruby-gtk`** — the house style: declarative memoized widgets, Adwaita
  binding quirks, worked examples. Read `SKILL.md` and the relevant file under
  `references/` **before writing or reviewing any Ruby GTK code**, including a
  single widget. Ruby's GTK bindings are quirky enough that code written from
  memory is wrong in ways that look right.
- **`ruby-gtk-testing`** — run the app headlessly and drive its UI. Read it
  before claiming any GTK change works. `ruby -c` and a successful `require`
  prove nothing about a UI.

Also read `AGENTS.md` at the repo root.

## House style

`.rubocop.yml` plus the custom cops in `cops/` are enforced: no `return`, no
modifier `if`/`unless`, no conditional assignment, `tap` where a method assigns
then returns the same local, fixed multi-line argument and hash layout with
trailing commas. Run `bundle exec rubocop` and fix every offence before
proposing changes.

## Provenance

These ports are derivative works of GPL-licensed originals. The upstream
implementation is on this repo's other branch. Every ported file starts with a
comment naming the upstream file it derives from, e.g.:

```ruby
# Ported from src/window.c (upstream branch).
```
