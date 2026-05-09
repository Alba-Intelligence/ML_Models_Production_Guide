---
updated: 2026-05-09
summary: Training domain responsibilities for PyTorch execution, experiments, GPUs, and distributed training behavior.
read_when:
  - You are defining training flows or experiment logic
  - You are deciding where training concerns stop and artifact concerns begin
sources:
  - index.md
  - ../contracts/experiment-traceability-baseline.md
  - ../contracts/data-lineage-baseline.md
  - ../contracts/security-baseline.md
  - ../architecture/reference-architecture-skeleton.md
---

# Training domain

## Owns

- PyTorch model code
- training configuration
- GPU execution logic
- distributed training behavior
- evaluation hooks attached to training
- MLflow emission for experiment metadata

## Does not own

- model promotion policy
- deployment infrastructure
- serving runtime behavior
- cloud network design

## Lifecycle coverage

Primary coverage:
- experiment specification
- training execution
- evaluation and validation
- distributed training behavior

## Contracts consumed

- [../contracts/experiment-traceability-baseline.md](../contracts/experiment-traceability-baseline.md)
- [../contracts/data-lineage-baseline.md](../contracts/data-lineage-baseline.md)
- [../contracts/security-baseline.md](../contracts/security-baseline.md)
- [../contracts/cost-attribution-baseline.md](../contracts/cost-attribution-baseline.md)

## Topology relevance

- Topology A: local/single-node training
- Topology B: distributed training on Lambda.ai

## Key questions this domain must answer

- What constitutes a training run?
- What metadata is mandatory in MLflow?
- How is distributed topology represented and compared to local runs?
- Which evaluation outputs are required before an artifact can move downstream?

## Assistant implications

Useful assistant capabilities here include:
- comparing runs
- explaining regressions
- identifying missing reproducibility metadata
- correlating training cost with run characteristics

## Open decisions

- exact MLflow tag schema
- exact distributed-training reference pattern(s)
- exact minimal evaluation gates before packaging/promotion
