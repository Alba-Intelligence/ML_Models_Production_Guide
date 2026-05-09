---
updated: 2026-05-09
summary: Proposed use of MCP-enabled assistant integrations for monitoring/improvement workflows, plus a FastAPI-based documentation delivery model.
read_when:
  - You are deciding how an AI assistant should interact with the platform
  - You are deciding whether FastAPI should be used to write and serve documentation
sources:
  - target-system.md
  - reference-architecture-skeleton.md
  - documentation-toc.md
  - ../decisions/project-scope-and-constraints.md
---

# Assistant integration and docs delivery

## Status

This note now mixes:

- **accepted defaults** for MCP scope and docs-delivery posture
- supporting rationale and design guidance for those choices

## Part 1 — MCP-enabled assistant integrations

## Goal

Allow an AI assistant to help the ML engineer with:

- monitoring review
- cost review
- experiment review
- deployment review
- drift/quality investigation
- incident triage
- ongoing platform improvement suggestions

The assistant should **consume platform facts through controlled interfaces**, not by scraping arbitrary systems ad hoc.

## Architectural stance

Assistant integrations should be treated as an **augmentation layer**, not as a separate source of truth.

That means:

- canonical truth remains in MLflow, infrastructure state, metrics systems, logs, billing systems, and the repository
- the assistant reads through MCP/tool interfaces
- write capabilities should be narrowly scoped and auditable
- recommendations should reference real artifacts, runs, alerts, costs, deployments, and documents

## Recommended MCP categories

### 1. MLflow MCP

Purpose:

- inspect experiments
- compare runs
- inspect metrics/parameters/artifacts
- query model versions and promotion state

High-value assistant tasks:

- summarize run regressions
- compare candidate models
- detect inconsistent experiment metadata
- surface reproducibility gaps

### 2. Observability MCP

Likely backends:

- Prometheus
- Grafana
- CloudWatch
- logging/tracing backends as chosen later

Purpose:

- inspect service health
- inspect latency/error trends
- inspect alert states
- correlate deployment events with metric shifts

High-value assistant tasks:

- summarize incidents
- explain metric shifts after rollout
- identify likely regressions or drift symptoms
- propose next diagnostic steps

### 3. Cost and billing MCP

Likely backends:

- AWS Cost Explorer / CUR / Athena / Budgets
- Lambda.ai usage and billing if exposed via API or a custom MCP adapter

Purpose:

- inspect training/inference cost by environment, job, deployment, or model version
- compare spend across time windows
- identify budget anomalies

High-value assistant tasks:

- explain cost spikes
- attribute expensive runs
- compare unit economics for batch vs online inference
- flag under-tagged resources hurting attribution quality

### 4. Infrastructure MCP

Likely backends:

- Terraform state / plans
- AWS APIs
- container registry / artifact storage as applicable

Purpose:

- inspect deployed resources
- inspect environment drift
- inspect deployment topology and network posture

High-value assistant tasks:

- summarize infra differences between environments
- identify drift against intended topology
- check whether required controls exist before promotion/deployment

### 5. Deployment / serving MCP

Likely backends:

- FastAPI service metadata endpoints
- deployment records
- service registry information

Purpose:

- inspect live model version
- inspect rollout state
- inspect health/readiness and version mappings

High-value assistant tasks:

- answer "what is currently serving?"
- compare intended deployment vs actual deployment
- correlate deployment versions with alerts and incidents

### 6. Documentation / knowledge MCP

Purpose:

- allow the assistant to navigate architecture docs, decisions, runbooks, and examples through a structured interface

High-value assistant tasks:

- answer operator questions using current docs
- suggest documentation updates after incidents or design changes
- link observed production issues back to design decisions and contracts

## MCP design rules

