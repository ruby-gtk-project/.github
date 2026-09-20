#!/usr/bin/env bash
# Drive every port fork to its desired state. Idempotent, runs nightly.
#
#   .github/aw/reconcile-forks.sh          # the whole fleet
#   ONLY=frogr-rb .github/aw/reconcile-forks.sh
#   DRY_RUN=1 .github/aw/reconcile-forks.sh
#
# Desired state, per fork:
#   1. an orphan `ruby` branch exists
#   2. `ruby` is the default branch
#   3. the scaffold on it matches port-scaffold/ at this checkout
#   4. it has both of its issues, on the board
#
# A port target is a fork of an upstream app that is not archived. Nothing
# about scaffolding or how much has been ported — progress is the Status field
# on the card, not a condition on whether the card exists.
#
# One clone on disk at a time; the fleet does not fit otherwise.
set -uo pipefail

ORG=ruby-gtk-project
HUB=$ORG/.github
PROJECT=1
ROOT=$(cd "$(dirname "$0")/../.." && pwd)
SCAFFOLD=$ROOT/port-scaffold
TPL=$ROOT/.github/port-issues
ONLY=${ONLY:-}
DRY=${DRY_RUN:-}

# Overwritten every run: the scaffold owns these outright, so an edit in a
# fork is drift and gets reverted. AGENTS.md and CLAUDE.md are written only
# when absent — they carry per-app prose a fork is allowed to grow.
AUTH=(.claude/skills cops .rubocop.yml flake.nix Gemfile .envrc .gitignore)

rc=0
work=$(mktemp -d)
trap 'rm -rf "$work"' EXIT

say() { printf '%s\n' "$*"; }
run() { [ -n "$DRY" ] && { say "    would: $*"; return 0; }; "$@"; }

gh repo list "$ORG" --limit 300 --json name,isArchived,parent \
  --jq '.[] | select(.parent != null and .isArchived == false) | .name' | sort > "$work/targets"
count=$(wc -l < "$work/targets")
if [ "$count" -eq 0 ]; then
  say "no port targets found — that means the query broke, not that the org is empty" >&2
  exit 1
fi
say "$count port targets"

gh project item-list "$PROJECT" --owner "$ORG" --format json --limit 500 \
  --jq '.items[].title' > "$work/board" 2>/dev/null || : > "$work/board"

ensure_issue() { # <repo> <title> <template> <label> <upstream>
  local repo=$1 title=$2 tpl=$3 label=$4 upstream=$5 url
  grep -qxF "$title" "$work/board" && return 0
  url=$(gh issue list -R "$HUB" --state all --limit 500 --json title,url \
        --jq ".[] | select(.title == \"$title\") | .url" | head -1)
  if [ -z "$url" ]; then
    sed -e "s/{{REPO}}/$repo/g" -e "s/{{UPSTREAM}}/$upstream/g" "$TPL/$tpl" > "$work/body.md"
    [ -n "$DRY" ] && { say "    would create issue: $title"; return 0; }
    url=$(gh issue create -R "$HUB" --title "$title" --label "$label" --body-file "$work/body.md") || {
      say "    ISSUE FAILED: $title" >&2; rc=1; return 1; }
    say "    issue created: $title"
  fi
  run gh project item-add "$PROJECT" --owner "$ORG" --url "$url" >/dev/null &&
    say "    on the board: $title"
}

while read -r repo; do
  [ -z "$ONLY" ] || [ "$ONLY" = "$repo" ] || continue
  say "=== $repo"
  meta=$(gh api "repos/$ORG/$repo" --jq '[.default_branch, (.parent.default_branch // "main")] | @tsv') || { rc=1; continue; }
  default=$(printf '%s' "$meta" | cut -f1)
  upstream=$(printf '%s' "$meta" | cut -f2)

  if ! gh api "repos/$ORG/$repo/branches/ruby" >/dev/null 2>&1; then
    say "  no ruby branch — scaffolding from scratch"
    run "$ROOT/.github/aw/apply-port-scaffold.sh" "$repo" || { rc=1; continue; }
  else
    d=$work/r
    rm -rf "$d"
    git clone -q --depth 1 --single-branch -b ruby "https://github.com/$ORG/$repo" "$d" || { rc=1; continue; }
    for p in "${AUTH[@]}"; do
      mkdir -p "$(dirname "$d/$p")"
      rm -rf "${d:?}/$p"
      cp -a "$SCAFFOLD/$p" "$d/$p"
    done
    if [ ! -e "$d/AGENTS.md" ]; then
      sed "s/{{APP}}/${repo%-rb}/g" "$SCAFFOLD/AGENTS.md" > "$d/AGENTS.md"
      cp -a "$SCAFFOLD/CLAUDE.md" "$d/CLAUDE.md"
    fi
    if [ -n "$(git -C "$d" status --porcelain)" ]; then
      git -C "$d" add -A
      run git -C "$d" commit -qm "Reconcile with port-scaffold" &&
        run git -C "$d" push -q origin ruby &&
        say "  scaffold drift corrected" || { say "  PUSH FAILED" >&2; rc=1; }
    else
      say "  scaffold current"
    fi
    rm -rf "$d"
  fi

  if [ "$default" != "ruby" ]; then
    run gh api -X PATCH "repos/$ORG/$repo" -f default_branch=ruby >/dev/null &&
      say "  default branch set to ruby" || { say "  DEFAULT BRANCH FAILED" >&2; rc=1; }
  fi

  ensure_issue "$repo" "Initial port: $repo" initial-port.md port "$upstream"
  ensure_issue "$repo" "Gem release: $repo" gem-release.md gem-release "$upstream"
done < "$work/targets"

say "done (exit $rc)"
exit $rc
