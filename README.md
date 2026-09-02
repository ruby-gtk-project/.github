# ruby-gtk-project

Porting GNOME apps to Ruby + GTK4/Libadwaita.

Each app lives in its own fork under this org, named `<upstream>-rb`. The fork's
default branch is `ruby` — an orphan branch holding the port. The upstream
implementation stays on the fork's original branch, so every port repo carries
its own reference implementation.

This repo is the planning hub: the campaign plan, the per-app epics, the fleet
dashboard, and the canonical agentic workflows the forks redirect to.

## Layout

| Path | What |
|---|---|
| `PLAN.md` | The campaign plan: phases, pilot set, what a "unit" is |
| `workflows/` | Canonical agentic workflows; forks hold 3-line `redirect:` stubs |
| `workflows/shared/` | Shared fragments imported by the above |
| `.github/agents/` | Subagents dispatched by the fleet orchestrator |
| `.github/workflows/` | This hub's own workflows (planning, triage, reporting) |

## Working on the workflows

```sh
gh extension install github/gh-aw
gh aw compile              # compiles .github/workflows/*.md
gh aw compile --dir workflows
```

Every `.md` workflow compiles to a `.lock.yml` beside it. Edit the markdown,
never the lock file.
