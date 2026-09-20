#!/usr/bin/env python3
"""Turn the files binding-scan.sh fetched into gaps.json.

Every number the report and the issues carry is computed here. The agent that
reads gaps.json is told to count nothing itself, so anything it needs has to
come out of this file already counted.

A name the map does not classify is never guessed at. It goes to
`unclassified`, which is the scan's own maintenance queue: as long as that
list has entries with real app counts, the gap numbers are a floor rather
than a total, and the report says so.
"""
import collections
import json
import os
import re
import sys

SELFTEST = "--selftest" in sys.argv
OUT = os.environ.get("OUT", "")
MAP = json.load(open(
    os.environ.get("MAP") or os.path.join(os.path.dirname(__file__), "namespace-map.json"),
    encoding="utf8"))
PREV_PATH = os.environ.get("PREV") or ""

PKGCONFIG = MAP["pkgconfig"]
APP_INTERNAL = set(MAP["app_internal"])
PLATFORM = set(MAP["platform"])
RUST_GI = MAP["rust_gi_crates"]
DEMOS = set(MAP["demo_repos"])

# meson: dependency('libsoup-3.0', ...)
RE_MESON = re.compile(r"""dependency\s*\(\s*['"]([^'"]+)['"]""")
# python: gi.require_version('Adw', '1')  /  from gi.repository import Adw, Gtk
RE_REQVER = re.compile(r"""require_version\s*\(\s*['"]([\w.\-]+)['"]""")
RE_PYIMPORT = re.compile(r"""from[ \t]+gi\.repository[ \t]+import[ \t]+\(?([\w,\t ]+)""")
# gjs: imports.gi.Adw  /  import Adw from 'gi://Adw?version=1'
RE_GJS_OLD = re.compile(r"""imports\.gi\.(\w+)""")
RE_GJS_URI = re.compile(r"""['"]gi://(\w+)""")
# ruby-gnome: a gem names the namespace it binds as load("Adw"), super("Gtk"),
# LOG_DOMAIN = "Adw" or NAMESPACE = "WebKit2" - all four are in use.
RE_LOAD = re.compile(
    r"""(?:\bload|\bsuper|LOG_DOMAIN\s*=|NAMESPACE\s*=)"""
    r"""\s*\(?\s*["']([A-Za-z][\w]*)["']""")
# cargo: a dependency table entry
RE_CARGO_SECTION = re.compile(r"^\[([^\]]+)\]\s*$", re.M)
RE_CARGO_DEP = re.compile(r"^\s*([A-Za-z0-9_\-]+)\s*=", re.M)


def read(path):
    try:
        with open(path, encoding="utf8", errors="replace") as fh:
            return fh.read()
    except OSError:
        return ""


def cargo_deps(text):
    """Dependency names from every [dependencies]-like table, ignoring the rest."""
    names, keep = set(), False
    for line in text.splitlines():
        header = RE_CARGO_SECTION.match(line)
        if header:
            keep = header.group(1).split(".")[-1].endswith("dependencies")
            continue
        if keep:
            hit = RE_CARGO_DEP.match(line)
            if hit:
                names.add(hit.group(1))
    return names


