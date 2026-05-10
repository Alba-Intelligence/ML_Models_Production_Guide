---
updated: 2026-05-11
summary: Adds a standard end-of-task finalize script that exports nbdev code, renders docs, and runs tests.
read_when:
  - You need to ensure each task ends with publishable notebook documentation output
  - You want the canonical finalization command
sources:
  - ../../scripts/finalize-task.sh
  - ../../README.md
  - ../runbooks/jupyter-and-shell.md
---

# Revision: 2026-05-11 end-of-task docs finalization

## Trigger

The workflow needed a guaranteed, explicit publishable-doc step at the end of tasks.

## What changed

1. Added `scripts/finalize-task.sh` as a single command for:
   - nbdev export
   - nbdev docs render
   - unittest execution
2. Documented usage in `README.md`.
3. Documented the runbook step in `docs/wiki/runbooks/jupyter-and-shell.md`.
4. Marked heavy MLflow execution cells in `nbs/03_model_training.ipynb` as `#| eval: false` so docs rendering remains publishable and deterministic.

## Outcome

The repository now has a concrete, repeatable command for finishing tasks with publishable notebook documentation and passing tests.
