# Excuse audit — 2026-10-01

## Summary

84 forks scanned, 13 with hits, 36 total hits. Since last week's report: 0 new hits, 0 destroyed hits.

## The ports

71 forks are clean.

| Port | Hits | Phrases | Worst of them |
|---|---:|---|---|
| Solanum-rb | 10 | not required, out of scope, Unported | `code-of-conduct.md:18` `out of scope` |
| console-rb | 5 | Dropped deliberately, upstream's own TODO, Not ported, deliberately dropped | `PORTING.md:35` `Dropped deliberately` |
| gtk-demos-and-examples | 4 | FIXME, not needed, TODO | `demos/gtk-demo/messages.txt:49` `not needed` |
| gnome-tour-rb | 4 | Not ported, not required, Not Required | `lib/gnome_tour_rb/i18n.rb:98` `not required` |
| workbench | 3 | skipping, no Ruby counterpart, skipped | `docs/ruby-support.md:190` `no Ruby counterpart` |
| workbench-demos | 2 | no Ruby counterpart, not needed | `FINDINGS.md:350` `no Ruby counterpart` |
| eyedropper-rb | 2 | no Ruby equivalent | `PORTING.md:72` `no Ruby equivalent` |
| planify-rb | 1 | not ported | `lib/planify/main_window.rb:384` `not ported` |
| gnome-system-monitor-rb | 1 | deliberately left out | `lib/gnome_system_monitor/system_stats.rb:13` `deliberately left out` |
| gnome-mahjongg-rb | 1 | no Ruby equivalent | `PORTING.md:24` `no Ruby equivalent` |
| gnome-logs-rb | 1 | not ported | `lib/gnome_logs/category.rb:56` `not ported` |
| binary-rb | 1 | not needed | `lib/window.rb:85` `not needed` |
| Curtail-rb | 1 | not required | `lib/curtail_rb/i18n.rb:147` `not required` |

## Destroyed this week

The following phrases appeared in last week's report but no longer appear for the named port: console-rb — `FIXME`, `not needed`, `TODO`; gnome-mahjongg-rb — `not needed`.

## What a hit means

Every hit is rewritten, never deleted. It is written in the first person, naming the behaviour owed as something the app does for a person; the omission is a debt, not a decision. A port with hits is carrying confessions that have not been rewritten yet.
