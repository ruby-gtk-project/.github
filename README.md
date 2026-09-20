# ruby-gtk-project

Porting GNOME apps to Ruby + GTK4/Libadwaita.

Each app lives in its own fork under this org, named `<upstream>-rb`. The fork's
default branch is `ruby` — an orphan branch holding the port. The upstream
implementation stays on the fork's original branch, so every port repo carries
its own reference implementation.

This repo is the planning hub: the campaign plan, the per-app epics, the fleet
dashboard, and the canonical agentic workflows the forks redirect to.

## Workflows

| Workflow | Runs | What it does | Outcome |
|---|---|---|---|
| `find-new-gtk-apps-gnome.md` | monthly | Browses apps.gnome.org with Playwright, follows each app's page to find where its source lives, prefers a GitHub home when one exists, and checks whether a fork exists. | One pull request per new app, adding its entry to `registry.yml`. "No new repos to add" if every app already has a fork. |
| `find-new-gtk-apps-github.md` | daily | The same for the rest of GitHub — topic and code search, awesome lists, Flathub — judged against size, health, toolkit and licence. | Pull request adding entries to `registry.yml`. Nothing if it finds nothing worth porting. |
| `fork-new-gtk-apps.md` | weekly | Reads `registry.yml` and makes every listed fork exist: forks it when the upstream is on GitHub, mirrors it in when it is not. | **Creates repositories in the org directly.** No pull request, no issue. Does nothing to forks that already exist. |
| `create-initial-port-issues.md` | weekly | Decides which forks are port targets. | Creates `Initial port: <fork>` and `Gem release: <fork>` issues here, bodies copied from `.github/port-issues/`, and adds both to the Initial port project. |
| `scaffold-port-forks.md` | weekly | Every fork has a scaffolded `ruby` branch matching `port-scaffold/`. | **Commits and pushes to each fork's `ruby` branch directly.** No pull request. Creates the orphan branch where one is missing. |
| `sync-port-scaffold-skills.yml` | 03:17 daily | Mirrors `ruby-gtk-project/skills` into `port-scaffold/.claude/skills/`. | **Commits to `main` of this repo directly.** No pull request. |
| `report-weekly-progress.md` | Mondays | Fleet report from every fork's `PORTING.md`. | Commits the report to `reports/` and opens a review issue on the Reports project. |
| `report-binding-gaps.md` | monthly | Works out which GObject Introspection namespaces the ports need and subtracts what ruby-gnome ships. | Commits a scan to `reports/`, and opens or updates one issue per missing gem on the Bindings project. |
| `report-parity.md` | on demand | Compares a finished port against the original. Run it when a port looks done. | Opens a pull request **in the fork being reviewed**, adding `PARITY_REPORT-<date>.md`. |

`registry.yml` is the gate: an entry in it is the instruction to fork, and
entries only arrive by pull request.

## Working on the workflows

```sh
gh extension install github/gh-aw
gh aw compile              # compiles .github/workflows/*.md
gh aw compile --dir workflows
```

Every `.md` workflow compiles to a `.lock.yml` beside it. Edit the markdown,
never the lock file.
