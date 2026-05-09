---
updated: 2026-05-09
summary: Cost domain responsibilities for spend attribution, reporting, budgets, and unit economics across training and inference.
read_when:
  - You are defining cost visibility or budget controls
  - You are deciding where cost concerns stop and observability or infrastructure concerns begin
sources:
  - index.md
  - ../contracts/cost-attribution-baseline.md
  - ../architecture/reference-architecture-skeleton.md
  - ../architecture/assistant-integration-and-docs-delivery.md
---

# Cost domain

## Owns

- spend attribution model
- tag/label requirements for cost visibility
- reporting expectations
- budget and alerting guidance
- unit-economics views across training, batch, and online inference

## Does not own

- service health metrics
- training algorithm logic
- deployment routing behavior
- cloud resource provisioning itself

## Lifecycle coverage

Primary coverage:
- training cost visibility
- batch inference cost visibility
- online inference unit economics
- budget governance and reporting

## Contracts consumed

- [../contracts/cost-attribution-baseline.md](../contracts/cost-attribution-baseline.md)
- [../contracts/experiment-traceability-baseline.md](../contracts/experiment-traceability-baseline.md)
- [../contracts/deployment-baseline.md](../contracts/deployment-baseline.md)
- [../contracts/prediction-logging-baseline.md](../contracts/prediction-logging-baseline.md)

## Topology relevance

- Topology B: distributed training cost attribution
- Topology C: batch job cost attribution
- Topology D: online service unit economics

## Key questions this domain must answer

- What dimensions must spend be attributable by?
- How are AWS and Lambda.ai brought into one reporting view?
- What constitutes a cost anomaly?
- Which unit-economics measures should be standard across examples?

## Assistant implications

This is another high-value assistant domain.
Useful assistant capabilities here include:
- explaining cost spikes
- identifying untagged resources
- comparing training runs by cost efficiency
- comparing batch vs online unit economics

## Open decisions

- default cost stack
- exact attribution schema across AWS and Lambda.ai
- exact budget/alert policy to document as the reference default
