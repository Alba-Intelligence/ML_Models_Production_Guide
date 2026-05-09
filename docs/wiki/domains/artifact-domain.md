---
updated: 2026-05-09
summary: Artifact domain responsibilities for packaging, registry, versioning, and promotion of trained models.
read_when:
  - You are defining what a trained model becomes after training
  - You are deciding where artifact concerns stop and deployment concerns begin
sources:
  - index.md
  - ../contracts/model-artifact-baseline.md
  - ../contracts/experiment-traceability-baseline.md
  - ../contracts/deployment-baseline.md
  - ../architecture/reference-architecture-skeleton.md
---

# Artifact domain

## Owns

- model packaging format
- artifact metadata completeness
- registry representation
- versioning states
- promotion states and evidence requirements
- serving compatibility declarations

## Does not own

- training execution
- live deployment routing
- network/infrastructure setup
- incident response operations

## Lifecycle coverage

Primary coverage:
- model packaging
- model registration and promotion

## Contracts consumed

- [../contracts/model-artifact-baseline.md](../contracts/model-artifact-baseline.md)
- [../contracts/experiment-traceability-baseline.md](../contracts/experiment-traceability-baseline.md)
- [../contracts/deployment-baseline.md](../contracts/deployment-baseline.md)

## Topology relevance

- Topology A: local artifact packaging/testing
- Topology B: distributed training outputs
- Topology C: batch artifact consumption
- Topology D: online deployment compatibility

## Key questions this domain must answer

- What makes an artifact complete?
- What is the difference between an artifact and a model version?
- What evidence is required before promotion?
- How does downstream serving know whether an artifact is approved for batch, online, or both?

## Assistant implications

Useful assistant capabilities here include:
- checking artifact completeness
- explaining promotion history
- answering which model version is attached to a deployment
- surfacing incompatible schema/serving-mode combinations

## Open decisions

- exact packaging layout
- exact registry workflow and states
- exact approval criteria for promotion