1. **Read-first, write-last.** Most assistant integrations should be read-only by default.
2. **Least privilege.** Do not give an assistant broad mutation rights across cloud/control-plane systems.
3. **Auditability.** Any assistant-triggered write action should be attributable.
4. **Use contracts, not vendor-specific chaos.** MCP tools should expose stable concepts aligned with the architecture: runs, model versions, deployments, alerts, cost records.
5. **No silent actions.** If mutation is ever allowed, it should require explicit confirmation boundaries.
6. **Monitoring and improvement, not autonomous governance.** The assistant may recommend; governance remains policy-driven.

## Accepted default MCP scope

The default assistant-support scope includes all of these as core surfaces:

1. **MLflow**
2. **Prometheus/Grafana and/or CloudWatch**
3. **AWS cost visibility**
4. **Lambda.ai usage/job visibility**
5. **Documentation/decision retrieval**

That set is the accepted default because it gives the assistant useful coverage across experimentation, operations, cost, and project memory.

## Part 2 — FastAPI for writing and serving documentation

## Short answer

**Yes, this is plausible and potentially very aligned with the stack** — but the safest design is:

- markdown files remain the canonical documentation source
- FastAPI becomes the serving/composition/search/workflow layer
- optional authoring conveniences can be built on top later

## Accepted stance

Use FastAPI for documentation in a **hybrid optional-companion** way, not as the primary source of truth and not as a mandatory default architecture element.

### Canonical source of truth

- markdown files in the repository
- decision records and wiki pages versioned in git
- generated metadata/indexes if useful

### FastAPI role

- serve rendered docs
- serve searchable metadata
- serve example catalogs and cross-links
- expose structured navigation and filters
- optionally provide authenticated authoring helpers later

## Why this fits the project

### Pros

- stays Python-first
- uses the same framework family already chosen for local serving examples
- makes docs and platform examples live in one conceptual stack
- enables dynamic views such as example matrices, topology filters, contract cross-links, and assistant-assisted navigation
- can later expose machine-readable endpoints for an assistant or internal tooling

### Tradeoffs

- more complexity than a purely static docs site
- must avoid turning documentation into app-state hidden behind a database
- must preserve git-based reviewability and reproducibility
- must keep security in mind if any write/edit surface is added

## Recommended documentation architecture

### Layer A — Source layer

- markdown documents in repo
- structured frontmatter
- code examples stored as files next to docs or in dedicated example directories

### Layer B — Build/index layer

- Python indexing of docs metadata
- link graph, tags, domains, topologies, contracts, and example relationships
- optional static artifact generation for search/navigation

### Layer C — Delivery layer

- FastAPI routes render and serve docs
- optional JSON endpoints expose the doc graph and example catalog
- optional authenticated edit/preview workflow can be layered on later

## Writing workflow recommendation

Do **not** begin with browser-first documentation editing.

Recommended order:

1. author docs as markdown in git
2. render/serve them via FastAPI
3. add preview/search/graph features
4. only then consider authenticated authoring helpers if they solve a real pain point

This keeps documentation reproducible and reviewable.

## Where docs-serving belongs architecturally

Documentation serving should be treated as part of the **platform/documentation delivery surface**, not mixed into model-serving topology.

That means:

- same framework family may be used (`FastAPI`)
- but docs delivery should remain logically separate from model inference delivery
- separate routes, config, auth posture, and deployment concerns should be assumed

## Recommendation

### MCP recommendation

Accepted default scope:

- monitoring
- cost review
- experiment analysis
- deployment review
- incident triage
- documentation retrieval

### FastAPI docs recommendation

Accepted posture:

- FastAPI is a good fit to **serve** documentation and structured metadata
- markdown in git remains canonical
- dynamic serving does not replace versioned source files
- docs delivery remains an optional companion pattern, not a mandatory core default
- any authoring workflow is added later and remains auditable

## What this implies for the doc set

The documentation TOC should probably gain explicit treatment for:

- assistant/MCP integration surfaces
- documentation delivery architecture
- machine-readable metadata for docs and examples
