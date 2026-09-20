#!/usr/bin/env bash
# Fork every registry candidate that has a GitHub home, and move it into the
# `forked` section so the rest of the machinery picks it up.
#
#   .github/aw/fork-from-registry.sh
#   DRY_RUN=1 .github/aw/fork-from-registry.sh
#
# Only `status: ready-to-fork` entries with a `github:` field are touched, and
# those only get there by a merged pull request from `Scan app sources`. The
# merge is the authorisation; this script never decides anything.
set -uo pipefail

ORG=ruby-gtk-project
ROOT=$(cd "$(dirname "$0")/../.." && pwd)
REG=$ROOT/.github/port-registry.yml
DRY=${DRY_RUN:-}

rc=0
say() { printf '%s\n' "$*"; }

mapfile -t ready < <(python3 - "$REG" <<'PY'
import re, sys
text = open(sys.argv[1]).read()
block = text.split('\ncandidates:', 1)[1] if '\ncandidates:' in text else ''
app = gh = status = None
def flush():
    if app and gh and status == 'ready-to-fork':
        print(f'{app}\t{gh}')
for line in block.splitlines():
    if re.match(r'\s*-\s*app:', line):
        flush()
        app = line.split('app:', 1)[1].strip()
        gh = status = None
    elif re.match(r'\s*github:', line):
        gh = line.split('github:', 1)[1].strip()
    elif re.match(r'\s*status:', line):
        status = line.split('status:', 1)[1].strip()
flush()
PY
)

say "${#ready[@]} candidates ready to fork"
[ "${#ready[@]}" -eq 0 ] && exit 0

for row in "${ready[@]}"; do
  app=${row%%$'\t'*}
  src=${row##*$'\t'}
  name="${src##*/}-rb"
  say "=== $app ($src -> $ORG/$name)"

  if gh api "repos/$ORG/$name" >/dev/null 2>&1; then
    say "  already exists"
    continue
  fi
  if ! gh api "repos/$src" >/dev/null 2>&1; then
    say "  UPSTREAM MISSING: $src" >&2
    rc=1
    continue
  fi
  if [ -n "$DRY" ]; then
    say "  would fork $src as $name"
    continue
  fi
  if ! gh repo fork "$src" --org "$ORG" --fork-name "$name" --clone=false >/dev/null 2>&1; then
    say "  FORK FAILED" >&2
    rc=1
    continue
  fi
  say "  forked"

  branch=$(gh api "repos/$src" -q .default_branch 2>/dev/null || echo main)
  if python3 "$ROOT/.github/aw/registry-promote.py" "$REG" "$app" "$name" "$src" "$branch"; then
    say "  registry: moved to forked"
  else
    say "  REGISTRY UPDATE FAILED" >&2
    rc=1
  fi
done

say "done (exit $rc)"
exit $rc
