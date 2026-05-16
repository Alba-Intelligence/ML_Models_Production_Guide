---
title: "Advanced Scenarios"
---

# Advanced Scenarios

This tutorial describes how the reference stack extends beyond the local slice.

It stays intentionally compact: the goal is to map scenarios to the architecture, not to repeat implementation detail.

## Scenario 1: local scale-out

Local development is the safest place to iterate.

Use it when you need to:

- validate notebook revisions
- exercise the EX-01 → EX-03 slice
- test traceability and logging
- refine the serving contract

The local path should remain the quickest feedback loop.

### What to preserve

- immutable notebook revisions
- request provenance
- MLflow linkage
- local prediction logs
- reproducible environment setup

## Scenario 2: distributed training

Distributed training introduces remote execution and coordination concerns.

The reference stack expects:

- a dedicated distributed training topology
- a backend-specific submission layer
- stronger resource declaration
- explicit node or job trust assumptions
- recoverable job metadata

### What changes

- the execution target becomes remote
- the submission payload becomes scheduler-specific
- the audit trail must include the external scheduler identity

### What does not change

- notebook revisions remain immutable
- training metadata remains explicit
- output artifacts still need versioning and lineage links

## Scenario 3: batch inference

Batch inference is for scheduled or event-driven workloads.

It should carry:

- input dataset version
- job identity
- output destination
- runtime provenance
- cost attribution metadata

The batch path should be treated as a controlled production workflow, not a casual script.

## Scenario 4: online inference

Online inference is the highest-sensitivity serving path in the reference stack.

The online path needs:

- authenticated request handling
- environment-scoped deployment rules
- prediction logging
- rollback or shutdown strategy
- monitoring hooks

The docs treat this as a contract-rich serving surface, not a framework choice.

## Scenario 5: environment promotion

Promotion is where governance becomes visible.

Before an artifact or environment moves upward, the system should know:

- what was approved
- who approved it
- which revision was approved
- what evidence supports the decision
- what rollback target exists

Promotion should never be detached from lineage.

## Scenario 6: security-sensitive operations

Any operation that mutates shared state needs stronger controls than ordinary notebook execution.

Examples include:

- approving a notebook revision
- promoting a model
- changing infra state
- modifying policy
- granting access

These actions should always be auditable and role-gated.

## Scenario 7: assistant-driven operations

Assistant tooling is useful for read-heavy workflows such as:

- finding runs
- checking current state
- summarizing logs
- comparing versions

Write-capable assistant actions should be rare and explicitly confirmed.

The default posture is read-first.

## Scenario 8: failure recovery

Real systems fail in predictable ways:

- missing artifact
- unavailable scheduler
- expired token
- rejected policy decision
- invalid notebook revision
- incomplete lineage

The reference stack should fail loudly and keep the reason visible.

## Scenario 9: cost-aware operations

Cost should be a first-class dimension on any non-trivial run.

A workload should ideally know:

- which environment it used
- which job type it was
- who owns it
- whether it is local, remote, or production

This is especially important for remote compute and long-running jobs.

## Scenario 10: docs as an operational aid

The documentation itself is part of the system.

Use the docs to answer:

- what exists
- how it is supposed to behave
- what contract is being enforced
- what the current gaps are

If the docs cannot answer those quickly, they are too large or too vague.

## Scenario 11: AWS-native services with Floci parity

For the biggest remaining gaps, prefer AWS-native services that Floci can emulate locally.

That usually means:

- OIDC at the edge for human auth
- IAM / STS / Secrets Manager for service identity and secrets
- S3 for artifacts and model packages
- PostgreSQL for MLflow backend state
- CloudWatch for logs, metrics, and alarms
- Terranix/OpenTofu for AWS resource generation and apply-time control
- MLflow remains the interim storage/traceability layer for metrics, logs, and run-linked outputs until a proper datalake is defined later

### Consequences on other subsystems

- **Security**: the Web UI and backend must carry identity context end-to-end.
- **Observability**: local and cloud metric/log names should stay aligned, and MLflow should remain the first stop for run visibility.
- **Artifacts**: model bundles and run records need stable object-store URLs.
- **Infrastructure**: generated cloud resources should have a local Floci analogue where possible.
- **Execution**: backends must assume environment-scoped credentials and artifact access.
- **Governance**: promotion and mutation paths stay approval-aware and auditable.
- **Data**: proper datalake design is deferred; the interim system of record stays MLflow-backed.

## Reading guidance for advanced work

When tackling a more advanced scenario, read in this order:

1. `nbs/tutorials/03_Concepts_and_Architecture.qmd`
2. `nbs/reference/01_Implementation_Patterns.qmd`
3. `nbs/reference/02_API_Documentation.qmd`
4. `nbs/reference/03_Security_Authorization_and_Policy.qmd`
5. the relevant wiki decision or gap page

## Practical summary

Advanced scenarios are variations on the same reference pattern:

- preserve immutable source
- preserve provenance
- preserve policy
- preserve traceability
- adapt the execution backend to the topology

If a scenario violates those invariants, it is not part of the reference stack.
