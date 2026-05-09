---
updated: 2026-05-09
summary: Proposed table of contents for the documentation set, derived from the reference architecture skeleton.
read_when:
  - You are deciding how to organize the documentation
  - You are deciding where a new page or example belongs
sources:
  - reference-architecture-skeleton.md
  - top-down-planning.md
  - ../decisions/project-scope-and-constraints.md
---

# Documentation table of contents

## Status

This is a **proposed TOC** for agreement during the specification-first phase.
It should become the canonical organization for documentation and code examples.

## TOC design rules

- Organize by lifecycle and domain, not by whichever tool is most visible.
- Keep local development separate from production topology concerns.
- Keep cross-cutting contracts separate from topology-specific implementations.
- Put examples near the concepts they prove, but also maintain a global example catalog.
- Treat training, batch inference, and online inference as distinct top-level concerns.

## Proposed top-level structure

### 00. Introduction and scope

Purpose:

- explain audience, goals, constraints, and how to read the reference

Candidate pages:

- audience and problem framing
- project scope and non-goals
- glossary and terminology
- how to use this reference

### 01. Reference architecture

Purpose:

- define the system at the highest level before any implementation detail

Candidate pages:

- architecture overview
- lifecycle map
- domain map
- reference topologies
- system objects and metadata model
- assistant integration surfaces
- documentation delivery architecture

### 02. Cross-cutting contracts

Purpose:

- define the reusable invariants that every domain and topology must follow

Candidate pages:

- security baseline
- data lineage baseline
- experiment traceability baseline
- model artifact baseline
- deployment baseline
- prediction logging baseline
- cost attribution baseline

### 03. Data and lineage

Purpose:

- define dataset, schema, and transformation behavior

Candidate pages:

- dataset versioning strategy
- schema management
- data provenance model
- feature/transformation reproducibility
- training/inference data parity
- lineage records and audit trail

### 04. Training and experimentation

Purpose:

- define PyTorch training workflows and MLflow usage

Candidate pages:

- experiment structure
- run configuration model
- GPU training patterns
- distributed training concepts
- evaluation and validation
- reproducibility strategy

### 05. Model packaging and registry

Purpose:

- define what a trained model becomes after training

Candidate pages:

- model artifact structure
- packaging strategy
- registry and versioning model
- promotion gates
- compatibility rules for serving and batch use

### 06. Local development and local serving

Purpose:

- support local iteration without mixing it with production topology

Candidate pages:

- Docker dev environment
- Nix helper posture
- local MLflow workflow
- FastAPI local serving contract
- local documentation preview/serving workflow
- local smoke testing patterns

### 07. Distributed training

Purpose:

- define the remote training topology on Lambda.ai

Candidate pages:

- Lambda.ai compute model
- job packaging and launch flow
- distributed training metadata requirements
- artifact sync and recovery
- remote secrets/config handling
- failure handling and restart patterns

### 08. Batch inference

Purpose:

- define offline or scheduled large-scale inference

Candidate pages:

- batch job lifecycle
- input/output contracts
- model retrieval and execution
- batch lineage requirements
- result storage patterns
- batch cost controls
- batch monitoring and failure handling

### 09. Online inference

Purpose:

- define production request/response serving patterns

Candidate pages:

- service contract and schemas
- deployment topology
- rollout strategy
- rollback strategy
- latency/reliability controls
- prediction logging and observability

### 10. Infrastructure and environment

Purpose:

- define platform patterns without collapsing them into application logic

Candidate pages:

- environment separation
- networking model
- storage model
- secret management patterns
- `python-terraform` workflow design
- Docker image strategy
- container provenance

### 11. Security and governance

Purpose:

- state the permanent policy layer of the system

Candidate pages:

- IAM and identity boundaries
- secrets and key management
- environment isolation
- auditability requirements
- promotion approvals
- deployment approvals
- hedge-fund-specific security posture notes

### 12. Observability and monitoring

Purpose:

- define production visibility and model-awareness across workloads

Candidate pages:

- metrics/logs/traces model
- model monitoring options
- drift and data quality monitoring
- service SLOs and alerting
- incident triage and diagnosis workflow
- assistant-assisted monitoring and improvement workflows
- recommended default monitoring stack

### 13. Cost governance

Purpose:

- make cost a first-class operational concern

Candidate pages:

- cost model by topology
- tagging and attribution requirements
- AWS cost visibility patterns
- Lambda.ai cost visibility patterns
- budget and alerting policy
- recommended default cost stack

### 14. Operations, rollback, and incident response

Purpose:

- define steady-state and failure-state operational procedures

Candidate pages:

- deployment rollback
- training failure recovery
- batch failure recovery
- incident severity model
- production troubleshooting workflow
- postmortem structure

### 15. Code examples catalog

Purpose:

- maintain a curated index of examples after architecture and contracts are clear

Candidate pages:

- example matrix
- quickstart examples
- topology-aligned examples
- contract-focused examples
- validation and test examples

### 16. Decision records

Purpose:

- preserve durable architectural decisions and tradeoffs

Candidate pages:

- monitoring stack decision
- cost stack decision
- Docker/Nix decision
- assistant integration / MCP decision
- documentation delivery decision
- artifact packaging decision
- deployment pattern decision

## Recommended page template

Most documentation pages should follow a consistent structure:

1. purpose
2. scope and non-goals
3. upstream dependencies
4. domain ownership
5. contracts consumed
6. contracts produced
7. topology relevance
8. operational/security/lineage implications
9. code examples linked
10. open questions or deferred decisions

## Recommended example template

Each code example should declare:

- lifecycle stage
- primary domain
- supporting domains
- topology
- inputs and outputs
- security assumptions
- lineage implications
- reproducibility expectations
- monitoring hooks
- cost visibility hooks

## Recommended build order for the docs

1. `00` and `01`
2. `02`
3. `03`, `04`, `05`
4. `06`, `07`, `08`, `09`
5. `10`, `11`, `12`, `13`
6. `14`
7. `15`
8. `16`

This order forces contracts and architecture to exist before examples and detailed procedures.

## Placement rules

When deciding where a new page belongs:

- If it defines a reusable invariant, it belongs in **02**.
- If it defines one domain's behavior, it belongs in that domain's section.
- If it describes a deployment shape, it belongs in **07**, **08**, or **09**.
- If it is purely operational policy, it belongs in **11**, **12**, **13**, or **14**.
- If it is primarily demonstrative code, it belongs in **15** with backlinks to the governing docs.

## Immediate follow-on pages to create after TOC approval

1. architecture overview
2. lifecycle map
3. domain map
4. security baseline
5. data lineage baseline
6. experiment traceability baseline
7. model artifact baseline
8. deployment baseline
9. prediction logging baseline
10. cost attribution baseline
11. assistant integration surfaces
12. documentation delivery architecture
