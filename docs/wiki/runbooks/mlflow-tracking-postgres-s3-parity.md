---
updated: 2026-05-12
summary: Runbook for MLflow tracking parity between local replica and production posture (PostgreSQL backend + S3-compatible artifacts).
read_when:
  - You need local/production parity for MLflow storage
  - You are wiring notebook execution flows to durable tracking storage
sources:
  - ../architecture/target-system.md
  - ../decisions/project-scope-and-constraints.md
  - ../sources/ml_deploy.mlflow_parity.py.md
---

# MLflow tracking parity runbook (PostgreSQL + S3)

## Purpose

Provide a single storage posture for both local replica and production-style flows:

- MLflow backend store on PostgreSQL
- MLflow artifacts on S3-compatible object storage (Floci locally, S3 in AWS)

## Local replica baseline

1. Generate stack configuration via `ml_deploy/mlflow_parity.py`:
   - `render_local_compose_config(...)`
   - `write_local_compose_file(...)`
2. Start the Floci AWS emulator, then local PostgreSQL.
3. Configure MLflow server:
   - `--backend-store-uri postgresql://...`
   - `--artifacts-destination s3://...`
4. Export runtime environment for artifact access:
   - `MLFLOW_S3_ENDPOINT_URL` (local Floci endpoint)
   - AWS-style credentials for Floci or S3
5. Point local notebook execution and vertical-slice code at the MLflow server URI.

## Production baseline

1. Use managed PostgreSQL (for example RDS) for backend metadata.
2. Use AWS S3 bucket(s) for artifacts.
3. Restrict MLflow server/service access with IAM and network policy controls.
4. Preserve identical run metadata contracts from local to production targets.

## Validation checklist

- Training runs persist metadata in PostgreSQL-backed tracking.
- Artifacts are written to object storage, not local filesystem.
- MLflow run links resolve correctly in Web UI run summaries.
- Model/deployment/prediction records preserve traceability continuity.

## Notes

- Local MLflow file-store mode is acceptable only for quick tests; parity work should use PostgreSQL + S3-compatible storage.
- Terraform provisioning should be initiated from Python workflows (`python-terraform`) and not by ad-hoc hand-written `.tf` expansion where avoidable.
