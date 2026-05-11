---
updated: 2026-05-11
summary: Added executable local-emulation parity compose helpers covering AWS API, Kubernetes, and Slurm compute-plane services.
---

# Revision: local emulation parity helpers

## What changed

- Extended MLflow parity helper code with:
  - `LocalInfrastructureParityConfig`
  - `render_local_infra_compose_config`
  - `render_full_local_emulation_compose_config`
- Added tests asserting local emulation compute-plane service coverage and merged full-stack coverage.

## Why

This closes part of the previously identified spec-code drift under `RequireLocalEmulationParity` by making compute-plane emulation explicit in executable helper code, rather than only in standalone compose files/wiki text.

## Touched files

- `nbs/07_mlflow_parity.qmd`
- `ml_deploy/mlflow_parity.py`
- `tests/test_mlflow_parity.py`
- `docs/wiki/current-state.md`
- `docs/wiki/sources/ml_deploy.mlflow_parity.py.md`
- `docs/wiki/sources/nbs.07_mlflow_parity.qmd.md`
- `docs/wiki/log.md`
