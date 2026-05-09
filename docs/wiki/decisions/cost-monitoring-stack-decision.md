---
updated: 2026-05-09
summary: Accepted default cost-monitoring and attribution stack for the reference.
read_when:
  - You are deciding what cost stack to treat as canonical
  - You are building cost-governance docs or examples
sources:
  - ../architecture/target-system.md
  - ../domains/cost-domain.md
  - ../contracts/cost-attribution-baseline.md
---

# Decision: default cost-monitoring stack

## Status

**Accepted** on 2026-05-09.

## Decision

The default cost-monitoring path for the reference is:

- **AWS Cost Explorer / CUR / Athena / Budgets** for AWS-native cost visibility and governance
- a **Python attribution layer** to integrate and normalize **Lambda.ai** cost and usage data with the AWS view

This is the canonical reference path.

## Why

This gives the best balance of:

- realistic AWS production governance
- explicit cross-provider visibility
- Python-first extensibility
- strong fit for training, batch, and online unit-economics analysis

It also aligns well with the project's requirement that Lambda.ai and AWS both remain in scope.

## Alternatives considered

### Fully custom unified Python reporting from day one

Pros:
- strongest single reporting model
- flexible and portable

Why not default:
- too much bespoke work as the primary baseline
- weaker governance story than starting from AWS-native controls for AWS resources

### Prometheus/Grafana-centered cost collection

Pros:
- operationally unified dashboards

Why not default:
- billing data cadence differs from runtime telemetry
- still requires additional collection/integration layers
- weaker baseline governance framing than CUR/Athena/Budgets

## Consequences

- cost docs should assume AWS-native billing data as the AWS foundation
- Lambda.ai cost docs should assume Python-based normalization/attribution into the broader reporting layer
- cost examples should emphasize tagging/attribution discipline from the start
- assistant cost tooling should prioritize AWS cost surfaces plus Lambda.ai usage integration

## Revisit if

- Lambda.ai cost visibility becomes significantly richer and changes the balance
- a simpler unified cross-provider approach emerges without sacrificing governance quality
- project scope shifts away from AWS production patterns
