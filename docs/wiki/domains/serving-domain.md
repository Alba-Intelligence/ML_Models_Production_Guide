---
updated: 2026-05-10
summary: Serving domain responsibilities for notebook-driven local inference, batch/online contracts, rollout behavior, and inference runtime concerns.
read_when:
  - You are defining inference behavior or service contracts
  - You are deciding where serving concerns stop and infrastructure concerns begin
sources:
  - index.md
  - ../contracts/model-artifact-baseline.md
  - ../contracts/deployment-baseline.md
  - ../contracts/prediction-logging-baseline.md
  - ../contracts/security-baseline.md
  - ../architecture/reference-architecture-skeleton.md
---

# Serving domain

## Owns

- notebook-driven local inference reference interfaces
- inference request/response contracts
- online prediction path behavior
- batch prediction orchestration contract
- model loading/runtime behavior
- rollout/rollback behavior at the service-contract layer

## Does not own

- training internals
- low-level cloud provisioning
- IAM/network design details
- cost-reporting policy

## Lifecycle coverage

Primary coverage:
- local serving
- batch inference
- online inference
- rollout and rollback semantics

## Contracts consumed

- [../contracts/model-artifact-baseline.md](../contracts/model-artifact-baseline.md)
- [../contracts/deployment-baseline.md](../contracts/deployment-baseline.md)
- [../contracts/prediction-logging-baseline.md](../contracts/prediction-logging-baseline.md)
- [../contracts/security-baseline.md](../contracts/security-baseline.md)

## Topology relevance

- Topology A: local nbdev/Python inference serving
- Topology C: batch inference
- Topology D: online inference under production controls

## Key questions this domain must answer

- What is the contract for inference requests and responses?
- How does batch inference differ operationally from online inference while reusing common artifact assumptions?
- How are rollout and rollback represented at the serving layer?
- What is the minimum prediction logging shape?

## Assistant implications

Useful assistant capabilities here include:
- explaining what is currently serving
- correlating deployment state with service health
- checking whether logs are sufficient for incident review
- comparing batch vs online serving assumptions

## Open decisions

- exact request/response schema conventions
- exact batch-orchestration abstraction
- exact rollout/canary/rollback reference pattern
