---
updated: 2026-05-10
summary: Reference topology for Kubernetes-based online inference under production deployment, security, observability, and rollback controls.
read_when:
  - You are defining production request/response serving
  - You want the online serving topology distinct from local serving and batch inference
sources:
  - index.md
  - ../domains/serving-domain.md
  - ../domains/observability-domain.md
  - ../domains/governance-domain.md
  - ../contracts/index.md
---

# Online inference under production controls

## Purpose

Provide the reference topology for:

- versioned request/response serving
- monitored production deployment
- controlled rollout and rollback
- operationally realistic online inference patterns

## Primary domains involved

- serving
- infrastructure
- observability
- governance
- cost
- artifact

## Primary contracts stressed

- deployment baseline
- prediction logging baseline
- security baseline
- model artifact baseline
- cost attribution baseline

## Core assumptions

- online inference services run under AWS Kubernetes controls for non-Lambda.ai services
- production deployment controls are separate from local serving convenience
- monitoring and alerting are attached to every production release
- rollback target and ownership are always explicit

## What this topology is for

- production request/response inference
- deployment/version coordination
- latency-aware and reliability-aware serving examples
- security- and audit-aware release flows

## What this topology is not for

- distributed training
- bulk offline scoring
- ad hoc local demos pretending to be production

## Key risks and boundaries

- docs tooling and model-serving operations must not collapse operational boundaries
- every rollout must be tied to a model version and monitoring configuration
- prediction logging must balance investigability with security/privacy constraints
- cost visibility must support online unit-economics analysis

## Reference flow specification

### Control flow

1. Approve deployment for a model version with explicit rollout and rollback targets.
2. Deploy service revision and bind monitoring/alerting configuration.
3. Route controlled traffic and monitor latency/error/model signals.
4. Emit prediction logs with deployment and model-version linkage.
5. Trigger rollback or promotion continuation based on policy and signals.

### Data and artifact flow

- promoted model version -> deployment record -> live request/response stream -> prediction logs + metrics/traces -> incident/review artifacts

### Contract checkpoints

- deployment baseline validated before traffic shift
- prediction logging baseline validated in pre-release checklist and runtime sampling
- security baseline validated in release approval path
- cost attribution hooks validated for service-level unit economics

## Assistant implications

High-value assistant tasks here include:

- answering what version is live
- correlating deployments with latency/error shifts
- summarizing incident context from logs/metrics/deployments
- identifying likely rollback candidates and missing observability signals
- interrogating Kubernetes runtime state and infrastructure drift/cost signals through MCP surfaces where available

## Open decisions

- exact online deployment reference pattern on AWS
- exact rollout strategy to standardize
- exact production auth posture for service exposure
