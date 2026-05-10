---
updated: 2026-05-10
summary: Adds executable Web UI backend contracts plus wiki decisions/runbook updates for notebook intake gates and MLflow PostgreSQL+S3 parity.
read_when:
  - You need provenance for the first concrete Web UI contract implementation
  - You are implementing notebook execution adapters or MLflow storage parity flows
sources:
  - ../../ml_deploy/webui_contracts.py
  - ../../tests/test_webui_contracts.py
  - ../architecture/webui-backend-contract.md
  - ../decisions/notebook-intake-validation-and-approval.md
  - ../runbooks/mlflow-tracking-postgres-s3-parity.md
---

# Revision: 2026-05-10 Web UI contract and MLflow parity

## Trigger

After locking MLflow-first monitoring and immutable notebook intake defaults, the next step was to provide executable backend contracts and concrete runbook/decision artifacts.

## What changed

1. Added `ml_deploy/webui_contracts.py`:
   - immutable notebook revision contract
   - execution request -> normalized job-spec conversion
   - MLflow run-link helpers and run visibility summary mapping
2. Added `tests/test_webui_contracts.py` for contract behavior validation.
3. Added architecture page `architecture/webui-backend-contract.md` to pin request/response schema.
4. Added decision page `decisions/notebook-intake-validation-and-approval.md` to formalize intake gate model.
5. Added runbook `runbooks/mlflow-tracking-postgres-s3-parity.md` for local/production storage posture alignment.

## Outcome

The repository now has a concrete implementation and documentation baseline for Web UI backend execution contracts, plus explicit operational and governance guardrails for notebook intake and MLflow storage parity.
