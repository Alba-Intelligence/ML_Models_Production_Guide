---
updated: 2026-05-10
summary: Ratified top-down reference architecture skeleton for the project, organized by lifecycle, domains, contracts, and topologies.
read_when:
  - You are aligning on the project architecture before implementation
  - You need the canonical separation of concerns
sources:
  - target-system.md
  - top-down-planning.md
  - ../decisions/project-scope-and-constraints.md
---

# Reference architecture skeleton

## Status

This is the **ratified architecture skeleton** for the specification-first phase.
Use it as the stable spine for documentation, contracts, topology pages, and example design.

## Mission

Provide a Python-first reference for ML engineers in hedge funds that covers the full path from PyTorch model development to distributed production, including training, batch inference, online inference, security, lineage, observability, cost governance, and reproducibility.

## Architectural principles

1. **Lifecycle first** — organize around the real ML system lifecycle, not around tools alone.
2. **Bounded domains** — assign each concern a domain with clear boundaries.
3. **Cross-cutting contracts** — define lineage, security, traceability, and reproducibility once and apply them everywhere.
4. **Topology separation** — keep local dev, distributed training, batch inference, and online inference distinct.
5. **Python-first implementation** — prefer Python unless the underlying platform forces something else.
6. **Production realism** — examples should be runnable patterns, not toy snippets detached from operations.
7. **Security by default** — security is a design input, not a hardening pass.
8. **Lineage by construction** — every major artifact and operational step should be attributable and reconstructable.
9. **Assistant augmentation, not shadow control planes** — AI assistants should work through explicit, auditable interfaces over canonical systems.

## System boundary

### In scope

- dataset versioning and provenance
- feature / transformation reproducibility
- experiment tracking
- PyTorch GPU training
- distributed training on Lambda.ai
- model evaluation and validation
- model packaging and registration
- local serving via nbdev-exported Python inference interfaces
- batch inference patterns
- online inference patterns
- infrastructure workflows with `python-terraform`
- AWS Kubernetes production patterns for non-Lambda.ai services
- MLflow persistence with PostgreSQL backend + S3 artifact storage
- Slurm coordination/redundancy patterns on Lambda.ai for distributed runs
- monitoring and alerting
- cost governance and attribution
- security controls and auditability
- rollback / incident response patterns
- MCP-enabled assistant integration surfaces for monitoring and ongoing improvement
- documentation delivery via nbdev/Quarto with optional companion dynamic services kept separate from model-serving concerns

### Out of scope

- non-PyTorch model stacks
- non-Linux platforms
- non-Docker primary dev environment
- generic multi-language platform examples unless unavoidable
- speculative platform abstractions that are not needed by the reference

## Lifecycle spine

This is the canonical end-to-end lifecycle the documentation should follow.

1. data intake and dataset versioning
2. feature / transformation definition
3. experiment specification
4. training execution
5. evaluation and validation
6. model packaging
7. model registration and promotion
8. local serving
9. distributed training
10. batch inference
11. online inference
12. monitoring and alerting
13. cost governance
14. incident response and rollback

## Core system objects

These are the major object types the reference should treat as first-class.

- **Dataset version** — immutable or versioned training/inference data snapshot with provenance
- **Transformation spec** — feature logic and preprocessing definition tied to code and input schema
- **Experiment run** — tracked execution with parameters, environment, lineage, metrics, and artifacts
- **Training job** — concrete compute execution, local or distributed
- **Model artifact** — serialized trained model plus metadata and reproducibility context
- **Model version** — promoted registry entry with validation status and usage intent
- **Deployment record** — where a model version was deployed, with infra and policy context
- **Inference run** — batch or online prediction event collection with monitoring and lineage hooks
- **Cost record** — spend attribution tied to environment, workload, model, run, or deployment
- **Assistant interaction record** — auditable assistant query/action context where assistant automation is permitted

## Architectural domains

### 1. Data domain

**Owns**

- data intake
- dataset versioning
- schemas
- provenance
- retention rules
- data quality gates

**Does not own**

- model training logic
- serving logic
- infrastructure provisioning

