#!/usr/bin/env bash
# Bring an app that is not on GitHub into the org, so it can be ported like
# any fork.
#
#   .github/aw/import-from-registry.sh
#   ONLY=Amberol DRY_RUN=1 .github/aw/import-from-registry.sh
#
# Roughly half the apps on apps.gnome.org live on gitlab.gnome.org, gitlab.com
# or codeberg.org and have no GitHub home at all. `gh repo fork` cannot fork
# what is not on GitHub, so those are mirrored instead: clone the upstream,
# push its history into a new org repo under its own branch name, and from
# that point on it behaves exactly like a fork — same scaffold, same issues,
# same reconciler. The port issue tells you the original is on the upstream
# branch, and after an import that is still true.
#
# Only `status: ready-to-import` entries are touched, and they only get that
# status through a merged pull request from `Scan app sources`.
#
# One mirror on disk at a time. Some of these are large repositories.
set -uo pipefail

ORG=ruby-gtk-project
ROOT=$(cd "$(dirname "$0")/../.." && pwd)
REG=$ROOT/.github/port-registry.yml
ONLY=${ONLY:-}
DRY=${DRY_RUN:-}

rc=0
say() { printf '%s\n' "$*"; }

mapfile -t ready < <(python3 - "$REG" <<'PY'
import re, sys
text = open(sys.argv[1]).read()
block = text.split('\ncandidates:', 1)[1] if '\ncandidates:' in text else ''
app = vcs = status = None
def flush():
    if app and vcs and vcs != '~' and status == 'ready-to-import':
        print(f'{app}\t{vcs}')
for line in block.splitlines():
    if re.match(r'\s*-\s*app:', line):
        flush()
        app = line.split('app:', 1)[1].strip()
        vcs = status = None
    elif re.match(r'\s*vcs:', line):
        vcs = line.split('vcs:', 1)[1].strip()
    elif re.match(r'\s*status:', line):
        status = line.split('status:', 1)[1].strip()
flush()
PY
)

say "${#ready[@]} candidates ready to import"
[ "${#ready[@]}" -eq 0 ] && exit 0

work=$(mktemp -d)
trap 'rm -rf "$work"' EXIT

for row in "${ready[@]}"; do
  app=${row%%$'\t'*}
  url=${row##*$'\t'}
  [ -z "$ONLY" ] || [ "$ONLY" = "$app" ] || continue
  url=${url%/}
  name="$(basename "$url" .git)-rb"
  say "=== $app ($url -> $ORG/$name)"

  if gh api "repos/$ORG/$name" >/dev/null 2>&1; then
    say "  already exists"
    continue
  fi

  # Whatever upstream calls its default branch is the branch the port issue
  # will point people at, so it has to survive the import unchanged.
  branch=$(git ls-remote --symref "$url" HEAD 2>/dev/null | sed -n 's#^ref: refs/heads/\([^\t]*\).*#\1#p' | head -1)
  if [ -z "$branch" ]; then
    say "  UNREACHABLE: cannot read $url" >&2
    rc=1
    continue
  fi
  say "  upstream default branch: $branch"

  if [ -n "$DRY" ]; then
    say "  would mirror $url into $ORG/$name on branch $branch"
    continue
  fi

  d=$work/m
  rm -rf "$d"
  if ! git clone -q --mirror "$url" "$d"; then
    say "  CLONE FAILED" >&2
    rc=1
    continue
  fi

  if ! gh repo create "$ORG/$name" --public \
        --description "Ruby GTK4 port of $app. Upstream: $url" >/dev/null 2>&1; then
    say "  REPO CREATE FAILED" >&2
    rc=1
    rm -rf "$d"
    continue
  fi

  # Only branches and tags: a mirror push would otherwise carry merge
  # requests refs and other upstream-forge refs GitHub will reject.
  if git -C "$d" push -q "https://github.com/$ORG/$name" "refs/heads/*:refs/heads/*" "refs/tags/*:refs/tags/*" 2>/dev/null; then
    say "  history pushed"
  else
    say "  PUSH FAILED" >&2
    rc=1
    rm -rf "$d"
    continue
  fi
  rm -rf "$d"

  if python3 "$ROOT/.github/aw/registry-promote.py" "$REG" "$app" "$name" "$url" "$branch"; then
    say "  registry: moved to forked"
  else
    say "  REGISTRY UPDATE FAILED" >&2
    rc=1
  fi
done

say "done (exit $rc)"
exit $rc
