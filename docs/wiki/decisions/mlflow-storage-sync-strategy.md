---
updated: 2026-05-16
summary: Decision record for the MLflow storage synchronization strategy between local and cloud environments.
read_when:
  - You are configuring MLflow storage infrastructure
  - You need to understand local-cloud model synchronization requirements
  - You are evaluating storage sync strategies for MLflow artifacts
sources:
  - ../../specs/ml-deploy-reference-repo.allium
  - ../decisions/mlflow-postgres-s3-contract.md
  - ../decisions/nix-containerization-boundary.md
---

# MLflow Storage Sync Strategy (Local-Cloud)

## Purpose

Define how MLflow tracking data and artifacts should behave across local development and cloud environments.

This decision exists to preserve three things at once:

- local developer speed
- cloud parity
- immutable provenance

## Decision

Use a **hybrid parity model**:

- local development uses a local MLflow backend and local artifact storage
- cloud environments use the approved production backend and artifact store
- synchronization is controlled and explicit, not opportunistic
- artifact identity must remain tied to notebook revision / run identity

In other words: keep local and cloud stores separate, but make their semantics match.

## Why this fits the stack

The repository is built around:

- immutable notebook revisions
- explicit execution requests
- MLflow-linked lineage
- local emulation that mirrors production structure
- environment-aware promotion gates

A loose sync layer is acceptable only if it does not weaken those invariants.

## Reference behavior

### Local development

Local development should optimize for:

- fast iteration
- easy inspection
- low-friction run creation
- offline or partially offline work

Local state may live in local filesystem-backed artifacts and a local MLflow backend.

### Cloud environments

Cloud environments should optimize for:

- durable history
- shared access
- production-grade durability
- policy-controlled access

Cloud state should use the approved backend and artifact store for the deployment profile.

## Synchronization rules

### 1. Identity first

Every synced artifact or run record should retain a stable identity.
That identity should include:

- notebook revision or code revision
- run ID
- artifact version
- environment/profile

### 2. No silent overwrite

If local and cloud disagree, the system must not silently pick a winner.
It should either:

- reject the sync
- create a new versioned record
- require explicit operator action

### 3. Immutable provenance

Sync should never detach an artifact from its original run or revision.
The sync process may copy or replicate, but it should not rewrite history.

### 4. Local speed wins locally

Development workflows should stay fast.
Any cloud synchronization that slows the local workflow materially should be deferred or made asynchronous.

## Recommended storage shape

### Local profile

- local MLflow backend store
- local artifact root
- local run visibility links

### Cloud profile

- PostgreSQL backend store
- S3-compatible artifact root
- proxy-enforced access
- policy-aware run visibility

## Conflict handling

Conflicts can happen when the same logical object is modified in both environments.

Recommended handling:

- treat run outputs as append-only
- treat model versions as immutable
- allow only new version creation, not in-place mutation
- log any mismatch for later review

## Operational posture

A sync service, if used, should be:

- explicit
- narrow in scope
- auditable
- version-aware
- unable to bypass policy checks

It should not be a hidden background process that rewrites user-visible history.

## What is out of scope

This decision does **not** require:

- a bidirectional always-on replication protocol
- automatic conflict resolution across arbitrary histories
- cross-environment mutable model state

Those would be too heavy for the reference stack.

## Contract links

- `docs/wiki/contracts/security-baseline.md`
- `docs/wiki/contracts/model-artifact-baseline.md`
- `docs/wiki/contracts/deployment-baseline.md`
- `docs/wiki/decisions/mlflow-postgres-s3-contract.md`
- `docs/wiki/decisions/aws-floci-aligned-implementation-path.md`
- `docs/wiki/decisions/nix-containerization-boundary.md`

## Summary

Keep local and cloud MLflow storage separate, but keep the semantics aligned.
Sync should preserve identity, immutability, and traceability.
