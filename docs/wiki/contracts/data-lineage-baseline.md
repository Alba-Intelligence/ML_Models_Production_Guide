---
updated: 2026-05-09
summary: Minimum provenance and lineage requirements for datasets, schemas, and transformations.
read_when:
  - You are defining data inputs or transformations
  - You are deciding what lineage metadata is mandatory
sources:
  - index.md
  - ../architecture/reference-architecture-skeleton.md
---

# Data lineage baseline

## Purpose

Define the minimum lineage information required for datasets and transformations so that training and inference can be reconstructed and audited.

## Applies to

- raw datasets
- curated datasets
- feature/transformation outputs
- training inputs
- batch inference inputs
- batch inference outputs where derived data is produced

## Every dataset version must define

- dataset identifier
- dataset version identifier
- source origin(s)
- acquisition/extraction timestamp or window
- schema version
- storage location
- producing code/process reference
- data owner or owning domain
- downstream intended uses if known

## Every transformation spec must define

- transformation identifier
- transformation version identifier
- source dataset version(s)
- code reference
- input schema version(s)
- output schema version
- execution environment reference if relevant
- output location or artifact reference

## Mandatory rules

- Training and inference should reference **versioned inputs**, not vague dataset names.
- Schema changes must be visible and versioned.
- Derived datasets must preserve backlinks to upstream inputs and transformation logic.
- A model artifact must be traceable to the dataset version(s) and transformation version(s) used to produce it.
- Batch outputs must be attributable to their model version and input batch identity.

## Minimum lineage graph edges

The reference should make it possible to traverse at least these links:

- source system -> dataset version
- dataset version -> transformation version
- transformation version -> training run
- training run -> model artifact
- model artifact -> model version
- model version -> deployment or inference run
- input batch -> batch inference run -> output batch

## Required metadata in docs/examples

Each relevant page or example should declare:

- what the authoritative data version identifier is
- what schema assumptions exist
- where transformation lineage is recorded
- how downstream consumers recover provenance

## Relationship to other contracts

- feeds [experiment-traceability-baseline.md](experiment-traceability-baseline.md)
- feeds [model-artifact-baseline.md](model-artifact-baseline.md)
- feeds [prediction-logging-baseline.md](prediction-logging-baseline.md)

## Open decisions

- exact dataset versioning format
- exact schema registry or schema-management approach
- exact lineage storage/query surface for operators and assistants
