---
updated: 2026-05-09
summary: Minimum metadata required to make experiments and training runs reproducible and comparable.
read_when:
  - You are defining experiment tracking or training workflows
  - You are deciding what MLflow metadata must be mandatory
sources:
  - index.md
  - ../architecture/reference-architecture-skeleton.md
---

# Experiment traceability baseline

## Purpose

Define the minimum metadata required for any experiment or training run so that results can be compared, reproduced, and audited.

## Applies to

- local training runs
- distributed training runs
- evaluation runs tied to training
- hyperparameter sweeps where each run is material

## Every experiment/training run must define

- run identifier
- code revision
- container/environment revision
- dataset version(s)
- transformation version(s)
- hyperparameters/config
- compute context
- framework/library versions relevant to reproducibility
- start/end timestamps
- produced artifacts
- evaluation outputs
- MLflow experiment/run linkage

## Compute context must include

- local vs remote
- GPU type/count where relevant
- distributed topology if distributed
- provider/environment identity
- major runtime constraints that affect reproducibility

## Mandatory rules

- No promoted model artifact should exist without a traceable originating run.
- Training runs must reference explicit dataset and transformation versions.
- Reproducibility context must include both **code** and **environment/container** identity.
- Distributed runs must capture enough metadata to distinguish topology and resource shape from single-node runs.
- Evaluation metrics used for promotion must be traceable to the run and data slice that produced them.

## Required MLflow posture

MLflow is the canonical experiment-tracking layer in scope.

At minimum, the reference should treat the following as mandatory in MLflow or an equivalent attached metadata model:

- parameters/config
- metrics
- artifacts
- tags for lineage and environment
- links to model artifacts and versions

## Relationship to other contracts

- consumes [data-lineage-baseline.md](data-lineage-baseline.md)
- feeds [model-artifact-baseline.md](model-artifact-baseline.md)
- feeds [deployment-baseline.md](deployment-baseline.md)
- informs [cost-attribution-baseline.md](cost-attribution-baseline.md)

## Assistant implications

Assistant-facing MLflow tooling should be able to answer:

- what changed between two runs?
- what data and code produced this model?
- which runs are missing required traceability fields?
- which run regression is most likely responsible for a performance shift?

## Open decisions

- exact mandatory MLflow tag schema
- exact representation of environment/container revision
- exact handling of large sweep-style experiment groups
