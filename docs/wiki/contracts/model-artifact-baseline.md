---
updated: 2026-05-09
summary: Minimum structure and metadata required for model artifacts and model versions.
read_when:
  - You are defining packaging or registry behavior
  - You are deciding what a promoted model must contain
sources:
  - index.md
  - ../architecture/reference-architecture-skeleton.md
---

# Model artifact baseline

## Purpose

Define what a model artifact must contain so it can move safely from training to batch or online inference.

## Applies to

- trained model artifacts
- packaged model bundles
- registry entries / model versions

## Every model artifact must define

- artifact identifier
- originating training run identifier
- framework and framework version
- serialization format
- expected input schema/version
- expected output schema/version
- evaluation summary
- intended serving modes (batch, online, both, or restricted)
- compatibility notes
- storage location

## Every model version must define

- model version identifier
- source artifact identifier
- promotion status/state
- approval/evaluation basis
- allowed environments
- rollback predecessor if applicable

## Mandatory rules

- A model artifact must be traceable back to exactly one originating training run or a clearly defined composite process.
- Packaging must not strip away the metadata needed for serving compatibility or auditability.
- Schema expectations must be explicit.
- Promotion state must be separate from raw artifact existence.
- A serving system must not have to guess whether an artifact is valid for batch, online, or both.

## Required compatibility questions

Before any artifact is consumed downstream, the reference should make it possible to answer:

- what run produced this artifact?
- what data and transformations underpin it?
- what input schema does it expect?
- what serving modes is it approved for?
- what evaluation evidence justified promotion?

## Relationship to other contracts

- consumes [experiment-traceability-baseline.md](experiment-traceability-baseline.md)
- feeds [deployment-baseline.md](deployment-baseline.md)
- feeds [prediction-logging-baseline.md](prediction-logging-baseline.md)

## Assistant implications

Assistant tooling should be able to answer:

- what model version is a given deployment serving?
- why was this version promoted?
- what artifact changed between two model versions?
- is a given artifact missing required schema or evaluation metadata?

## Open decisions

- exact packaging format and directory structure
- exact registry workflow in MLflow vs adjacent systems
- exact promotion-state model
