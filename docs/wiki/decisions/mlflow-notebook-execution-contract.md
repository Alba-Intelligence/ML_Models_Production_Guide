---
updated: 2026-05-16
summary: Decision record for notebook-triggered execution contracts and their relationship to MLflow-linked visibility.
read_when:
  - You are implementing notebook execution or run visibility
  - You need the canonical notebook request / approval / traceability rules
sources:
  - ../../specs/ml-deploy-reference-repo.allium
  - ../architecture/notebook-repository-web-ui.md
  - ../contracts/security-baseline.md
  - ../contracts/prediction-logging-baseline.md
---

# MLflow Notebook Execution Contract

## Purpose

Define how notebook-triggered execution should behave when viewed through the reference MLflow / Web UI lens.

## Decision

Notebook execution must be:

- based on an immutable notebook revision
- triggered by an explicit request
- linked to MLflow run visibility
- auditable
- approval-aware when the environment requires it

## Contract shape

A valid notebook execution request should carry:

- notebook identity
- notebook revision or approved ref
- target environment
- request identity
- request timestamp
- parameters / external configuration
- resource hints if needed
- approval context when required

A valid response should expose:

- run identity
- status
- MLflow deep link
- traceability metadata
- result or failure reason

## Why this matters

The notebook repository is not allowed to behave like an opaque job launcher.
It is a controlled execution surface that must preserve provenance.

## Required behavior

### Before submission

The system should verify:

- the notebook revision is immutable and acceptable
- the request has a stable identity
- the target environment is allowed
- the approval state is sufficient
- the policy context is available

### After submission

The system should record:

- the run identity
- the backend used
- the environment
- the notebook revision
- the MLflow run link
- the operator-facing visibility record

## MLflow relationship

MLflow provides the run history and artifact visibility, but it is not the whole contract.
The notebook execution contract must still define:

- what was requested
- who requested it
- what revision ran
- what environment ran it
- how the result is linked back to the request

## Local and remote topology behavior

The same request model should work across:

- local development
- distributed training
- batch inference
- online inference

The backend will differ, but the traceability expectations should not.

## Policy relationship

Execution is not just a technical decision.
It also depends on role and approval policy.

Typical checks include:

- can this principal execute notebooks here?
- is this revision approved?
- is this environment allowed?
- is the request within scope?

## Audit requirements

Every notebook-triggered mutation should be reconstructable from the logs.
At minimum, the audit trail should answer:

- who requested the run
- what revision ran
- where it ran
- what backend accepted it
- what MLflow run was created

## Practical consequence

This contract keeps the Web UI and backend honest:

- the UI requests runs
- the backend validates them
- the execution layer submits them
- MLflow exposes the history
- policy gates remain explicit

## Out of scope

This decision does **not** prescribe:

- the exact frontend framework
- the exact scheduler client
- the exact deployment technology for every topology

Those belong in topology-specific implementation docs.

## Related pages

- `docs/wiki/architecture/notebook-repository-web-ui.md`
- `docs/wiki/architecture/webui-backend-contract.md`
- `docs/wiki/contracts/security-baseline.md`
- `docs/wiki/contracts/prediction-logging-baseline.md`
- `docs/wiki/sources/ml_deploy.webui_contracts.py.md`

## Summary

Notebook execution must remain immutable, traceable, policy-aware, and MLflow-linked.
