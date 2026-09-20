#!/usr/bin/env bash
# Binding scan: work out which Ruby gems the port campaign needs and does not
# have.
#
# Each fork carries the upstream app on its original branch, so the upstream
# build files say exactly which libraries the port will have to reach. This
# reads them across the whole fleet, reduces every hit to a GObject
# Introspection namespace, subtracts what ruby-gnome already ships, and writes
# the remainder to gaps.json.
#
# Nothing here is a judgement call. Names the map in namespace-map.json does
# not know are reported as unclassified rather than guessed at, and the agent
# that reads gaps.json is told to count nothing for itself.
#
# Usage: binding-scan.sh <org> <map.json> <out-dir> [previous-gaps.json]
set -uo pipefail

ORG=$1
MAP=$2
OUT=$3
PREV=${4:-}
mkdir -p "$OUT"
: "${GH_TOKEN:?GH_TOKEN must be set}"

# --- 1. the fleet -----------------------------------------------------------
# A port target is a fork whose default branch is `ruby`. Everything else in
# the org is tooling, demos or infrastructure.
gh api graphql --paginate --slurp -F org="$ORG" -f query='
  query($org: String!, $endCursor: String) {
    organization(login: $org) {
      repositories(first: 25, after: $endCursor, isArchived: false) {
        pageInfo { hasNextPage endCursor }
        nodes {
          name
          defaultBranchRef { name }
          parent { nameWithOwner defaultBranchRef { name } }
        }
      }
    }
  }' > "$OUT/org-repos.json"

jq -r '[.[].data.organization.repositories.nodes[]]
       | map(select(.parent != null and .defaultBranchRef.name == "ruby"))
       | .[] | "\(.name)\t\(.parent.defaultBranchRef.name)"' \
  "$OUT/org-repos.json" > "$OUT/targets.tsv"

echo "fleet: $(jq '[.[].data.organization.repositories.nodes[]] | length' "$OUT/org-repos.json") repos, $(wc -l < "$OUT/targets.tsv") port targets"

# --- 2. upstream trees ------------------------------------------------------
# One recursive tree per fork, read off the branch the upstream app lives on.
# ~60s for the whole fleet at this concurrency.
mkdir -p "$OUT/trees"
: > "$OUT/tree-failures.txt"
while IFS=$'\t' read -r name branch; do
  (
    gh api "repos/$ORG/$name/git/trees/$branch?recursive=1" --jq '.tree[].path' \
      > "$OUT/trees/$name.txt" 2>/dev/null \
      || echo "$name	$branch" >> "$OUT/tree-failures.txt"
  ) &
  while [ "$(jobs -r | wc -l)" -ge 12 ]; do wait -n; done
done < "$OUT/targets.tsv"
wait
echo "trees: $(ls "$OUT/trees" | wc -l) fetched, $(wc -l < "$OUT/tree-failures.txt") failed"

# --- 3. the files that name libraries ---------------------------------------
# meson.build and Cargo.toml declare dependencies outright. Python and
# JavaScript upstreams declare nothing in the build file and instead name the
# namespace at the import site, so their sources have to be read too.
# Vendored and generated trees are excluded - they are not the app.
: > "$OUT/fetchlist.tsv"
while IFS=$'\t' read -r name branch; do
  [ -f "$OUT/trees/$name.txt" ] || continue
  grep -E '(^|/)meson\.build$|(^|/)Cargo\.toml$|\.(py|js|ts)$' "$OUT/trees/$name.txt" 2>/dev/null \
    | grep -vE '(^|/)(node_modules|subprojects|build|_build|\.flatpak-builder|vendor|dist|po|tests?|__pycache__)/' \
    | awk -v n="$name" -v b="$branch" '{print n"\t"b"\t"$0}'
done < "$OUT/targets.tsv" >> "$OUT/fetchlist.tsv"
echo "files to read: $(wc -l < "$OUT/fetchlist.tsv")"

mkdir -p "$OUT/blobs"
while IFS=$'\t' read -r name branch path; do
  dest="$OUT/blobs/${name}__$(printf '%s' "$path" | tr '/' '_')"
  [ -f "$dest" ] && continue
  (
    curl -sfL -H "Authorization: Bearer $GH_TOKEN" \
      "https://raw.githubusercontent.com/$ORG/$name/$branch/$path" -o "$dest" 2>/dev/null
  ) &
  while [ "$(jobs -r | wc -l)" -ge 25 ]; do wait -n; done
done < "$OUT/fetchlist.tsv"
wait
echo "blobs: $(ls "$OUT/blobs" | wc -l) fetched"

# --- 4. what ruby-gnome already covers --------------------------------------
# Read from ruby-gnome itself rather than a list kept here, so a gem released
# upstream closes its gap on the next run with no edit on our side. Each
# subproject's entry point calls loader.load("Namespace") - that call is the
# authoritative link between a gem and the namespace it binds.
mkdir -p "$OUT/rg"
gh api "repos/ruby-gnome/ruby-gnome/git/trees/main?recursive=1" \
  --jq '.tree[] | select(.type=="blob") | .path' > "$OUT/rg-tree.txt" 2>/dev/null || : > "$OUT/rg-tree.txt"

# The entry point names the namespace, but several gems bind more than one
# (gstreamer ships audio-loader.rb and base-loader.rb beside loader.rb), so
# every *loader*.rb counts too.
grep -E '^[a-z0-9_.-]+/lib/[^/]+\.rb$|^[a-z0-9_.-]+/lib/.*loader\.rb$' "$OUT/rg-tree.txt" \
  > "$OUT/rg-files.txt" || :
while read -r path; do
  dest="$OUT/rg/$(printf '%s' "$path" | tr '/' '_')"
  [ -f "$dest" ] && continue
  (
    curl -sfL -H "Authorization: Bearer $GH_TOKEN" \
      "https://raw.githubusercontent.com/ruby-gnome/ruby-gnome/main/$path" -o "$dest" 2>/dev/null
  ) &
  while [ "$(jobs -r | wc -l)" -ge 20 ]; do wait -n; done
done < "$OUT/rg-files.txt"
wait
echo "ruby-gnome: $(ls "$OUT/rg" | wc -l) entry points read"

# --- 5. classify ------------------------------------------------------------
MAP="$MAP" OUT="$OUT" PREV="$PREV" python3 "$(dirname "$0")/binding-classify.py"
