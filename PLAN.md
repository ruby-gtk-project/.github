# Port campaign plan

## Goal

A working Ruby GTK4/Libadwaita port of each GNOME app in the org, built in
reviewable increments, with every increment demonstrated running.

## Fleet

78 forks, one per GNOME app with a GitHub repo (the 22 GitLab/Codeberg-only
apps are out of scope). Each fork's `ruby` branch starts from the shared setup:
the `ruby-gtk` and `ruby-gtk-testing` skills, a GTK4 dev shell, the house
rubocop config and cops, and `gem_kit`.

## Pilot set

Five forks prove the loop before it runs fleet-wide:

| Fork | Why |
|---|---|
| `console-rb` | Port already underway; has `PORTING.md` and `FINDINGS.md` |
| `gnome-contacts-rb` | Port already underway; largest of the three |
| `gnome-logs-rb` | Port already underway; has a ledger to reconcile |
| `tally-rb` | Small enough to actually finish |
| `binary-rb` | Small enough to actually finish |

Nothing runs on the other 73 until the pilots produce merged PRs that a human
would have written the same way.

## The unit

A **unit** is the smallest piece of the app that can be ported, run and seen:
one window, one dialog, one page, one list view, one action group. Not "the
model layer" — a unit has to be demonstrable.

Every unit is a sub-issue of its app's epic. Every unit gets one draft PR.
Every port PR carries a screenshot of the thing running, captured with the
`ruby-gtk-testing` skill. No screenshot, no review.

## Ledger

Each fork keeps `PORTING.md` at the root of the `ruby` branch: the enumerated
units, their state, and a cursor. It is the source of truth — agent memory is
a cache of it, not a replacement. The fleet orchestrator reads it to decide
where effort goes, and mirrors it into the app's epic here.

## Phases

1. **Bootstrap** — the fork builds, `bundle install` succeeds, an empty window
   opens headlessly. Nothing else starts until this passes.
2. **Survey** — enumerate units from the upstream branch into `PORTING.md`,
   open the epic and its sub-issues here.
3. **Port** — one unit per draft PR, screenshot attached, house style clean.
4. **Converge** — reconcile the ported app against upstream behaviour; close
   the epic when its sub-issues are done.

## Boundaries

- Agents never merge. Draft PRs only.
- Agents never touch `.github/workflows` in a fork (`protected-files`).
- Ports are derivative works of GPL originals: upstream `COPYING` stays on the
  `ruby` branch, and every port file keeps its provenance comment.
- A fork with 4 open `[port]` PRs stops scheduling new work.
