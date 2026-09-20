#!/usr/bin/env python3
"""Apply a registry proposal issue to .github/port-registry.yml.

    apply-proposal.py <registry> <issue-body-file>

The agents cannot write files in this repo's workflows — their container's
edits never reach the checkout, so a pull request built from them is empty.
They report instead, in a fenced yaml block, and this applies it.

Only `candidates` are touched. `forked` is never edited here: entries move
there when a fork or import actually succeeds.
"""
import re
import sys

FIELDS = ('source', 'vcs', 'host', 'github', 'status', 'checked')
# `drop` removes a candidate: it turned out to be an app we already forked.
# The registry's first candidate list was built by URL-matching Flathub's
# vcs_browser against fork parents, which silently misses every app whose page
# lists GitLab while its fork came from a GitHub home. 27 of the first 50 were
# wrong that way.
VALID = {'ready-to-fork', 'ready-to-import', 'needs-github-home', 'drop'}


def parse_proposal(body):
    blocks = re.findall(r'```ya?ml\s*\n(.*?)```', body, re.S)
    if not blocks:
        sys.exit('no yaml block in the issue body')
    entries, cur = [], None
    for raw in '\n'.join(blocks).splitlines():
        line = raw.rstrip()
        if not line.strip() or line.strip().startswith('#'):
            continue
        m = re.match(r'-\s*app:\s*(.+?)\s*$', line.strip())
        if m:
            cur = {'app': m.group(1).strip().strip('"\'')}
            entries.append(cur)
            continue
        m = re.match(r'(\w+):\s*(.*)$', line.strip())
        if m and cur is not None and m.group(1) in FIELDS:
            cur[m.group(1)] = m.group(2).strip().strip('"\'')
    bad = [e for e in entries if e.get('status') not in VALID]
    if bad:
        sys.exit(f"entries with a bad or missing status: {[e['app'] for e in bad]}")
    for e in entries:
        if e['status'] == 'drop':
            continue
        if e['status'] == 'ready-to-fork' and not e.get('github'):
            sys.exit(f"{e['app']}: ready-to-fork needs a github: field")
        # vcs may be absent here and inherited from the registry entry: the
        # agent's output has non-GitHub URLs redacted, and the registry
        # already holds the real one. Checked after the merge instead.
    return entries


def split_candidates(text):
    if '\ncandidates:' not in text:
        sys.exit('registry has no candidates section')
    head, rest = text.split('\ncandidates:', 1)
    blocks, cur = [], None
    for line in rest.splitlines(keepends=True):
        if re.match(r'\s*-\s*app:', line):
            cur = [line]
            blocks.append(cur)
        elif cur is not None:
            cur.append(line)
    return head, blocks


def app_of(block):
    return block[0].split('app:', 1)[1].strip()


def render(app, data):
    out = [f'  - app: {app}\n']
    for k in FIELDS:
        if data.get(k):
            out.append(f'    {k}: {data[k]}\n')
    return out


def main():
    reg, body_file = sys.argv[1], sys.argv[2]
    entries = parse_proposal(open(body_file).read())
    text = open(reg).read()
    head, blocks = split_candidates(text)
    by_app = {app_of(b): b for b in blocks}

    changed = []
    for e in entries:
        app = e['app']
        if e['status'] == 'drop':
            if app in by_app:
                blocks.remove(by_app[app])
                del by_app[app]
                changed.append(f'{app} dropped (already forked)')
            continue
        data = {}
        if app in by_app:
            for line in by_app[app][1:]:
                m = re.match(r'\s*(\w+):\s*(.*)$', line)
                if m:
                    data[m.group(1)] = m.group(2).strip()
        data.update({k: v for k, v in e.items() if k != 'app'})
        if data['status'] == 'ready-to-import' and not data.get('vcs'):
            sys.exit(f"{app}: ready-to-import and no vcs, in the proposal or the registry")
        new = render(app, data)
        if app in by_app:
            if by_app[app] != new:
                by_app[app][:] = new
                changed.append(f'{app} -> {data["status"]}')
        else:
            blocks.append(new)
            by_app[app] = new
            changed.append(f'{app} added as {data["status"]}')

    if not changed:
        print('no changes')
        return
    body = ''.join(''.join(b) for b in blocks)
    open(reg, 'w').write(head + '\ncandidates:\n' + body)
    print('\n'.join(changed))


main()