def _selftest():
    """The extraction regexes decide every number here, and both of their
    failure modes have bitten already: a pattern that runs past the end of its
    line invents namespaces, and one that misses a spelling hides a gem that
    already exists. Run with --selftest."""
    assert RE_MESON.findall("dependency('libsoup-3.0', required: true)") == ["libsoup-3.0"]
    assert RE_MESON.findall('dependency("gtk4")') == ["gtk4"]

    # A python import must stop at the newline. Reading on turns the next
    # line's words into namespaces.
    py = "from gi.repository import Adw, Gtk\nimport os\nSOMETHING = 1\n"
    names = {n.strip() for n in RE_PYIMPORT.findall(py)[0].split(",")}
    assert names == {"Adw", "Gtk"}, names
    assert len(RE_PYIMPORT.findall(py)) == 1

    assert RE_REQVER.findall("gi.require_version('Gtk', '4.0')") == ["Gtk"]
    assert RE_GJS_OLD.findall("const Adw = imports.gi.Adw;") == ["Adw"]
    assert RE_GJS_URI.findall("import Gtk from 'gi://Gtk?version=4.0';") == ["Gtk"]

    # ruby-gnome names the namespace it binds in four different ways.
    assert RE_LOAD.findall('loader.load("Secret")') == ["Secret"]
    assert RE_LOAD.findall('      super("Gtk")') == ["Gtk"]
    assert RE_LOAD.findall('  LOG_DOMAIN = "Adw"') == ["Adw"]
    assert RE_LOAD.findall('  NAMESPACE = "WebKit2"') == ["WebKit2"]

    # Only real dependency tables count, and only their keys.
    toml = ('[package]\nname = "app"\n\n[dependencies]\ngtk4 = "0.9"\n'
            'soup3 = { version = "0.6" }\n\n[build-dependencies]\nglib-build-tools = "0.20"\n')
    assert cargo_deps(toml) == {"gtk4", "soup3", "glib-build-tools"}, cargo_deps(toml)

    print("selftest ok")


if SELFTEST:
    _selftest()
    sys.exit(0)


# --- read every fetched blob ------------------------------------------------
# namespace -> {app: [evidence kinds]}, and the raw names behind each namespace
demand = collections.defaultdict(lambda: collections.defaultdict(set))
sources = collections.defaultdict(set)
unclassified = collections.defaultdict(set)
rust_only = collections.defaultdict(set)

for entry in os.scandir(os.path.join(OUT, "blobs")):
    app, _, filename = entry.name.partition("__")
    if app in DEMOS:
        continue
    text = read(entry.path)
    if not text:
        continue

    if filename.endswith("meson.build"):
        for name in RE_MESON.findall(text):
            if name not in PKGCONFIG:
                unclassified[name].add(app)
                continue
            namespace = PKGCONFIG[name]
            if namespace:
                demand[namespace][app].add("meson")
                sources[namespace].add(name)

    elif filename.endswith("Cargo.toml"):
        for crate in cargo_deps(text):
            if crate in RUST_GI:
                namespace = RUST_GI[crate]
                if namespace:
                    demand[namespace][app].add("cargo")
                    sources[namespace].add(crate)
            else:
                # Pure-Rust crates are not bindings. They are "find a Ruby
                # equivalent" work and must never become a gem issue.
                rust_only[crate].add(app)

    else:  # .py / .js / .ts
        found = set(RE_REQVER.findall(text))
        found |= set(RE_GJS_OLD.findall(text))
        found |= set(RE_GJS_URI.findall(text))
        for group in RE_PYIMPORT.findall(text):
            for name in group.split(","):
                name = name.strip().split(" as ")[0].strip()
                if name[:1].isupper():
                    found.add(name)
        for namespace in found:
            if namespace in APP_INTERNAL or namespace in PLATFORM:
                continue
            demand[namespace][app].add("import")
            sources[namespace].add(namespace)

# A namespace only ever seen as an import still has to survive the map's
# exclusions; drop anything the map calls app-internal or platform.
for namespace in list(demand):
    if namespace in APP_INTERNAL or namespace in PLATFORM:
        del demand[namespace]

# --- what ruby-gnome ships --------------------------------------------------
# loader.load("Adw") in a subproject's entry point is the gem/namespace link.
covered = {}
for entry in os.scandir(os.path.join(OUT, "rg")):
    gem = entry.name.split("_lib_")[0]
    for namespace in RE_LOAD.findall(read(entry.path)):
        covered.setdefault(namespace, gem)

# glib2 loads GLib/GObject/GModule through its C extension rather than a
# loader.load call, so the scan cannot see them. They are the one hardcoded
# exception and are listed explicitly rather than inferred.
for namespace, gem in MAP["extra_coverage"].items():
    covered.setdefault(namespace, gem)

