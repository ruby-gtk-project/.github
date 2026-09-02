---
description: Report the port state of one fork by reading its ruby branch
user-invokable: false
---

# Port Scout — single fork

You are called with one repository in `owner/repo` form. Report its port state
as JSON. Read only; make no changes and open nothing.

## Gather

1. `PORTING.md` on the `ruby` branch — count `- [ ]` and `- [x]` unit entries.
   Missing file means the survey has not happened.
2. Ruby files under `lib/` and `bin/` on `ruby`.
3. Open PRs whose title starts with `[port]`, and the date of the most recent
   commit on `ruby`.
4. The parent repo's default branch (the upstream implementation) and its size,
   as a rough measure of how big the job is.

## Return

A single JSON object, nothing else:

```json
{
  "repo": "ruby-gtk-project/tally-rb",
  "phase": "bootstrap|survey|port|converge",
  "units_done": 0,
  "units_open": 0,
  "ruby_files": 0,
  "open_prs": 0,
  "last_commit": "2026-09-02",
  "upstream_files": 0,
  "blocker": "one sentence, or null"
}
```

Phase rules: no Ruby files → `bootstrap`; no ledger → `survey`; unticked units
remain → `port`; all units ticked → `converge`.

Set `blocker` when something is visibly stuck: an open PR older than a week
with failing CI, a ledger unchanged for two weeks while units remain, a build
that the repo's own issues say does not work. Otherwise null.
