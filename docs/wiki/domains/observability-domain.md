---
updated: 2026-05-09
summary: Observability domain responsibilities for metrics, logs, traces, drift, quality signals, and alerting.
read_when:
  - You are defining monitoring or alerting behavior
  - You are deciding where observability concerns stop and governance/cost concerns begin
sources:
  - index.md
  - ../contracts/prediction-logging-baseline.md
  - ../contracts/deployment-baseline.md
  - ../architecture/assistant-integration-and-docs-delivery.md
  - ../architecture/reference-architecture-skeleton.md
---

# Observability domain

## Owns

- metrics model
- logs/traces usage where relevant
- drift monitoring
- data quality monitoring
- model quality monitoring
- alerting patterns
- incident diagnosis surfaces

## Does not own

- core training logic
- infrastructure creation
- budget policy
- promotion approvals

## Lifecycle coverage

Primary coverage:
- monitoring and alerting
- incident diagnosis support
- post-deployment and post-inference visibility

## Contracts consumed

- [../contracts/prediction-logging-baseline.md](../contracts/prediction-logging-baseline.md)
- [../contracts/deployment-baseline.md](../contracts/deployment-baseline.md)
- [../contracts/security-baseline.md](../contracts/security-baseline.md)

## Topology relevance

- Topology B: distributed training monitoring
- Topology C: batch monitoring/failure visibility
- Topology D: online inference health, drift, and alerting

## Key questions this domain must answer

- What must be monitored for training, batch, and online separately?
- What is the minimum drift/data-quality posture?
- What signals support fast incident triage?
- How are deployments, prediction logs, and alerts correlated?

## Assistant implications

This is one of the highest-value assistant domains.
Useful assistant capabilities here include:
- summarizing alerts/incidents
- correlating rollout events with metric shifts
- linking drift symptoms to model/version or schema changes
- suggesting next diagnostic steps from current telemetry
- consuming infrastructure MCP interrogation outputs (Kubernetes, Lambda.ai/Slurm, IaC/state, cost signals) to add operational context

## Open decisions

- default monitoring stack
- exact separation between runtime observability and model monitoring
- exact alert taxonomy and escalation posture