if len(covered) < 10:
    print("::error::ruby-gnome coverage came back nearly empty "
          f"({len(covered)} namespaces) - refusing to report every "
          "namespace as a gap", file=sys.stderr)
    sys.exit(1)

# --- split into gaps and covered -------------------------------------------
gaps, already = [], []
for namespace, apps in demand.items():
    row = {
        "namespace": namespace,
        "apps": sorted(apps),
        "app_count": len(apps),
        "pkgconfig": sorted(sources[namespace]),
        "evidence": sorted({kind for kinds in apps.values() for kind in kinds}),
    }
    if namespace in covered:
        row["gem"] = covered[namespace]
        already.append(row)
    else:
        gaps.append(row)

gaps.sort(key=lambda r: (-r["app_count"], r["namespace"]))
already.sort(key=lambda r: (-r["app_count"], r["namespace"]))

per_app = collections.defaultdict(list)
for row in gaps:
    for app in row["apps"]:
        per_app[app].append(row["namespace"])

previous = {}
if PREV_PATH and os.path.exists(PREV_PATH):
    try:
        previous = json.load(open(PREV_PATH, encoding="utf8"))
    except (OSError, ValueError):
        previous = {}
prev_gaps = {row["namespace"]: row for row in previous.get("gaps", [])}
now = {row["namespace"] for row in gaps}

targets = sum(1 for _ in open(os.path.join(OUT, "targets.tsv"), encoding="utf8"))
failures = [line.split("\t")[0]
            for line in read(os.path.join(OUT, "tree-failures.txt")).splitlines() if line]

result = {
    "scan_date": os.environ.get("SCAN_DATE", ""),
    "fleet": {
        "port_targets": targets,
        "scanned": targets - len(failures),
        "unreadable": failures,
        "demo_repos_excluded": sorted(DEMOS),
        "apps_with_gaps": len(per_app),
        "apps_fully_covered": targets - len(DEMOS) - len(per_app),
    },
    "coverage": {
        "source": "ruby-gnome/ruby-gnome@main",
        "namespaces": len(covered),
        "gems": sorted(set(covered.values())),
    },
    "gaps": gaps,
    "covered": already,
    "per_app": {app: sorted(names) for app, names in sorted(per_app.items())},
    # On the first run there is nothing to compare against, so the deltas are
    # empty rather than "every gap is new" - which would be true but useless.
    "delta": {
        "new": sorted(now - set(prev_gaps)) if previous else [],
        "closed": sorted(set(prev_gaps) - now) if previous else [],
        "moved": sorted(
            {r["namespace"] for r in gaps
             if r["namespace"] in prev_gaps
             and r["app_count"] != prev_gaps[r["namespace"]]["app_count"]}
        ) if previous else [],
        "had_previous": bool(previous),
    },
    # An issue's body is written once and deduplicate-by-title never refreshes
    # it, so a gap whose port count changed needs its issue rewritten. Both
    # counts are here so the agent restates rather than recalculates.
    "moved_detail": [
        {"namespace": r["namespace"], "was": prev_gaps[r["namespace"]]["app_count"],
         "now": r["app_count"], "apps": r["apps"]}
        for r in gaps
        if previous and r["namespace"] in prev_gaps
        and r["app_count"] != prev_gaps[r["namespace"]]["app_count"]
    ],
    "unclassified": [
        {"name": name, "app_count": len(apps), "apps": sorted(apps)}
        for name, apps in sorted(unclassified.items(), key=lambda kv: -len(kv[1]))
    ],
    "rust_not_bindings": [
        {"crate": crate, "app_count": len(apps)}
        for crate, apps in sorted(rust_only.items(), key=lambda kv: -len(kv[1]))[:40]
    ],
}

with open(os.path.join(OUT, "gaps.json"), "w", encoding="utf8") as fh:
    json.dump(result, fh, indent=1)

print(f"gaps: {len(gaps)} namespaces across {len(per_app)} apps; "
      f"covered: {len(already)}; unclassified: {len(unclassified)}")

