# ruby-gtk-project

Porting GNOME apps to Ruby + GTK4/Libadwaita.

Each app lives in its own fork under this org, named `<upstream>-rb`. The fork's
default branch is `ruby` — an orphan branch holding the port. The upstream
implementation stays on the fork's original branch, so every port repo carries
its own reference implementation.

This repo is the planning hub: the campaign plan, the per-app epics, the fleet
dashboard, and the canonical agentic workflows the forks redirect to.

## Workflows

| Workflow | Runs | What it does |
|---|---|---|
| `find-new-gtk-apps-gnome.md` | daily | Reads apps.gnome.org, follows each app's page to find where its source lives, checks whether a fork exists, and opens a PR adding the ones that do not. |
| `find-new-gtk-apps-github.md` | daily | The same for the rest of GitHub — topic and code search, awesome lists, Flathub — judged against size, health, toolkit and licence. |
| `check-and-fork-registry-apps.md` | daily | Reads `registry.yml` and makes every listed fork exist: forks it when the upstream is on GitHub, mirrors it in when it is not. |
| `initial-port.md` | daily | Decides which forks are port targets and gives each one its `Initial port` and `Gem release` issue on the board. |
| `sync-port-scaffold-skills.yml` | 03:17 daily | Mirrors `ruby-gtk-project/skills` into `port-scaffold/.claude/skills/`. |
| `reconcile-forks.md` | daily | Every fork has a scaffolded `ruby` branch matching `port-scaffold/`. |
| `report-weekly-progress.md` | Mondays | Fleet report from every fork's `PORTING.md`, committed to `reports/` with a review issue. |
| `report-binding-gaps.md` | Mondays | Works out which GObject Introspection namespaces the ports need, subtracts what ruby-gnome ships, opens an issue per missing gem. |
| `report-parity.md` | on demand | Compares a finished port against the original and opens a PR adding a dated `PARITY_REPORT`. |

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
