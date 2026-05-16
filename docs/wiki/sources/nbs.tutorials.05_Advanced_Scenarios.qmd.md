---
updated: 2026-05-16
summary: Compact advanced-scenarios tutorial covering local scale, distributed training, batch inference, online inference, promotion, failure recovery, and AWS / Floci parity recommendations with MLflow as the interim traceability layer.
read_when:
  - You need the short advanced-scenarios summary instead of the longer notebook
source_file: ../../nbs/tutorials/05_Advanced_Scenarios.qmd
sources:
  - ../architecture/target-system.md
  - ../topologies/index.md
  - ../decisions/security-authorization-architecture.md
---

# Source summary: nbs/tutorials/05_Advanced_Scenarios.qmd

## Role

Summarizes the topology-specific scenarios that extend the reference slice: local scale-out, distributed training, batch inference, online inference, promotion, assistant usage, and failure handling.

## Main points

- advanced scenarios still preserve immutable source, traceability, policy, and topology boundaries
- the repository stays framework-neutral on serving
- governance and cost remain first-class concerns
- AWS-native options that Floci can emulate locally are preferred for the biggest gaps
- MLflow remains the interim traceability layer until a proper datalake is defined

## Use when

- you need the scenario map for topology work
- you want the shortest summary of non-local patterns
