#!/usr/bin/env bash
# Converge one port fork onto the kettle-jem gem template, so that `gem build`
# succeeds with upstream's licence and the GTK assets inside the gem. This is
# the packaging half of the `Gem release: <fork>` issues.
#
#   .github/aw/converge-port-gem.sh <clone-dir> <fork-name> <license>
#
# Run by converge-port-gems.yml against a fresh clone of the fork's `ruby`
# branch. Writes to the clone only — the workflow owns the commit and push.
#
# Every fork is a packaged, runnable app from day one. A fork whose port has
# not been written yet gets the app skeleton — a blank Adwaita window saying so
# — so that `gem build` succeeds and `gem install` gives a working command.
# kettle-jem then enforces the packaging from there.
#
# Exit codes: 0 packaged, 1 something went wrong that needs fixing.
#
# kettle-jem needs Ruby >= 4.0 and a bundle pinning prism 1.9.0: it declares
# `prism >= 1.6.0` but calls Prism::Node#breadth_first_search_all, which only
# exists in prism >= 1.9.0. Ruby 4.0.x bundles 1.8.1, so without the pin every
# run dies with NoMethodError. BUNDLE_GEMFILE must already point at that bundle.
set -uo pipefail

CLONE=${1:?usage: converge-port-gem.sh <clone-dir> <fork-name> <license>}
FORK=${2:?}
LICENSE=${3:?}
AW=$(cd "$(dirname "$0")" && pwd)
SCAFFOLD=$(cd "$AW/../../port-scaffold" && pwd)

# A compound expression goes in verbatim: it is valid SPDX, it is what upstream
# declares, and `spec.licenses = ["A AND B"]` builds. Never assert one half.
case "$LICENSE" in
  ""|UNKNOWN) echo "::error::$FORK has no licence in registry.yml" >&2; exit 1 ;;
esac

gem_name=$(echo "$FORK" | tr '[:upper:]' '[:lower:]')   # Commit-rb -> commit-rb
app=${FORK%-rb}

# kettle-jem rewrites its own config, the README and the CHANGELOG on every run
# through recipes that ignore `files: keep_destination`. Re-assert them from git
# afterwards so the next run does not inherit drifted inputs.
PROTECTED=(
  .structuredmerge/kettle-jem.yml
  .structuredmerge/kettle-jem.lock
  README.md
  CHANGELOG.md
  .github/FUNDING.yml
)

# 1. Seed the config, always from this repo's copy, with the licence pinned.
#    If `licenses:` is left for kettle-jem to derive, config_sync injects
#    `licenses: [MIT]` and the NEXT run rewrites the gemspec to MIT and drops
#    MIT.md into a GPL app.
mkdir -p "$CLONE/.structuredmerge"
sed "s|{{LICENSE}}|$LICENSE|g" "$AW/kettle-jem.yml" > "$CLONE/.structuredmerge/kettle-jem.yml"

# 2. Make the fork an application if it is not one yet. The slug is the
#    require path and file name, the module is its CamelCase, and the launcher
#    keeps the dashes: Chess-Clock-rb -> lib/chess_clock.rb, ChessClock,
#    bin/chess-clock.
launcher=$(echo "$app" | tr '[:upper:]' '[:lower:]')
slug=$(echo "$launcher" | tr '-' '_')
module=$(echo "$slug" | awk -F_ '{ for (i=1; i<=NF; i++) printf "%s%s", toupper(substr($i,1,1)), substr($i,2); print "" }')
app_id="org.rubygtkproject.$module"

if [ ! -f "$CLONE/lib/$slug.rb" ]; then
  mkdir -p "$CLONE/lib/$slug"
  sed -e "s|{{SLUG}}|$slug|g" "$AW/app-skeleton/entrypoint.rb" > "$CLONE/lib/$slug.rb"
  sed -e "s|{{MODULE}}|$module|g" -e "s|{{APP}}|$app|g" -e "s|{{APP_ID}}|$app_id|g" \
    "$AW/app-skeleton/application.rb" > "$CLONE/lib/$slug/application.rb"
fi

# The launcher lives in exe/ because the template owns `bindir = exe`.
if [ ! -f "$CLONE/exe/$launcher" ] && [ ! -f "$CLONE/bin/$launcher" ]; then
  mkdir -p "$CLONE/exe"
  sed -e "s|{{SLUG}}|$slug|g" -e "s|{{MODULE}}|$module|g" \
    "$AW/app-skeleton/launcher" > "$CLONE/exe/$launcher"
  chmod +x "$CLONE/exe/$launcher"
fi

# The skeleton needs the adwaita gem. kettle-jem merges the Gemfile against its
# own packaged template, which knows nothing about GTK, so add it here.
for g in gtk4 adwaita; do
  grep -q "^gem \"$g\"" "$CLONE/Gemfile" 2>/dev/null || echo "gem \"$g\"" >> "$CLONE/Gemfile"
