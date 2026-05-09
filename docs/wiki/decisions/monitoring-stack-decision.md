---
updated: 2026-05-09
summary: Accepted default production monitoring stack for the reference.
read_when:
  - You are deciding what monitoring stack to treat as canonical
  - You are building monitoring-related docs or examples
sources:
  - ../architecture/target-system.md
  - ../domains/observability-domain.md
  - ../contracts/prediction-logging-baseline.md
---

# Decision: default monitoring stack

## Status

**Accepted** on 2026-05-09.

## Decision

The default monitoring stack for the reference is:

- **Evidently** for model/data quality and drift-oriented reporting
- **Prometheus** for metrics collection
- **Grafana** for dashboards and operational visibility
- **MLflow** for experiment/model metadata context

This is the default documented path.
Other options may still be discussed as alternatives, but they are not the canonical reference path.

## Why

This choice best matches the project's goals:

- Python-first posture
- self-hostable and transparent behavior
- strong educational/reference value
- clean separation between operational metrics and experiment/model metadata
- good fit for assistant-assisted monitoring workflows through MCP/tool integrations

## Alternatives considered

### WhyLogs / WhyLabs-oriented path

Pros:
- Python-friendly
- easier managed experience

Why not default:
- introduces more vendor coupling
- weaker fit for a self-hostable reference baseline

### Fully managed model-monitoring vendor path

Pros:
- less integration work
- rich enterprise features

Why not default:
- weaker fit for a general reusable reference
- less transparent as a teaching/documentation baseline
- higher vendor dependence

## Consequences

- monitoring docs and examples should assume Evidently + Prometheus + Grafana + MLflow unless explicitly labeled alternative
- prediction logging, deployment, and observability pages should align to this default
- assistant integration planning should prioritize Prometheus/Grafana plus MLflow visibility surfaces

## Revisit if

- the selected stack proves too operationally heavy for the intended reference quality
- an alternative produces significantly clearer Python-first workflows with equal transparency
- project goals shift toward a managed-vendor-first baseline
