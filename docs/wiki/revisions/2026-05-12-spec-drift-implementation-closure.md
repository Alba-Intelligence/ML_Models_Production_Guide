# 2026-05-12 Spec Drift Implementation Closure

## Overview

Implemented the code-side divergences identified in the weed audit and classified as code bugs, plus executable governance gating support.

## Implemented gaps

### 1. Terranix-driven Docker artifact generation

- Added `nix/terranix/docker-artifacts.nix` as Docker artifact source-of-truth.
- Added `scripts/generate-docker-artifacts.py` to materialize:
  - `Dockerfile`
  - `docker-compose.dev.yml`
  - `docker-compose.aws-emulator.yml`
  - `docker-compose.cloud.yml`
- Updated `scripts/finalize-task.sh` and CI to invoke generation when `nix` is available.

### 2. Cloud Traefik + MLflow security wiring

- Added generated `docker-compose.cloud.yml` with Traefik in front of MLflow.
- Added cloud compose renderer in `ml_deploy/mlflow_parity.py`.
- Added `MLFLOW_CREATE_MODEL_VERSION_SOURCE_VALIDATION_REGEX` to cloud-profile config paths.

### 3. MLflow source validation env handling

- Extended `MlflowStorageConfig` with `model_version_source_validation_regex`.
- Added propagation in `build_mlflow_runtime_env_from_storage`.
- Added `build_cloud_mlflow_runtime_env` to enforce required regex in cloud profile.

### 4. Promotion pipeline gates

- Extended `ml_deploy/vertical_slice.py` model-version record to include gate fields.
- Added `promote_model_artifact(...)` with DEV->UAT->REGRESSION->PROD checks matching spec gate intent.
- Added tests in `tests/test_promotion_pipeline.py`.

### 5. Shell sync branching behavior

- Updated `flake.nix` shell hook to sync on explicit request (`UV_SYNC_REQUESTED=1`) or drift (`uv sync --check`).
- Mirrored same behavior in `devenv.nix`.

### 6. Spec-first implementation gating (previously aspirational)

- Added executable governance gate helpers in `ml_deploy/governance_gates.py`.
- Added tests in `tests/test_governance_gates.py`.

## Additional validation/tests

- Added `tests/test_docker_artifacts_generation.py` for generated artifact markers and cloud security wiring.
- Updated `tests/test_mlflow_parity.py` for cloud compose/runtime-env expectations.

## Notes

- `nbs/06_vertical_slice.qmd`, `nbs/07_mlflow_parity.qmd`, and `nbs/17_governance_gates.qmd` were updated to keep notebook-source narratives aligned with implementation changes.
