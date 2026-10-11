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
# Exit codes: 0 converged and packaged, 3 config seeded but the port has not
# started yet, 2 nothing to configure (not an application, or a licence a human
# must decide), 1 something went wrong that needs fixing.
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

# A compound expression cannot go into a single `spec.licenses` entry. Refuse
# rather than silently assert one half of it.
case "$LICENSE" in
  *" AND "*) echo "$FORK: compound licence ($LICENSE) — needs a decision" >&2; exit 2 ;;
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

# 2. Seed a gemspec when the fork has none: kettle-jem hard-fails with
#    "no gemspec found" (exit 2) and every port starts out without one.
#    spec.files is deliberately absent — kettle-jem then inserts its own
#    canonical assignment (which honours gemspec.package_files.include).
#    Any other shape raises "Unsupported gemspec spec.files assignment".
if ! compgen -G "$CLONE/*.gemspec" > /dev/null; then
  entrypoint=$(cd "$CLONE" && ls lib/*.rb 2>/dev/null | head -1 | xargs -r basename | sed 's/\.rb$//')
  if [ -z "$entrypoint" ]; then
    # The config is already seeded above, so the fork is set up for kettle-jem
    # the day someone writes lib/. There is nothing to package until then.
    echo "$FORK: config seeded, no lib/*.rb yet — port not started" >&2
    exit 3
  fi
  # Every launcher in bin/, minus the dev scripts kettle-jem puts there.
  mapfile -t execs < <(cd "$CLONE" && ls bin 2>/dev/null | grep -vx 'setup\|console')
  if [ ${#execs[@]} -eq 0 ]; then
    # No launcher means this is not an application port — gtk-demos-and-examples
    # is a set of standalone reference scripts. `gem-release.md` requires a
    # working command from `gem install`, so there is nothing to package here.
    echo "$FORK: no launcher in bin/ — not an application port" >&2
    exit 2
  fi
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

# 3. The template owns `bindir = exe`, and kettle-jem writes its own dev
#    scripts into bin/. Move every declared executable across, or gem build
#    fails with `["exe/<name>"] are not files`.
for e in $(cd "$CLONE" && ruby -e 'spec=Gem::Specification.load(Dir["*.gemspec"].first); puts spec.executables' 2>/dev/null); do
  if [ -f "$CLONE/bin/$e" ] && [ ! -e "$CLONE/exe/$e" ]; then
    mkdir -p "$CLONE/exe"
    git -C "$CLONE" mv "bin/$e" "exe/$e" 2>/dev/null || mv "$CLONE/bin/$e" "$CLONE/exe/$e"
    chmod +x "$CLONE/exe/$e"
  fi
done

# 4. Converge. --no-changelog: without it kettle-jem appends its own template
#    changelog entries into the port's CHANGELOG on every run.
if ! kettle-jem apply "$CLONE" --accept --skip-commit --quiet --no-changelog; then
  echo "::error::$FORK: kettle-jem apply failed" >&2
  exit 1
fi

# 5. Re-assert the recipe-owned paths.
for p in "${PROTECTED[@]}"; do
  git -C "$CLONE" checkout -- "$p" 2>/dev/null || true
done

# 6. Refuse to hand back a fork whose licence moved. These are forks of other
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

echo "$FORK: converged ($LICENSE)"
