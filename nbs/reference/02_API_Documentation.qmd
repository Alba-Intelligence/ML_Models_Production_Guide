---
title: "API Documentation"
---

# API Documentation

This page documents the compact API surface used by the ML Deploy reference stack. It is intentionally higher-level than the implementation modules and stays aligned with the current contract-first posture.

Primary references:

- `ml_deploy/webui_contracts.py`
- `ml_deploy/execution_backends.py`
- `ml_deploy/governance_gates.py`
- `ml_deploy/notebook_intake.py`

## API families

The stack's APIs fall into six families:

1. notebook execution requests and run visibility
2. execution orchestration and backend routing
3. notebook intake and approval gates
4. governance transition decisions
5. MLflow parity and storage wiring
6. serving and prediction visibility helpers

## 1. Notebook execution contracts

### `NotebookRevision`

Immutable reference to the source notebook revision.

Fields usually include:

- `commit`
- `tag`
- `approved_ref`

The revision is the primary provenance anchor for notebook-triggered execution.

### `NotebookExecutionRequest`

Normalized request shape for notebook execution.

Conceptually includes:

- notebook identity and revision
- target environment
- parameter payload
- resource requirements
- request identity and timestamp
- optional timeout or priority

The request is validated before any execution path is selected.

### `RunVisibility`

Human-facing view of a submitted or completed run.

The summary usually includes:

- run status
- MLflow deep link
- environment or topology
- execution timestamps
- traceability metadata

### `summarize_run_for_webui(...)`

Maps execution metadata into the run-visibility model.

The function should normalize backend-specific statuses into a consistent UI-facing view.

## 2. Execution orchestration

### `ExecutionOrchestrator`

Routes a normalized execution request to the correct backend.

Typical behavior:

- validate the request
- select a backend by environment and resource requirements
- submit the backend payload
- return submitted/completed visibility
- preserve provenance and audit context

### `LocalExecutionAdapter`

Runs the local slice and returns a run summary.

Expected responsibilities:

- normalize input
- invoke the local runner
- link output artifacts to MLflow
- return the visibility model

### `map_to_slurm_job_spec(...)`

Transforms the normalized job spec into a Slurm-compatible submission payload.

### `map_to_kubernetes_job_spec(...)`

Transforms the normalized job spec into a Kubernetes Job manifest.

These mapping functions do not execute jobs; they only produce submission payloads.

## 3. Notebook intake

### `NotebookIntakeRequest`

Describes a notebook revision and the associated approval context.

Typical fields include:

- notebook path
- revision reference
- intake mode
- source validation metadata
- approval state

### `validate_notebook_revision(...)`

Checks that a notebook revision is suitable for execution.

The validation layer should reject:

- missing revision identity
- unsafe or mutable notebook references
- unsupported notebook structure
- missing approval markers where required

## 4. Governance gates

### `RepositoryGovernanceState`

Tracks whether the repository is still in spec-first mode or already in implementation-enabled mode.

### `GovernanceDecision`

Represents a decision with:

- allowed or blocked result
- operation kind
- reason string
- resulting state

### `request_implementation_transition(...)`

Handles the transition from specification-first to implementation-enabled.

The decision is based on:

- explicit user confirmation
- spec-quality gate state
- current repository phase

The transition should be auditable and deterministic.

## 5. MLflow parity and storage

### `resolve_mlflow_storage_config(...)`

Returns the MLflow storage profile for the selected environment.

This is where the local/cloud parity contract is encoded.

### `build_mlflow_run_url(...)`

Constructs a stable MLflow run deep link for operators and UI surfaces.

## 6. Serving and prediction visibility

### `LocalModelServing`

The local slice uses a lightweight serving helper rather than a full serving framework.

### `PredictionLogger`

Writes prediction records with enough metadata to support later investigation.

### `PredictionRequest` / `PredictionResponse`

These remain deliberately small:

- request: input rows plus optional version or request metadata
- response: predictions plus version and timestamp

## Error semantics

The API surface is intentionally strict.

Typical fail-fast conditions:

- missing revision identity
- invalid notebook structure
- unsupported environment
- missing approval
- unknown run ID
- unavailable backend
- missing traceability metadata

The intent is to prevent silent ambiguity.

## Response shape rules

Every response that can be consumed by an operator should try to include:

- a stable identity
- a status or decision
- a human-readable reason
- a trace link where applicable

For run-oriented APIs, that usually means an MLflow deep link.

## Authorization context

This repository treats auth as a separate concern, but the API layer must still receive the context it needs to enforce policy.

Policy-relevant inputs commonly include:

- principal identity
- role or capability set
- notebook revision
- target environment
- request provenance
- approval status

See `nbs/reference/03_Security_Authorization_and_Policy.qmd` for the canonical reference posture.

## Example usage pattern

A typical notebook-triggering flow looks like this:

```python
request = NotebookExecutionRequest(...)
validated = validate_notebook_revision(request)
result = orchestrator.submit(validated)
summary = summarize_run_for_webui(result.metadata)
```

That sequence is the shape every execution UI or backend should follow.

## What this page is not

This page is not a full implementation spec.
It intentionally omits the lower-level details that belong in code and in the other reference docs.

Use this page when you need the stable contract vocabulary, not the implementation mechanics.