**Primary concerns**

- source traceability
- immutability/versioning strategy
- schema evolution
- training/inference data parity

### 2. Training domain

**Owns**

- PyTorch model code
- training configuration
- GPU execution logic
- distributed training behavior
- evaluation hooks
- experiment metadata emission to MLflow

**Does not own**

- model promotion policy
- deployment infra
- production serving runtime

**Primary concerns**

- determinism where feasible
- reproducible environments
- experiment traceability
- distributed training topology

### 3. Artifact domain

**Owns**

- model packaging format
- artifact metadata
- registry representation
- versioning and promotion states
- compatibility constraints for serving

**Does not own**

- training execution
- online request handling
- infrastructure lifecycle

**Primary concerns**

- artifact completeness
- registry traceability
- promotion discipline
- deployment compatibility

### 4. Serving domain

**Owns**

- local inference interfaces from nbdev-exported Python modules
- inference request/response contracts
- online prediction path
- batch prediction orchestration contract
- model loading and inference runtime concerns

**Does not own**

- training internals
- low-level cloud provisioning
- billing systems

**Primary concerns**

- latency/capacity behavior
- schema compatibility
- prediction logging
- safe rollout / rollback behavior

### 5. Infrastructure domain

**Owns**

- `python-terraform` workflows
- AWS resource patterns
- AWS Kubernetes patterns for platform services
- Lambda.ai compute patterns
- Slurm job orchestration/redundancy patterns on Lambda.ai
- networking
- storage topology
- environment separation

**Does not own**

- business evaluation criteria
- model semantics
- monitoring policy definitions

**Primary concerns**

- reproducible environments
- network and compute boundaries
- secret and identity integration
- deployable topologies

### 6. Observability domain

**Owns**

- service metrics
- logs and traces where relevant
- drift monitoring
- data quality monitoring
- model quality monitoring
- alerting patterns

**Does not own**

- training code
- infrastructure creation
- promotion policy

**Primary concerns**

- production visibility
- model behavior change detection
- incident diagnosis
- correlation between inference behavior and model versions

### 7. Governance domain

**Owns**

- security requirements
- IAM and access policy guidance
- secret handling patterns
- auditability
- approval boundaries
- policy checkpoints for promotion and deployment

**Does not own**

- training algorithms
- batch scheduling logic
- core observability tooling selection

**Primary concerns**

- least privilege
- environment isolation
- audit trails
- policy enforcement

### 8. Cost domain

**Owns**

- spend attribution model
- tagging/labeling requirements
- cost dashboards and reporting
- budget and alerting guidance
- unit-economics views for training and inference

**Does not own**

- service metrics
- training code
- deployment routing logic

**Primary concerns**

- cross-provider visibility
- training cost attribution
- batch and online inference cost analysis
- budget enforcement discipline

## Cross-cutting contracts

These contracts must be defined once and then reused across all domains and topologies.

### Contract A — Security baseline

Every workload should define:

- identity boundary
- secret source
- network boundary
- access scope
- audit trail location

### Contract B — Data lineage baseline

Every dataset and transformation should define:

- source origin
- version identifier
- schema version
- producing code reference
- downstream consumers

### Contract C — Experiment traceability baseline

Every experiment/training run should define:

- code revision
- container/environment revision
- dataset version(s)
- transformation version(s)
- hyperparameters
- compute context
- produced artifacts
- evaluation outputs

### Contract D — Model artifact baseline

Every model artifact should define:

- training run origin
- framework/version
- serialization format
- expected input/output schema
- evaluation summary
- intended serving modes
- security and compatibility notes

### Contract E — Deployment baseline

Every deployment should define:

- deployed model version
- target environment
- infra revision
- rollout timestamp
- rollback target
- monitoring configuration
- ownership/contact

### Contract F — Prediction logging baseline

Every serving or batch path should define:

- model version used
- request or batch identifier
- input schema/version reference
- output capture policy
- latency/runtime metadata where relevant
- traceability link to monitoring and incident review

### Contract G — Cost attribution baseline