done

# 3. A flake with no lock is not reproducible: `nixos-unstable` floats and the
#    dev shell someone gets is not the one we pinned. The scaffold ships both,
#    so seed the lock when a fork has flake.nix without one. A fork that grew
#    its own flake keeps it — its lock is its own and must match its own
#    inputs, which step 9 verifies.
if [ -f "$CLONE/flake.nix" ] && [ ! -f "$CLONE/flake.lock" ]; then
  if cmp -s "$CLONE/flake.nix" "$SCAFFOLD/flake.nix"; then
    cp "$SCAFFOLD/flake.lock" "$CLONE/flake.lock"
  else
    echo "::error::$FORK has its own flake.nix and no flake.lock — run \`nix flake lock\` in it" >&2
    exit 1
  fi
fi

# 4. Seed a gemspec when the fork has none: kettle-jem hard-fails with
#    "no gemspec found" (exit 2). spec.files is deliberately absent — kettle-jem
#    then inserts its own canonical assignment (which honours
#    gemspec.package_files.include). Any other shape raises
#    "Unsupported gemspec spec.files assignment".
if ! compgen -G "$CLONE/*.gemspec" > /dev/null; then
  # Every launcher in exe/ and bin/, minus the dev scripts kettle-jem writes.
  mapfile -t execs < <(cd "$CLONE" && find exe bin -maxdepth 1 -type f -printf '%f\n' 2>/dev/null \
    | grep -vx 'setup\|console' | sort -u)
  exec_list=$(printf '"%s", ' "${execs[@]}"); exec_list="[${exec_list%, }]"
  cat > "$CLONE/${gem_name}.gemspec" <<GS
# frozen_string_literal: true

# Seeded by converge-port-gem.sh. kettle-jem owns spec.files, metadata and
# rdoc options from here on; the fields below are preserved across runs.
Gem::Specification.new do |spec|
  spec.name = "${gem_name}"
  spec.version = "0.1.0"
  spec.authors = ["ruby-gtk-project"]
  spec.email = ["nathanblenheimkidd@gmail.com"]
  spec.summary = "A Ruby GTK4 port of ${app}"
  spec.description = "A Ruby GTK4 / Libadwaita port of ${app}."
  spec.homepage = "https://github.com/ruby-gtk-project/${FORK}"
  spec.license = "${LICENSE}"
  spec.required_ruby_version = ">= 3.4"
  spec.executables = ${exec_list}
end
GS
fi

# 5. The template owns `bindir = exe`, and kettle-jem writes its own dev
#    scripts into bin/. Move every declared executable across, or gem build
#    fails with `["exe/<name>"] are not files`.
for e in $(cd "$CLONE" && ruby -e 'spec=Gem::Specification.load(Dir["*.gemspec"].first); puts spec.executables' 2>/dev/null); do
  if [ -f "$CLONE/bin/$e" ] && [ ! -e "$CLONE/exe/$e" ]; then
    mkdir -p "$CLONE/exe"
    git -C "$CLONE" mv "bin/$e" "exe/$e" 2>/dev/null || mv "$CLONE/bin/$e" "$CLONE/exe/$e"
    chmod +x "$CLONE/exe/$e"
  fi
done

# 6. Converge. --no-changelog: without it kettle-jem appends its own template
#    changelog entries into the port's CHANGELOG on every run.
if ! kettle-jem apply "$CLONE" --accept --skip-commit --quiet --no-changelog; then
  echo "::error::$FORK: kettle-jem apply failed" >&2
  exit 1
fi

# 7. Re-assert the recipe-owned paths.
for p in "${PROTECTED[@]}"; do
  git -C "$CLONE" checkout -- "$p" 2>/dev/null || true
done

# 8. Refuse to hand back a fork whose licence moved. These are forks of other
#    people's applications; the port inherits upstream's licence and never
#    gets a new one.
if ! grep -q -- "$LICENSE" "$CLONE"/*.gemspec; then
  echo "::error::$FORK gemspec licence is no longer $LICENSE" >&2
  exit 1
fi
for stray in MIT.md AGPL-3.0-only.md PolyForm-Small-Business-1.0.0.md certs/pboling.pem; do
  case "$stray" in "$LICENSE.md") continue ;; esac
  if [ -e "$CLONE/$stray" ]; then
    echo "::error::$FORK: kettle-jem wrote $stray under a $LICENSE licence" >&2
    exit 1
  fi
done

# 9. The flake and its lock must agree. kettle-jem does not touch flake.nix
#    (keep_destination — there is no Nix merger in the family), so this is the
#    one place the invariant is checked.
if ! "$AW/check-flake-lock.py" "$CLONE"; then
  exit 1
fi

echo "$FORK: packaged ($LICENSE)"
