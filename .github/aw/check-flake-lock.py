#!/usr/bin/env python3
"""Verify a fork's flake.nix and flake.lock agree.

    check-flake-lock.py <clone-dir>

A flake is only reproducible if every input declared in flake.nix has a locked
node in flake.lock, carrying a rev and a narHash. flake.lock is JSON, so this
reads it as structured data rather than grepping text: a missing node, a
missing narHash, or a node for an input that flake.nix no longer declares all
mean the dev shell someone gets is not the one we pinned.

Exit 0 when they agree, 1 with a GitHub error annotation when they do not.
"""
import json
import pathlib
import re
import sys

clone = pathlib.Path(sys.argv[1])
nix, lock_path = clone / "flake.nix", clone / "flake.lock"
fork = clone.name

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

declared = set(re.findall(r"^\s*([A-Za-z0-9_-]+)\.url\s*=", nix.read_text(), re.M))
root = lock.get("root", "root")
nodes = lock.get("nodes", {})
# A transitive input (utils/systems) is a node of its parent, not of the root.
top = set(nodes.get(root, {}).get("inputs", {})) or (set(nodes) - {root})

problems = []
for name in sorted(declared - top):
    problems.append(f"input '{name}' is declared in flake.nix but absent from flake.lock")
for name in sorted(top - declared):
    problems.append(f"flake.lock pins '{name}' but flake.nix no longer declares it")
for name in sorted(declared & top):
    locked = nodes.get(name, {}).get("locked", {})
    if not locked.get("narHash"):
        problems.append(f"input '{name}' has no narHash in flake.lock")
    elif locked.get("type") == "github" and not locked.get("rev"):
        problems.append(f"input '{name}' has no rev in flake.lock")

if problems:
    for p in problems:
        print(f"::error::{fork} flake mismatch: {p}", file=sys.stderr)
    sys.exit(1)

print(f"{fork}: flake.nix and flake.lock agree ({len(declared)} inputs pinned)")
