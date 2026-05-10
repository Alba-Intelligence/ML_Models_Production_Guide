# ML Deploy Reference

Notebook-first reference project for ML deployment architecture and implementation patterns.

Built with [nbdev 3](https://nbdev.fast.ai/).

## Start here (newcomers)

If you are opening this repo for the first time, use this order:

1. Read the current project snapshot: `docs/wiki/current-state.md`
2. Read the target architecture: `docs/wiki/architecture/target-system.md`
3. Read active constraints/decisions: `docs/wiki/decisions/project-scope-and-constraints.md`
4. Open notebook sources in `nbs/` (these are the source of truth)
5. Use generated modules in `ml_deploy/` only as exports from notebooks

## What this repo currently is

- A **wiki + nbdev-driven reference repo**, not a finished production system.
- Core examples already implemented:
  - vertical slice: `nbs/06_vertical_slice.ipynb`
  - Web UI contracts: `nbs/05_webui_contracts.ipynb`
  - runtime helper notebooks: `nbs/07` to `nbs/10`
- Includes tests for implemented helpers under `tests/`.

## Repository map

- `nbs/` — notebook sources (edit here first)
- `ml_deploy/` — auto-exported Python modules (do not hand-edit)
- `tests/` — unittest suite
- `docs/wiki/` — durable architecture memory and runbooks
- `scripts/finalize-task.sh` — canonical end-of-task command

## Local setup

```bash
git clone https://github.com/your-org/ml_deploy.git
cd ml_deploy
pip install -e .
```

## Daily workflow

1. Implement in notebooks under `nbs/`
2. Export and render docs and run tests at task end:

```bash
./scripts/finalize-task.sh
```

## Where to look next

- Architecture overview: `docs/wiki/index.md`
- Local runbook: `docs/wiki/runbooks/jupyter-and-shell.md`
- First executable slice definition: `docs/wiki/architecture/first-vertical-slice.md`
- Web UI backend contract: `docs/wiki/architecture/webui-backend-contract.md`
