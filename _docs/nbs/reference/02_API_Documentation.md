# API Documentation

Compact rendered summary for `nbs/reference/02_API_Documentation.qmd`.

## Scope

- notebook execution requests and run visibility
- execution orchestration and backend routing
- notebook intake and approval gates
- governance transition decisions
- MLflow parity and serving visibility helpers

## Key points

- `NotebookExecutionRequest` is the normalized request shape.
- `RunVisibility` is the UI-facing run summary.
- `ExecutionOrchestrator` routes normalized requests to the correct backend.
- Local, Slurm, and Kubernetes adapters map or submit; they do not invent policy.

## See also

- `nbs/reference/02_API_Documentation.qmd`
- `docs/wiki/architecture/webui-backend-contract.md`
- `docs/wiki/sources/nbs.reference.02_API_Documentation.qmd.md`
