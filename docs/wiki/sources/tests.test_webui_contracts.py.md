---
updated: 2026-05-10
summary: Synthesized summary of tests covering Web UI contract validation and MLflow-link generation.
read_when:
  - You are changing notebook execution request validation
  - You are changing MLflow run-link behavior in the Web UI summary model
source_file: ../../tests/test_webui_contracts.py
---

# Source summary: tests/test_webui_contracts.py

## Role

Verifies the baseline Web UI backend contracts:

- immutable notebook request handling
- normalized execution job-spec output
- MLflow-first run summary deep-link behavior

## Coverage highlights

- MLflow base URL normalization and run-link output.
- Commit-reference validation for immutable notebook execution.
- Request defaulting (`request_id`) before job-spec creation.
- Run metadata mapping into status + MLflow link summaries.
