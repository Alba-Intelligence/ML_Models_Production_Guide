---
updated: 2026-05-10
summary: Definition of the first architecture-conforming vertical slice from notebook training to local serving.
read_when:
  - You are starting the first end-to-end implementation-aligned write-up
  - You need concrete input/output and success criteria for initial architecture proof
sources:
  - example-matrix.md
  - reference-architecture-skeleton.md
  - ../contracts/index.md
  - ../topologies/local-development-and-single-node-training.md
---

# First vertical slice

## Purpose

Define the smallest end-to-end slice that proves the architecture is executable without broadening scope prematurely.

## Slice boundary

This slice composes:

1. EX-01 (local training + MLflow traceability)
2. EX-02 (artifact packaging + version registration)
3. EX-03 (local FastAPI serving + prediction logging)

It stays entirely inside the local-development topology and does not include distributed training or production AWS rollout.

## Inputs

- versioned local dataset identifier (or equivalent deterministic dataset snapshot id)
- transformation spec/version id
- training config/hyperparameters
- local runtime/container identity
- model serving request schema version

## Outputs

- MLflow run with required traceability metadata
- packaged model artifact with schema and compatibility metadata
- model version record referencing the artifact
- local serving deployment record (local scope)
- prediction logs linked to model version and request identifiers

## Contract obligations

The slice must satisfy at minimum:

- data lineage baseline
- experiment traceability baseline
- model artifact baseline
- deployment baseline (local-form)
- prediction logging baseline

## Success criteria

The slice is considered complete when all of the following are true:

1. A reviewer can trace a prediction back to model version, training run, and dataset/transformation versions.
2. Artifact metadata is sufficient to decide serving compatibility without code spelunking.
3. Local serving can be started from packaged artifact metadata rather than hidden notebook state.
4. Logs contain enough context to diagnose request-level issues in local testing.
5. The workflow is repeatable with changed hyperparameters while preserving full traceability.

## Explicit non-goals

- distributed compute on Lambda.ai
- production-grade rollout/canary policy
- full cross-provider cost analytics
- docs-delivery companion service behavior

## Handoff notes for later slices

- EX-04 extends this slice into distributed training while preserving traceability continuity.
- EX-05 and EX-06 reuse artifact and deployment interfaces in batch and online topologies.
