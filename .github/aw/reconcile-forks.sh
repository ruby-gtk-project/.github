#!/usr/bin/env bash
# Put every fork on the Initial port board into its desired state:
#
#   1. an orphan `ruby` branch exists
#   2. `ruby` is the default branch
#   3. the scaffold on it matches port-scaffold/ at this checkout
#
# It does not decide anything. Which forks are port targets is a judgement —
# is this an app or a demo repo, is it a second fork of something already
# being ported, what is the app actually called — and that judgement belongs
# to the `initial-port` agentic workflow, which records it by putting a card
# on the board. This script reads those cards and does the mechanical part.
#
#   .github/aw/reconcile-forks.sh
#   ONLY=frogr-rb .github/aw/reconcile-forks.sh
#   DRY_RUN=1 .github/aw/reconcile-forks.sh
#
# One clone on disk at a time; the fleet does not fit otherwise.
set -uo pipefail

ORG=ruby-gtk-project
PROJECT=1
ROOT=$(cd "$(dirname "$0")/../.." && pwd)
SCAFFOLD=$ROOT/port-scaffold
ONLY=${ONLY:-}
DRY=${DRY_RUN:-}

# Overwritten every run. The scaffold owns these outright: they are shared
# tooling, identical in every fork, and an edit to them inside a fork is drift.
AUTH=(.claude/skills cops)

# Written only when absent. A real port grows these — console-rb's flake.nix
# is 229 lines away from the scaffold's and gnome-contacts-rb has its own
# gems — so the scaffold seeds them once and never touches them again.
SEED=(.rubocop.yml flake.nix Gemfile .envrc .gitignore)

rc=0
work=$(mktemp -d)
trap 'rm -rf "$work"' EXIT

say() { printf '%s\n' "$*"; }
run() { [ -n "$DRY" ] && { say "    would: $*"; return 0; }; "$@"; }

gh project item-list "$PROJECT" --owner "$ORG" --format json --limit 500 \
  --jq '.items[] | select(.title | startswith("Initial port: ")) | .title | sub("^Initial port: ";"")' \
  | sort -u > "$work/targets" || { say "cannot read the board" >&2; exit 1; }

count=$(wc -l < "$work/targets")
if [ "$count" -eq 0 ]; then
  say "no cards on the board — that means the read broke, not that there is no work" >&2
  exit 1
fi
say "$count forks on the board"

while read -r repo; do
  [ -z "$ONLY" ] || [ "$ONLY" = "$repo" ] || continue
  say "=== $repo"

  if ! default=$(gh api "repos/$ORG/$repo" --jq .default_branch 2>/dev/null); then
    say "  MISSING: the board names a repo that does not exist" >&2
    rc=1
    continue
  fi

  if ! gh api "repos/$ORG/$repo/branches/ruby" >/dev/null 2>&1; then
    say "  no ruby branch — creating it"
    run "$ROOT/.github/aw/apply-port-scaffold.sh" "$repo" || rc=1
    continue
  fi

  d=$work/r
  rm -rf "$d"
  if ! git clone -q --depth 1 --single-branch -b ruby "https://github.com/$ORG/$repo" "$d"; then
    say "  CLONE FAILED" >&2
    rc=1
    continue
  fi
  for p in "${AUTH[@]}"; do
    mkdir -p "$(dirname "$d/$p")"
    rm -rf "${d:?}/$p"
    cp -a "$SCAFFOLD/$p" "$d/$p"
  done
  for p in "${SEED[@]}"; do
    [ -e "$d/$p" ] || cp -a "$SCAFFOLD/$p" "$d/$p"
  done
  if [ ! -e "$d/AGENTS.md" ]; then
    sed "s/{{APP}}/${repo%-rb}/g" "$SCAFFOLD/AGENTS.md" > "$d/AGENTS.md"
    cp -a "$SCAFFOLD/CLAUDE.md" "$d/CLAUDE.md"
  fi
  if [ -n "$(git -C "$d" status --porcelain)" ]; then
    git -C "$d" add -A
    if run git -C "$d" commit -qm "Reconcile with port-scaffold" && run git -C "$d" push -q origin ruby; then
      say "  scaffold drift corrected"
    else
      say "  PUSH FAILED" >&2
      rc=1
    fi
  else
    say "  scaffold current"
  fi
  rm -rf "$d"

  if [ "$default" != "ruby" ]; then
    if run gh api -X PATCH "repos/$ORG/$repo" -f default_branch=ruby >/dev/null; then
      say "  default branch set to ruby"
    else
      say "  DEFAULT BRANCH FAILED" >&2
      rc=1
    fi
  fi
done < "$work/targets"

say "done (exit $rc)"
exit $rc
