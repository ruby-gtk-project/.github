# ruby-gtk-project

Porting GNOME apps to Ruby + GTK4/Libadwaita.

Each app lives in its own fork under this org, named `<upstream>-rb`. The fork's
default branch is `ruby` — an orphan branch holding the port. The upstream
implementation stays on the fork's original branch, so every port repo carries
its own reference implementation.

This repo is the planning hub: the campaign plan, the per-app epics, the fleet
dashboard, and the canonical agentic workflows the forks redirect to.

## Workflows

Nine workflows. Two of them are the discovery loop, and the rest were here
before it.

### The discovery loop

`registry.yml` is the gate: an entry in it is the instruction to fork, and
entries only arrive by pull request. Nothing is forked, issued or scaffolded
that is not listed there.

| Workflow | Runs | What it does |
|---|---|---|
| `scan-app-sources.md` | daily | Reads apps.gnome.org, follows each app's page to find where its source actually lives, checks whether a fork exists, and opens a PR adding the ones that do not. |
| `find-gtk-apps.md` | daily | The same job for the rest of GitHub — topic and code search, awesome lists, Flathub, the authors we already fork — judged against size, health, toolkit and licence. |
| `fork-or-mirror.md` | daily | Reads `registry.yml` and makes every listed fork exist: forks it when the upstream is on GitHub, mirrors it in when it is not. Does nothing to forks that already exist. |

Merging a registry PR is what authorises a fork. The agents never fork
anything themselves.

### Keeping the fleet consistent

| Workflow | Runs | What it does |
|---|---|---|
| `reconcile-forks.yml` | 03:41 daily | Every fork's issues match the templates, and its `ruby` branch matches `port-scaffold/`. Plain Actions — there is no judgement in it, so it can exit non-zero when something is wrong. |
| `sync-skills.yml` | 03:17 daily | Mirrors `ruby-gtk-project/skills` into `port-scaffold/.claude/skills/`, so a skill edit reaches every fork overnight. |
| `initial-port.md` | daily | Decides which forks are port targets and gives each one its `Initial port` and `Gem release` issue on the board. |

### Reporting and review

| Workflow | Runs | What it does |
|---|---|---|
| `parity-review.md` | on demand | Compares a finished port against the original and opens a PR adding a dated `PARITY_REPORT`. Run it when a port looks done. |
| `weekly-report.md` | Mondays | Fleet report from every fork's `PORTING.md`, committed to `reports/` with a review issue. |
| `binding-gaps.md` | Mondays | Works out which GObject Introspection namespaces the ports need, subtracts what ruby-gnome ships, and opens an issue per missing gem. |

## Working on the workflows

```sh
gh extension install github/gh-aw
gh aw compile              # compiles .github/workflows/*.md
gh aw compile --dir workflows
```

Every `.md` workflow compiles to a `.lock.yml` beside it. Edit the markdown,
never the lock file.
