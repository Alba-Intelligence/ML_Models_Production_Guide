---
updated: 2026-05-09
summary: Target system and documentation scope for the planned ML deployment reference.
read_when:
  - You need the intended end-state architecture
  - You are evaluating whether a proposed design fits project scope
sources:
  - ../decisions/project-scope-and-constraints.md
  - ../current-state.md
---

# Target system

## Mission

Build an extensive **reference documentation set with code examples** for the full lifecycle of ML systems, from model development to distributed production deployment.

## Scope boundary

The project is not just about serving a model. It should document and demonstrate:

1. model development
2. experiment tracking
3. reproducible training
4. packaging and local API serving
5. infrastructure provisioning
6. distributed compute workflows
7. deployment patterns
8. monitoring and cost visibility
9. security and lineage requirements across the stack

## Technology direction

### Language posture

- Prefer **Python only** to the maximum practical extent.
- Non-Python components are allowed only where the underlying platform requires them.

### OS posture

- **Linux only**

### Reproducible development

- **Docker** is the required reproducible development environment.
- Docker files should be written explicitly in the repository.
- Nix may be used to help generate or support Docker definitions, but Docker artifacts must exist directly.
- The current working assumption is: Docker is the standard path, Nix is an optional convenience/helper layer.

### ML and notebook stack

- **nbdev 3 (Quarto-based)** for notebook-first development, Python package generation, and documentation
- **PyTorch** for model definition and training
- **GPU support is required**
- **MLflow** for experiment tracking, model metadata, and reproducibility support

### Documentation

- **Quarto** (via nbdev 3) for rendered documentation with Mermaid diagrams, cross-references, and automatic indexing
- Documentation source lives in notebooks (`nbs/`) and is rendered to `docs/`
- The living wiki in `docs/wiki/` remains separate as project memory per AGENTS.md

### Infrastructure and compute

- **python-terraform** for Python-driven infrastructure workflows
- **Lambda.ai / Lambda Labs** for distributed compute
- **AWS** for tooling and production-adjacent infrastructure concerns

## Cross-cutting permanent requirements

These are not optional features; they are architectural requirements:

- security
- data lineage
- experiment traceability
- model traceability
- reproducibility
- auditable assistant interactions where assistant automation is introduced

## Audience and depth

### Primary audience

- **ML engineers in hedge funds**

### Content depth

- Favor **architecture plus runnable end-to-end reference patterns**, not architecture-only guidance.
- Production material should include **full production patterns**, not just local prototypes.

## Assistant integration direction

The project uses the following **default MCP/assistant-support scope**:

- MLflow
- observability systems such as Prometheus/Grafana and/or CloudWatch
- AWS cost visibility systems
- Lambda.ai job/usage visibility
- documentation and decision retrieval

Design posture:

- assistant integrations are read-first and least-privilege by default
- write capabilities, if any, should be explicit and auditable
- assistants should consume canonical platform facts through controlled interfaces, not create parallel sources of truth

## Documentation delivery direction

**nbdev 3 with Quarto** is the accepted documentation framework.

Accepted stance:

- notebooks in `nbs/` are the source of truth for code and narrative docs
- `nbdev_export` generates the Python package from notebooks
- `nbdev_preview` / Quarto renders documentation to `docs/`
- The living wiki in `docs/wiki/` remains separate as project memory per AGENTS.md
- Serving patterns will be explored once actual model code exists

## Default monitoring stack

Accepted default:

- **Evidently** for model/data quality and drift-oriented reporting
- **Prometheus** for metrics collection
- **Grafana** for dashboards and operational visibility
- **MLflow** for experiment/model metadata context

Alternatives may still be documented, but this is the canonical reference path.

## Default cost-monitoring stack

Accepted default:

- **AWS Cost Explorer / CUR / Athena / Budgets** for AWS-native governance and visibility
- a **Python attribution layer** to integrate **Lambda.ai** usage/cost data into the broader reporting view

Alternatives may still be documented, but this is the canonical reference path.

### Production model monitoring

#### Option A — Python-first, self-hosted

- `evidently` for drift, data quality, and model quality reporting
- Prometheus + Grafana for service/system metrics
- MLflow for experiment/model metadata

Pros:

- strong Python story
- self-hostable
- documentation-friendly and transparent

Tradeoffs:

- more integration work
- more operational ownership

#### Option B — `whylogs` / WhyLabs-oriented

- `whylogs` for Python-native data/model profiling
- WhyLabs for hosted monitoring and alerting
- MLflow retained for experiments and registry-style metadata

Pros:

- Python-friendly instrumentation
- easier managed monitoring path

Tradeoffs:

- introduces a managed external platform
- less fully self-hosted

#### Option C — Enterprise managed observability platform

Examples: Arize, Fiddler, or similar

Pros:

- rich production monitoring features
- lower DIY burden

Tradeoffs:

- weaker fit with the project's Python-first and documentation-first posture
- potentially higher cost and more vendor coupling

### Cost monitoring

#### Option 1 — AWS-native cost visibility

- AWS Cost Explorer
- AWS Budgets
- CUR (Cost and Usage Report)
- Athena-based analysis and tagged cost allocation

Pros:

- native and strong for AWS workloads
- good for governance and budgeting

Tradeoffs:

- weaker visibility into non-AWS compute such as Lambda.ai unless separately integrated

#### Option 2 — Unified custom cost attribution in Python

- ingest AWS billing exports and Lambda.ai billing/usage data into a Python reporting pipeline
- attribute cost by run, experiment, team, or model version
- publish summaries to docs or dashboards

Pros:

- best fit for project-specific examples
- cross-provider view

Tradeoffs:

- more engineering effort
- requires clear tagging and lineage discipline

#### Option 3 — Prometheus/Grafana plus billing collectors

- infrastructure/resource metrics in Prometheus
- billing data from cloud providers ingested via scheduled collectors
- dashboards in Grafana

Pros:

- operationally unified view
- flexible for examples

Tradeoffs:

- billing data often arrives on different cadences than runtime metrics
- requires custom collection work

## Likely documentation sections

- local development environment
- PyTorch training on GPU
- experiment tracking with MLflow
- artifact/model packaging via nbdev
- infrastructure with python-terraform
- distributed compute on Lambda.ai
- AWS tooling and production integration
- security controls
- lineage and traceability
- model monitoring
- cost monitoring

## Coverage priorities

The reference should cover all three of these, with clear separation of concerns between them:

- distributed training
- batch inference
- online inference

## Lineage scope

Lineage and traceability should cover all of the following:

- datasets
- features / transformations
- experiments
- trained model artifacts
- model versions
- deployments
- operational runs where relevant

## Outstanding design questions

- What should the exact top-level table of contents be?
- How should the reference divide material between reusable platform patterns and hedge-fund-specific operating constraints?
- How should Nix participate in Docker generation without becoming a second competing primary development path while remaining a helper layer only?
