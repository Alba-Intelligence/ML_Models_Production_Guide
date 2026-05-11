---
updated: 2026-05-11
summary: Implemented next-step architecture obligations across spec trigger reachability, shell-sync semantics, runtime orchestration routing, MLflow runtime storage configuration, and Docker-first workflows.
read_when:
  - You need the full implementation pass after "Do everything"
  - You are validating completion of the previously identified next implementation steps
sources:
  - ../../specs/ml-deploy-reference-repo.allium
  - ../../ml_deploy/execution_backends.py
  - ../../ml_deploy/mlflow_parity.py
  - ../../docker-compose.dev.yml
  - ../../Dockerfile
  - ../../tests/test_execution_backends.py
  - ../../tests/test_mlflow_parity.py
---

# Revision: 2026-05-11 spec-runtime-docker implementation

## Trigger

Requested implementation of all outstanding next steps in one pass.

## What changed

1. Updated `specs/ml-deploy-reference-repo.allium`:
   - added surface declarations that provide key triggers so `unreachableTrigger` diagnostics are removed.
   - split shell-entry behavior into conditional sync vs no-sync rules to match accepted semantics.
2. Extended backend runtime path in `ml_deploy/execution_backends.py`:
   - added `ExecutionOrchestrator` and `BackendSubmission` for local/slurm/kubernetes routing.
   - local path now defaults tracking URI from resolved MLflow runtime config when not passed explicitly.
3. Extended MLflow storage configuration in `ml_deploy/mlflow_parity.py`:
   - added `MlflowStorageConfig`.
   - added env-driven config resolution and runtime env generation helpers for PostgreSQL+S3 posture.
4. Implemented Docker-first reproducible workflow artifacts:
   - `Dockerfile`
   - `docker-compose.dev.yml`
   - `.dockerignore`
5. Added and updated tests:
   - execution orchestrator routing coverage in `tests/test_execution_backends.py`.
   - runtime MLflow storage config coverage in `tests/test_mlflow_parity.py`.

## Result

The previously identified immediate implementation backlog is now concretely represented in code/spec/docs with passing tests and an explicit Docker-first runnable path.
