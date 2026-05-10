---
updated: 2026-05-10
summary: Reference topology for Docker-based local development, local FastAPI serving, and single-node GPU training.
read_when:
  - You are defining the local developer loop
  - You want the least operationally heavy reference topology
sources:
  - index.md
  - ../domains/training-domain.md
  - ../domains/serving-domain.md
  - ../domains/infrastructure-domain.md
  - ../contracts/index.md
---

# Local development and single-node training

## Purpose

Provide the lowest-friction reference topology for:

- local development
- single-node GPU experimentation
- local FastAPI serving
- local documentation preview/serving

## Primary domains involved

- training
- serving
- infrastructure
- artifact
- data

## Primary contracts stressed

- security baseline
- data lineage baseline
- experiment traceability baseline
- model artifact baseline

## Core assumptions

- Docker is the canonical reproducible environment
- Nix may help developers locally, but Docker is the standard reference artifact
- MLflow is reachable for experiment tracking
- the developer may have access to a local GPU or attached single-node GPU environment

## What this topology is for

- fast local iteration
- validating experiment metadata shape
- validating packaging and local serving behavior
- validating docs-delivery and example-navigation behavior if FastAPI is used for docs

## What this topology is not for

- final production inference
- distributed training scale testing
- full AWS production pattern validation

## Key risks and boundaries

- local convenience must not erase required metadata or security assumptions
- local serving must not be confused with production serving
- local docs delivery must remain logically separate from model-serving behavior even if both use FastAPI

## Reference flow specification

### Control flow

1. Start Docker-based local stack and required services.
2. Run notebook-driven experiment and emit MLflow run metadata.
3. Package a model artifact with required schema/traceability metadata.
4. Launch local FastAPI serving against the packaged artifact.
5. Execute smoke predictions and verify prediction logging links to model version.

### Data and artifact flow

- versioned local dataset -> transformation output -> training run -> model artifact -> local serving endpoint -> prediction logs

### Contract checkpoints

- data lineage validated at dataset/transformation handoff
- experiment traceability validated at MLflow run completion
- model artifact baseline validated before local serving
- prediction logging baseline validated during smoke prediction path

## Assistant implications

High-value assistant tasks here include:

- local experiment comparison
- local docs navigation and architecture question-answering
- artifact completeness checks before anything is moved to a more production-like topology

## Open decisions

- exact local Docker composition/workflow
- exact local MLflow accessibility pattern
- exact local GPU assumptions to standardize in examples
