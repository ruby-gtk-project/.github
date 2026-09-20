#!/usr/bin/env bash
# Set up a fork for porting: create the orphan `ruby` branch, put the shared
# scaffold on it, and make it the repo's default branch.
#
#   .github/aw/apply-port-scaffold.sh <repo> [app-name]   e.g. ... frogr-rb Frogr
#
# The scaffold is port-scaffold/ at the root of this repo — all six skills, the
# GTK4 dev shell, the house rubocop config and cops, AGENTS.md (CLAUDE.md
# symlinks to it) and Gemfile. It is copied in verbatim; `{{APP}}` in AGENTS.md
# becomes the app name (default: repo name minus `-rb`).
#
# `ruby` is an orphan branch — no upstream history, starts empty, upstream is
# never fetched. Refuses if `ruby` already exists: recreating it would throw
# away whatever port work is sitting on it.
#
# The initial-port workflow only counts a fork as a port target once its `ruby`
# branch has scaffolding, so an unscaffolded fork never reaches the board.
# Scaffold first; the daily run picks it up from there.
set -uo pipefail

ORG=ruby-gtk-project
SCAFFOLD=$(cd "$(dirname "$0")/../../port-scaffold" && pwd)
repo=${1:?usage: apply-port-scaffold.sh <repo> [app-name]}
app=${2:-${repo%-rb}}

gh api "repos/$ORG/$repo" >/dev/null || exit 1
if gh api "repos/$ORG/$repo/branches/ruby" >/dev/null 2>&1; then
  echo "$repo: ruby branch already exists — nothing done" >&2
  exit 1
fi

work=$(mktemp -d)
trap 'rm -rf "$work"' EXIT

cp -a "$SCAFFOLD" "$work/r"
sed -i "s/{{APP}}/$app/g" "$work/r/AGENTS.md"

cd "$work/r" || exit 1
git init -q -b ruby
git remote add origin "https://github.com/$ORG/$repo"
git add -A
git commit -qm "Scaffold the ruby port branch" || exit 1
git push -q origin ruby || exit 1
gh api -X PATCH "repos/$ORG/$repo" -f default_branch=ruby >/dev/null || exit 1
echo "$repo: orphan ruby branch created, scaffolded, set as default"
