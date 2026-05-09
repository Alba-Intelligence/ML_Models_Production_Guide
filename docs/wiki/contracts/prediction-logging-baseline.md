---
updated: 2026-05-09
summary: Minimum logging requirements for batch and online inference so behavior can be monitored, traced, and investigated.
read_when:
  - You are defining inference behavior or observability
  - You are deciding what prediction-level traceability must exist
sources:
  - index.md
  - ../architecture/reference-architecture-skeleton.md
---

# Prediction logging baseline

## Purpose

Define the minimum logging requirements for prediction paths so monitoring, incident review, lineage, and drift analysis are possible.

## Applies to

- online inference requests
- batch inference jobs
- shadow/canary evaluation paths if introduced later

## Every prediction path must define

- model version used
- request identifier or batch identifier
- input schema/version reference
- output capture policy
- runtime metadata relevant to diagnostics
- traceability link to monitoring and incident review

## Runtime metadata should include as relevant

- timestamp
- latency/runtime duration
- environment
- service/job identity
- deployment identifier where applicable
- feature/transformation version if not already implied upstream

## Mandatory rules

- Prediction logs must make it possible to identify which model version produced an output.
- Logging policy must explicitly state what inputs/outputs are retained, transformed, redacted, sampled, or excluded.
- Batch outputs must preserve linkage to input batch identity.
- Online logs must support correlation with deployment and monitoring events.
- Logging must respect security/privacy constraints rather than assuming raw inputs can always be retained.

## Relationship to other contracts

- consumes [deployment-baseline.md](deployment-baseline.md)
- consumes [data-lineage-baseline.md](data-lineage-baseline.md)
- informs [cost-attribution-baseline.md](cost-attribution-baseline.md)
- supports monitoring and incident analysis

## Assistant implications

Assistant tooling should be able to answer:

- which model version produced these predictions?
- did the logging policy preserve enough context to investigate an incident?
- are drift symptoms correlated with a particular deployment or input shape change?
- are batch outputs traceable back to input batch and model version?

## Open decisions

- exact logging schema for online vs batch inference
- exact redaction and retention rules
- exact linkage between logs, traces, alerts, and deployment records
