---
title: "Core Concepts and Architecture"
---

# Core Concepts and Architecture

This tutorial gives the compact conceptual model for the ML Deploy platform.

It is meant to help you read the rest of the docs in the right order. The key idea is simple: the repository is organized around a **contract-based, specification-first ML deployment lifecycle**.

## The architectural spine

The platform is built around a small set of permanent ideas:

1. **Separation of concerns** — data, training, artifacts, serving, infrastructure, governance, and cost each have their own responsibilities.
2. **Contracts first** — the system defines the interfaces before it chases implementation detail.
3. **Immutability** — notebook revisions are fixed; execution configuration is external.
4. **Traceability** — every meaningful artifact must link back to provenance.
5. **Reproducibility** — local and cloud paths should be explainable and repeatable.
6. **Environment awareness** — local, distributed, batch, and online topologies are not interchangeable.

## Lifecycle view

The repository follows a practical ML lifecycle:

- data intake and preparation
- training and experiment tracking
- artifact packaging and versioning
- local serving and prediction logging
- distributed training and batch inference
- online inference and monitoring
- governance and cost attribution

That lifecycle is the backbone for the docs and the implementation slices.

## The core patterns

### EX-01: training with traceability

Training must record:

- data version
- feature revision
- hyperparameters
- metrics
- code revision
- environment metadata

The purpose is to make every run explainable later.

### EX-02: artifact bundling and versioning

A model artifact should never be just a blob.
It should carry:

- model weights or serialized estimator
- preprocessing state
- version identity
- training run reference
- deployment suitability metadata

### EX-03: local deployment and serving

Local serving exists to prove that a packaged model can be loaded and used with prediction logging.

The serving path must preserve:

- model version
- request identity
- input context
- output capture
- latency or execution metadata

## High-level architecture shape

The stack is easiest to understand as five layers:

- **Interface layer** — notebook repository and Web UI
- **Execution layer** — local, Slurm, and Kubernetes backends
- **Data/model layer** — MLflow, artifacts, prediction logging
- **Infrastructure layer** — Nix/Terranix/OpenTofu, cloud and local emulation
- **Governance layer** — auth, policy, approvals, cost controls

## What the docs are trying to protect

The docs repeatedly enforce three promises:

- notebooks remain immutable source of truth
- execution is always traceable
- privileges are always explicit

Those promises are the reason the repo has so many contracts and decision pages.

## How the topology pages fit

The reference topologies are not alternative stories; they are different deployment shapes for the same contract model:

- local development and single-node training
- distributed training on Lambda.ai
- batch inference on AWS
- online inference under production controls

Each topology consumes the same contracts but exercises them differently.

## How to read the rest of the docs

Use this tutorial when you need the big picture.

Then move to:

- `nbs/tutorials/04_End_to_End_Workflow.qmd` for the full slice
- `nbs/reference/01_Implementation_Patterns.qmd` for the slice mechanics
- `nbs/reference/02_API_Documentation.qmd` for contract shapes
- `nbs/reference/03_Security_Authorization_and_Policy.qmd` for roles and policy

## Practical takeaway

If a change does not preserve the lifecycle, contract, or traceability model, it probably does not fit the reference architecture.
