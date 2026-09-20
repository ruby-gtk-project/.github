# AGENTS.md

## Read the docs before touching any workflow

This is not optional. Before creating, editing, or debugging anything under
`.github/workflows/`, read the vendored documentation:

- `docs/llms.txt` — the index of every gh-aw agent-instruction file
- `docs/llms-full.txt` — the full gh-aw instruction corpus (frontmatter
  reference, tools, safe outputs, threat detection, network, bash rules)
- `references/github-agentics/` — the githubnext/agentics pack (submodule),
  the reference implementation for how these workflows are meant to look

Every mistake made on these workflows — unexecutable bash allowlists, draft
PRs nobody wanted, detection false positives, silent green failures — came
from someone writing workflow config they had not read the docs for. The docs
answer it. Read them first.

## Working on the workflows

**Agents are limited to decision-making and creation.** Persistence —
commits, pushes, issue board syncs, comment rewrites — belongs in
`post-steps:` (or in plain Actions workflows) running on the runner with the
PAT. Never give the agent a write it can fumble when a step can do it
deterministically: a deduplicated safe-output registers no temporary id, so
agent-driven follow-up writes fail on every run after the first. If a piece of
work has no judgement in it at all, it is not an agentic workflow — it is a
plain action (see `fork-new-gtk-apps.yml`).

- Edit the `.md`, never the `.lock.yml`. Recompile with `gh aw compile`.
- **Always compile all workflows at once** (`gh aw compile`, no filter). The
  action-failure expiry patch only runs on a full compile — compiling a single
  workflow leaves its lock file with the wrong `EXPIRES_HOURS` value.
- **Never pipe `gh aw compile` into `tail`/`head` inside an `&&` chain** — the
  pipeline masks a non-zero exit and you commit stale locks. Check the exit
  code.
- The compiler pins: do not change action SHAs, container digests, or compiler
  version by hand. Upgrade with `gh aw upgrade`.
- After editing, compile and check the diff of the lock matches what you meant
  to change. Then test with `gh workflow run <file> --ref main`, watch with
  `gh run watch <id>`, and inspect with `gh aw audit <id>`.
- **The parity reports** (`report-parity`, `report-parity-test`,
  `report-parity-translation`) **live in `port-scaffold/.github/workflows/`**,
  synced into every fork as `.md` only; each fork compiles its own locks with
  `compile-agentic-workflows.yml` on push. Edit them in the scaffold, never in
  a fork. They are dispatch-only and write to `.reports/` in the target repo.

## Lessons paid for with broken runs

- **bash allowlists**: a hand-rolled narrow list (`"grep *"`) compiles to
  bare-command entries that deny the command with arguments — a run died
  because its own prompt's `curl | grep` was permission-denied. For scheduled
  workflows with no untrusted input, the documented and correct choice is
  `bash: ["*"]` (see the bash allowlist decision rule in the docs).
- **`create-pull-request` defaults to `draft: true`**, enforced as policy —
  the agent cannot override it. Every PR-producing workflow here sets
  `draft: false` deliberately.
- **`create-pull-request` `max` tops out at 10** (schema maximum).
- **Threat detection** runs on every workflow with safe outputs. A workflow
  whose job is fetching web pages and opening PRs will be false-flagged as
  prompt injection unless `safe-outputs.threat-detection.prompt` tells the
  detector that this is the intended design.
- **Never trust an agent's URLs.** A run once proposed a GitHub repository
  that has never existed, with fabricated file-level evidence. Discovery
  prompts must gate on "you opened and verified it this run".
- **Pre-compute in `steps:`, hand the agent small slices.** The agent's
  conversation carries whatever it reads on every turn; a 40 KB scan file
  is what a run actually costs.
- **`gh pr list` (GraphQL) has 500ed repeatedly from the workflow token on
  this repo; the REST `pulls` endpoint is fine.** Use REST with retries in
  pre-steps.
- **A run must fail loudly or produce its stated output.** Green-with-nothing
  is the worst outcome. Workflows here name their exact success states.

## Secrets

- `GH_AW_PROJECT_GITHUB_TOKEN` (org secret, all repos) is the **only PAT**.
  Anything needing more than the repo-scoped `GITHUB_TOKEN` — project boards,
  cross-repo pushes, creating forks, report commits — uses it.
- `GITHUB_TOKEN` is the built-in per-run token, scoped to this repo. Fine for
  same-repo PRs/issues and reading public org repos; useless for org writes.
- `COPILOT_GITHUB_TOKEN` (org secret) powers model inference.
- Agent-job cross-repo work: `tools.github.github-token`. Safe outputs:
  per-handler `github-token`. Post-step pushes: their own `env`.

## README.md

Keep the workflow table in `README.md` up to date when workflows are added,
renamed, or change behaviour. **Never add anything else to it** — no prose
sections, no guides, no status dashboards. The table is all there is.
