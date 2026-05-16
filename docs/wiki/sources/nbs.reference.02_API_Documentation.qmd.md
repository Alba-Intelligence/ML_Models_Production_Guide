---
updated: 2026-05-16
summary: Compact API reference for notebook execution, orchestration, governance, and MLflow-linked visibility.
read_when:
  - You need the contract vocabulary for execution and policy surfaces
  - You want the short API map instead of the longer reference notebook
source_file: ../../nbs/reference/02_API_Documentation.qmd
sources:
  - ../architecture/webui-backend-contract.md
  - ../sources/ml_deploy.webui_contracts.py.md
  - ../sources/ml_deploy.execution_backends.py.md
  - ../sources/ml_deploy.governance_gates.py.md
---

# Source summary: nbs/reference/02_API_Documentation.qmd

## Role

Compact API map for the stack's core contract families:

- notebook execution requests and run visibility
- execution orchestration and backend routing
- notebook intake and approval gates
- governance transition decisions
- MLflow parity and serving visibility helpers

## Main points

- `NotebookExecutionRequest` is the normalized request shape.
- `RunVisibility` is the UI-facing run summary.
- `ExecutionOrchestrator` routes normalized requests to the correct backend.
- Local, Slurm, and Kubernetes adapters only map or submit; they do not invent policy.
- Governance gates remain explicit and auditable.
- The page intentionally summarizes the contract surface and points to the implementation modules for specifics.

## Use when

- you need the small API vocabulary for the stack
- you are wiring execution or policy paths
- you want the reference contract summary without the longer generated example set
