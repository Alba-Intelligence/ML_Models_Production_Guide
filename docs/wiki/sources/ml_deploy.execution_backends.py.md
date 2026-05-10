---
updated: 2026-05-11
summary: Synthesized summary of backend execution adapters mapping Web UI job specs to local, Slurm, and Kubernetes payloads.
read_when:
  - You are implementing notebook execution backends
  - You need mapping logic from normalized Web UI specs into platform-specific submissions
source_file: ../../ml_deploy/execution_backends.py
---

# Source summary: ml_deploy/execution_backends.py

## Role

Implements execution adapter behavior for notebook runs:

- local execution adapter that runs the first vertical slice and returns `RunVisibility`
- Slurm payload mapping
- Kubernetes Job payload mapping

## Main components

- `LocalExecutionAdapter.submit(...)` — normalizes request, executes local runner, and emits MLflow-linked run summary.
- `map_to_slurm_job_spec(...)` — maps normalized job spec to Slurm submission fields.
- `map_to_kubernetes_job_spec(...)` — maps normalized job spec to Kubernetes Job manifest.

## Practical implication

The project now has a concrete translation layer between contract-level Web UI requests and runtime backend payloads.