Every major compute/storage resource should define:

- environment
- workload type
- owning system/domain
- experiment/job/deployment linkage
- provider-specific cost tags/labels

## Reference topologies

### Topology A — Local development and single-node GPU training

Purpose:

- developer productivity
- reproducible local iteration
- notebook-driven local inference orchestration
- local MLflow-connected experimentation

Primary planes:

- Docker-based dev environment
- optional Nix helper layer
- local or attached GPU
- local docs/examples loop

### Topology B — Distributed training on Lambda.ai

Purpose:

- multi-GPU or multi-node training patterns
- experiment traceability under distributed execution
- promotion of trained artifacts back into the canonical artifact flow

Primary planes:

- training compute on Lambda.ai
- artifact/log/metadata integration back to MLflow and storage
- security, secrets, and config discipline across remote execution

### Topology C — Batch inference on AWS-integrated infrastructure

Purpose:

- scheduled or event-driven large-scale inference
- strong lineage from input batch to output batch
- predictable cost attribution and operational controls

Primary planes:

- batch job orchestration
- artifact retrieval
- output storage and lineage capture
- budget and runtime monitoring

### Topology D — Online inference under production controls

Purpose:

- request/response serving
- versioned deployments
- monitored latency and behavior
- controlled rollout and rollback

Primary planes:

- Python inference contract and service adapter
- AWS-integrated production controls
- Kubernetes-based orchestration and operations
- observability and alerting
- deployment policy and rollback path

## Assistant augmentation surfaces

The architecture should likely expose controlled assistant-facing surfaces for:

- experiment/run inspection
- model/version inspection
- deployment-state inspection
- alert and metric review
- cost review
- documentation retrieval

These surfaces should prefer MCP/tool interfaces over direct ad hoc scraping.

## Documentation delivery posture

If a dynamic documentation service is used, the design should assume:

- markdown files in git remain canonical
- docs delivery is logically separate from model-serving delivery
- structured metadata/search/navigation may be served dynamically
- authenticated write/edit helpers, if ever added, remain auditable and non-canonical

## Separation-of-concerns rules

1. **Training pages must not hide infrastructure decisions.** They can reference infrastructure assumptions, but infra lives in the infrastructure domain.
2. **Serving pages must not redefine model packaging contracts.** They consume artifact contracts.
3. **Monitoring pages must not redefine logging requirements ad hoc.** They consume prediction and deployment contracts.
4. **Security policy must not be restated differently in each topology.** Topologies inherit governance contracts.
5. **Cost reporting must not be bolted on later.** Every topology must declare cost attribution hooks from day one.
6. **Assistant integrations must not become a second control plane.** They consume canonical facts and act through explicit, auditable interfaces.
7. **Documentation delivery must remain separate from model-serving delivery.** Shared framework is fine; shared operational concern boundaries are not.
8. **Examples must point back to domains and contracts.** No example should stand alone as an unexplained demo.

## Accepted default stack posture

- Training: PyTorch + GPU
- Experiment tracking: MLflow
- MLflow storage: PostgreSQL backend + S3 artifact store
- Local serving: nbdev-exported Python inference interfaces
- Infra workflows: `python-terraform`
- Distributed training: Lambda.ai + Slurm coordination/redundancy
- Production platform patterns: AWS Kubernetes for non-Lambda.ai services
- Reproducible development: Docker
- Optional environment assistance: Nix
- Default monitoring stack: `evidently` + Prometheus/Grafana + MLflow
- Default cost stack: AWS CUR/Athena/Budgets + Python attribution layer for Lambda.ai
- Default assistant integration scope: MLflow + observability + cost + Lambda.ai usage + documentation/decision retrieval through MCP-style interfaces
- Docs delivery posture: markdown-in-git is canonical; optional dynamic docs services must remain separate from inference serving

## What this skeleton should enable next

Once agreed, this skeleton should support:

1. a stable documentation table of contents
2. per-domain spec pages
3. per-contract spec pages
4. per-topology spec pages
5. a code-example inventory mapped to the architecture instead of scattered by tool
