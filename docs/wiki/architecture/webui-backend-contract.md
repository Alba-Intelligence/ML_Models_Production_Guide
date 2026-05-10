---
updated: 2026-05-11
summary: Thin backend contract for notebook execution requests and MLflow-first run visibility in the Web UI.
read_when:
  - You are implementing Web UI backend APIs for notebook runs
  - You need the accepted request/response schema before wiring Slurm or Kubernetes adapters
sources:
  - notebook-repository-web-ui.md
  - ../decisions/notebook-intake-validation-and-approval.md
  - ../sources/ml_deploy.webui_contracts.py.md
  - ../sources/ml_deploy.execution_backends.py.md
  - ../sources/ml_deploy.notebook_intake.py.md
---

# Web UI backend contract

## Purpose

Define the minimal backend contract that lets the Web UI trigger immutable notebook executions and show run status through MLflow deep links.

## Inbound request contract

`NotebookExecutionRequest` includes:

- immutable notebook reference (`repository`, `notebook_path`, `revision`, `revision_kind`)
- execution target (`local-replica`, `lambda-slurm`, `aws-kubernetes`)
- requester identity (`requested_by`)
- config profile and arbitrary runtime parameters
- request metadata (`request_id`, `requested_at`)

Contract rules:

1. Notebook execution source must be immutable (`commit`, `tag`, or `approved-ref`).
2. Mutable in-UI working copies are never valid execution sources.
3. A request must be defaulted with a generated `request_id` before conversion to job spec.

## Backend job-spec output

`as_job_spec()` produces the normalized execution payload:

- `request_id`, `requested_at`, `requested_by`
- `target`, `config_profile`
- immutable `notebook` reference block
- runtime `parameters`

This payload is the adapter input for local runner, Slurm submission, and Kubernetes job creation.

## Outbound run-visibility contract

`RunVisibility` includes:

- `run_id`
- normalized status (`queued`, `running`, `finished`, `failed`, `canceled`, `unknown`)
- start/finish timestamps
- optional `model_version`
- MLflow deep link (`mlflow_run_url`)

`summarize_run_for_webui(...)` is the baseline mapper from backend run metadata into this Web UI view model.

## MLflow-first monitoring behavior

- The Web UI must always expose a direct MLflow run link for each run summary.
- Deep diagnosis starts in MLflow; secondary observability/cost tools are follow-on pivots.

## Implementation anchor

- Runtime contract module: `ml_deploy/webui_contracts.py`
- Backend adapter module: `ml_deploy/execution_backends.py`
- Intake gate module: `ml_deploy/notebook_intake.py`
- Behavior tests: `tests/test_webui_contracts.py`
- Adapter tests: `tests/test_execution_backends.py`
- Intake tests: `tests/test_notebook_intake.py`
