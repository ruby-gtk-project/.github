#!/usr/bin/env python3
"""Move one candidate into the registry's `forked` section, in place.

Called by fork-from-registry.sh once the fork actually exists. Kept apart from
that script because rewriting YAML with sed is how registries get corrupted.

    registry-promote.py <registry> <app> <fork> <upstream> <upstream_branch>
"""
import re
import sys

reg, app, fork, upstream, branch = sys.argv[1:6]
text = open(reg).read()

if '\ncandidates:' not in text:
    sys.exit('no candidates section')
head, cands = text.split('\ncandidates:', 1)

# Drop the candidate block for this app: from its `- app:` line to the next.
lines = cands.splitlines(keepends=True)
out, dropping, found = [], False, False
for line in lines:
    if re.match(r'\s*-\s*app:\s*' + re.escape(app) + r'\s*$', line):
        dropping, found = True, True
        continue
    if dropping and re.match(r'\s*-\s*app:', line):
        dropping = False
    if not dropping:
        out.append(line)
if not found:
    sys.exit(f'{app} not found among candidates')

entry = f'  - fork: {fork}\n    upstream: {upstream}\n    upstream_branch: {branch}\n'
if not head.endswith('\n'):
    head += '\n'
# `forked` entries stay sorted by fork name, case-insensitively.
blocks = re.findall(r'  - fork: .*?(?=\n  - fork: |\Z)', head.split('forked:', 1)[1], re.S)
blocks = [b if b.endswith('\n') else b + '\n' for b in blocks] + [entry]
blocks.sort(key=lambda b: b.split('fork:', 1)[1].split('\n', 1)[0].strip().lower())
prefix = head.split('forked:', 1)[0]
open(reg, 'w').write(prefix + 'forked:\n' + ''.join(blocks) + '\ncandidates:' + ''.join(out))
