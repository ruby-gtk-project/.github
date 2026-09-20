#!/usr/bin/env bash
# Set up a fork for porting: create the orphan `ruby` branch, put the shared
# scaffold on it, and make it the repo's default branch.
#
#   ./apply.sh <repo> [app-name]     e.g. ./apply.sh frogr-rb Frogr
#
# Refuses if `ruby` already exists — recreating it would throw away whatever
# port work is on it. Upstream history is never fetched; the branch is an
# orphan and starts empty.
set -uo pipefail

ORG=ruby-gtk-project
HERE=$(cd "$(dirname "$0")" && pwd)
repo=${1:?usage: apply.sh <repo> [app-name]}
app=${2:-${repo%-rb}}

gh api "repos/$ORG/$repo" >/dev/null || exit 1
if gh api "repos/$ORG/$repo/branches/ruby" >/dev/null 2>&1; then
  echo "$repo: ruby branch already exists — nothing done" >&2
  exit 1
fi

work=$(mktemp -d)
trap 'rm -rf "$work"' EXIT

cp -a "$HERE" "$work/r"
rm -f "$work/r/apply.sh" "$work/r/README.md"
sed -i "s/{{APP}}/$app/g" "$work/r/AGENTS.md"

cd "$work/r" || exit 1
git init -q -b ruby
git remote add origin "https://github.com/$ORG/$repo"
git add -A
git commit -qm "Scaffold the ruby port branch" || exit 1
git push -q origin ruby || exit 1
gh api -X PATCH "repos/$ORG/$repo" -f default_branch=ruby >/dev/null || exit 1
echo "$repo: orphan ruby branch created, scaffolded, set as default"
