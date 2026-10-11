#!/usr/bin/env python3
"""Verify a fork's flake.nix and flake.lock agree.

    check-flake-lock.py <clone-dir> [fork-name]

A flake is only reproducible if every input declared in flake.nix has a locked
node in flake.lock carrying a rev and a narHash. flake.lock is JSON, so it is
read as structured data rather than grepped.

What is fatal is what breaks reproducibility: no lock at all, a lock that is
not valid JSON, an input declared but not pinned, or an input pinned without a
rev or narHash. A node the lock still pins that flake.nix appears not to
declare is only reported — flake.nix is Nix, not a format this can parse
exactly, and a stale node does not float an input.

Both input spellings are recognised:

    inputs = { nixpkgs.url = "..."; }      # block form
    inputs.nixpkgs.url = "...";            # flat form
"""
import json
import pathlib
import re
import sys

clone = pathlib.Path(sys.argv[1])
fork = sys.argv[2] if len(sys.argv) > 2 else clone.name
nix, lock_path = clone / "flake.nix", clone / "flake.lock"

if not nix.exists():
    print(f"::error::{fork} has no flake.nix", file=sys.stderr)
    sys.exit(1)
if not lock_path.exists():
    print(f"::error::{fork} has flake.nix but no flake.lock — the inputs float", file=sys.stderr)
    sys.exit(1)

try:
    lock = json.loads(lock_path.read_text())
except json.JSONDecodeError as e:
    print(f"::error::{fork} flake.lock is not valid JSON: {e}", file=sys.stderr)
    sys.exit(1)

source = nix.read_text()
declared = set(re.findall(r"^\s*inputs\.([A-Za-z0-9_-]+)\.(?:url|follows)\s*=", source, re.M))
declared |= set(re.findall(r"^\s*([A-Za-z0-9_-]+)\.(?:url|follows)\s*=", source, re.M))
declared.discard("inputs")

root = lock.get("root", "root")
nodes = lock.get("nodes", {})
pinned = set(nodes.get(root, {}).get("inputs", {})) or (set(nodes) - {root})

fatal, notes = [], []
for name in sorted(declared - pinned):
    fatal.append(f"input '{name}' is declared in flake.nix but is not pinned in flake.lock")
for name in sorted(declared & pinned):
    locked = nodes.get(name, {}).get("locked", {})
    if not locked.get("narHash"):
        fatal.append(f"input '{name}' is pinned without a narHash")
    elif locked.get("type") == "github" and not locked.get("rev"):
        fatal.append(f"input '{name}' is pinned without a rev")
for name in sorted(pinned - declared):
    notes.append(f"flake.lock pins '{name}', which flake.nix does not appear to declare")

for n in notes:
    print(f"{fork}: note: {n}")
if fatal:
    for f in fatal:
        print(f"::error::{fork} flake mismatch: {f}", file=sys.stderr)
    sys.exit(1)

print(f"{fork}: flake.nix and flake.lock agree ({len(declared & pinned)} inputs pinned)")
