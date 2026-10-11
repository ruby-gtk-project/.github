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

# 3. The flake has to output a packaged app, not just a dev shell. A fork
#    still carrying a superseded scaffold flake (hash in flake-legacy-hashes)
#    has never been customised, so it is replaced. A fork that grew its own
#    flake keeps it — gnome-mahjongg-rb, Commit-rb and the other live ports own
#    theirs, and overwriting them would throw away real work.
if [ ! -f "$CLONE/flake.nix" ]; then
  sed "s/{{APP}}/$app/g" "$AW/flake-scaffold.nix" > "$CLONE/flake.nix"
  rm -f "$CLONE/flake.lock"
elif grep -qxF "$(sha256sum "$CLONE/flake.nix" | cut -d' ' -f1)" "$AW/flake-legacy-hashes.txt"; then
  sed "s/{{APP}}/$app/g" "$AW/flake-scaffold.nix" > "$CLONE/flake.nix"
  rm -f "$CLONE/flake.lock"
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

# 6. The runtime gemdir. bundlerEnv builds the app's gems with Nix, which is the
#    only way the ruby-gnome GTK4 extensions compile: nixpkgs ships
#    rubyPackages.glib2 and gobject-introspection but no gtk4 or adwaita.
#    This is the gemspec's RUNTIME dependencies only — the root Gemfile is
#    kettle-jem's development bundle and must not reach a packaged app.
mkdir -p "$CLONE/nix"
runtime_gems=$(cd "$CLONE" && ruby -e '
  spec = Gem::Specification.load(Dir["*.gemspec"].first)
  names = spec.runtime_dependencies.map(&:name)
  # Every port is a GTK4/Libadwaita app whether or not its gemspec says so yet.
  puts ((names + %w[gtk4 adwaita]).uniq - ["gem_kit"]).sort
' 2>/dev/null)
{
  echo "# frozen_string_literal: true"
  echo
  echo "# The app's RUNTIME gems, for bundlerEnv in flake.nix. Generated by"
  echo "# converge-port-gem.sh from the gemspec; do not edit by hand."
  echo "#"
  echo "# The Gemfile at the repo root is kettle-jem's development bundle —"
  echo "# rubocop, rspec, yard and the kettle-dev stack — and must not end up in"
  echo "# a packaged app's closure."
  echo 'source "https://rubygems.org"'
  echo
  for g in $runtime_gems; do echo "gem \"$g\""; done
} > "$CLONE/nix/Gemfile"

# A packaged app needs its runtime lock committed; the scaffold .gitignore has
# a blanket Gemfile.lock rule, so make sure the exception is there.
if ! grep -qxF '!nix/Gemfile.lock' "$CLONE/.gitignore" 2>/dev/null; then
  printf '\n# nix/ is the runtime gemdir for flake.nix: bundlerEnv needs its lock and\n# gemset committed or the app cannot be built reproducibly.\n!nix/Gemfile.lock\n' >> "$CLONE/.gitignore"
fi

# Resolve and convert. ruby_3_4 here matches the flake's `pkgs.ruby_3_4`, so the
# lock is resolvable by the ruby that will actually build the gems.
# Only resolve when it is actually stale: bundle lock plus a bundix prefetch of
# every gem is the slowest step here, and across 89 forks that is the whole run.
if [ ! -f "$CLONE/nix/gemset.nix" ] || ! git -C "$CLONE" diff --quiet -- nix/Gemfile 2>/dev/null; then
  # This script runs under `bundle exec` on Ruby 4 for kettle-jem, which exports
  # RUBYLIB, RUBYOPT, GEM_HOME and friends pointing at that bundle. Leaking any
  # of them into a ruby_3_4 shell breaks rubygems' prelude before bundler even
  # loads. ruby_3_4 matches the flake's `pkgs.ruby_3_4`, so the lock is
  # resolvable by the ruby that will actually build the gems.
  if ! env -u GEM_HOME -u GEM_PATH -u GEM_SPEC_CACHE -u RUBYLIB -u RUBYOPT \
        -u BUNDLE_GEMFILE -u BUNDLE_PATH -u BUNDLE_BIN_PATH -u BUNDLER_VERSION \
        -u BUNDLER_SETUP \
        nix shell nixpkgs#ruby_3_4 nixpkgs#bundler nixpkgs#bundix --command bash -c "
        cd '$CLONE/nix' && export BUNDLE_PATH=\$PWD/.bundle-tmp &&
        bundle lock && bundix && rm -rf .bundle-tmp"; then
    echo "::error::$FORK: could not generate nix/Gemfile.lock and nix/gemset.nix" >&2
    exit 1
  fi
fi

# 7. A flake with no lock is not reproducible: `nixos-unstable` floats and the
#    dev shell someone gets is not the one we pinned.
if [ ! -f "$CLONE/flake.lock" ]; then
  if ! nix --extra-experimental-features "nix-command flakes" \
        flake lock "$CLONE" >/dev/null 2>&1; then
    echo "::error::$FORK: could not lock flake.nix" >&2
    exit 1
  fi
fi

# 8. Converge. --no-changelog: without it kettle-jem appends its own template
#    changelog entries into the port's CHANGELOG on every run.
if ! kettle-jem apply "$CLONE" --accept --skip-commit --quiet --no-changelog; then
  echo "::error::$FORK: kettle-jem apply failed" >&2
  exit 1
fi

# 9. Re-assert the recipe-owned paths.
for p in "${PROTECTED[@]}"; do
  git -C "$CLONE" checkout -- "$p" 2>/dev/null || true
done

# 10. Refuse to hand back a fork whose licence moved. These are forks of other
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

# 11. The flake and its lock must agree. kettle-jem does not touch flake.nix
#    (keep_destination — there is no Nix merger in the family), so this is the
#    one place the invariant is checked.
if ! "$AW/check-flake-lock.py" "$CLONE" "$FORK"; then
  exit 1
fi

echo "$FORK: packaged ($LICENSE)"
