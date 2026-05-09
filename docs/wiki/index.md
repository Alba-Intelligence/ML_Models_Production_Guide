---
updated: 2026-05-09
summary: Primary router for the living wiki. Read this first, then load only the pages relevant to the task.
read_when:
  - Starting any task in this repository
  - You need to find the smallest useful context set
sources:
  - overview.md
  - current-state.md
  - architecture/dev-environment.md
  - architecture/target-system.md
  - architecture/top-down-planning.md
  - architecture/reference-architecture-skeleton.md
  - architecture/documentation-toc.md
  - architecture/assistant-integration-and-docs-delivery.md
  - contracts/index.md
  - domains/index.md
  - topologies/index.md
  - runbooks/jupyter-and-shell.md
  - decisions/repository-shape.md
  - decisions/project-scope-and-constraints.md
  - sources/flake.nix.md
  - sources/flake.lock.md
  - sources/gitignore.md
  - sources/LICENSE.md
---

# Wiki index

## Fast routing

| If you need to…                                                      | Read these pages                                                                                                                                                                                                       |
| -------------------------------------------------------------------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| Understand what this repository currently is                         | [overview.md](overview.md), [current-state.md](current-state.md)                                                                                                                                                       |
| Understand the intended end-state architecture and stack             | [architecture/target-system.md](architecture/target-system.md), [decisions/project-scope-and-constraints.md](decisions/project-scope-and-constraints.md)                                                               |
| Plan the project top-down without losing separation of concerns      | [architecture/top-down-planning.md](architecture/top-down-planning.md), [architecture/reference-architecture-skeleton.md](architecture/reference-architecture-skeleton.md)                                             |
| Review the proposed architecture skeleton                            | [architecture/reference-architecture-skeleton.md](architecture/reference-architecture-skeleton.md), [architecture/target-system.md](architecture/target-system.md)                                                     |
| Review the proposed documentation structure                          | [architecture/documentation-toc.md](architecture/documentation-toc.md), [architecture/reference-architecture-skeleton.md](architecture/reference-architecture-skeleton.md)                                             |
| Review assistant/MCP and docs-delivery proposals                     | [architecture/assistant-integration-and-docs-delivery.md](architecture/assistant-integration-and-docs-delivery.md), [architecture/target-system.md](architecture/target-system.md)                                     |
| Review the cross-cutting contracts                                   | [contracts/index.md](contracts/index.md), [architecture/reference-architecture-skeleton.md](architecture/reference-architecture-skeleton.md)                                                                           |
| Review the bounded domain pages                                      | [domains/index.md](domains/index.md), [architecture/reference-architecture-skeleton.md](architecture/reference-architecture-skeleton.md)                                                                              |
| Review the reference topologies                                      | [topologies/index.md](topologies/index.md), [architecture/reference-architecture-skeleton.md](architecture/reference-architecture-skeleton.md)                                                                         |
| Decide how much weight to give decision records                      | [queries/decision-records-and-project-restart.md](queries/decision-records-and-project-restart.md), [architecture/top-down-planning.md](architecture/top-down-planning.md)                                           |
| Check whether implementation is allowed yet                          | [decisions/project-scope-and-constraints.md](decisions/project-scope-and-constraints.md), [current-state.md](current-state.md)                                                                                         |
| Modify the Nix dev shell or toolchain                                | [architecture/dev-environment.md](architecture/dev-environment.md), [sources/flake.nix.md](sources/flake.nix.md)                                                                                                       |
| Understand pinned upstream dependencies                              | [sources/flake.lock.md](sources/flake.lock.md)                                                                                                                                                                         |
| Understand repository licensing posture                              | [sources/LICENSE.md](sources/LICENSE.md), [overview.md](overview.md)                                                                                                                                                   |
| Run or debug Jupyter / kernel setup                                  | [runbooks/jupyter-and-shell.md](runbooks/jupyter-and-shell.md), [sources/flake.nix.md](sources/flake.nix.md)                                                                                                           |
| Understand git tracking, ignored files, or private-doc conventions   | [sources/gitignore.md](sources/gitignore.md), [current-state.md](current-state.md)                                                                                                                                     |
| Understand durable repo conventions and why the repo is still sparse | [decisions/repository-shape.md](decisions/repository-shape.md), [current-state.md](current-state.md)                                                                                                                   |
| See what changed in the wiki recently                                | [log.md](log.md), [revisions/2026-05-09-contract-baselines.md](revisions/2026-05-09-contract-baselines.md), [revisions/2026-05-09-assistant-and-docs-delivery.md](revisions/2026-05-09-assistant-and-docs-delivery.md) |

## Core pages

- [README.md](README.md) — how this living wiki works.
- [overview.md](overview.md) — high-level project summary.
- [current-state.md](current-state.md) — honest snapshot of the repository today.
- [log.md](log.md) — append-only change log for the wiki.

## Architecture

- [architecture/target-system.md](architecture/target-system.md) — intended end-state scope, audience, stack, and monitoring options.
- [architecture/top-down-planning.md](architecture/top-down-planning.md) — recommended planning method and separation-of-concerns structure.
- [architecture/reference-architecture-skeleton.md](architecture/reference-architecture-skeleton.md) — proposed architectural spine for lifecycle, domains, contracts, and topologies.
- [architecture/documentation-toc.md](architecture/documentation-toc.md) — proposed table of contents for the documentation set.
- [architecture/assistant-integration-and-docs-delivery.md](architecture/assistant-integration-and-docs-delivery.md) — proposed MCP assistant surfaces and FastAPI-based docs delivery model.
- [architecture/dev-environment.md](architecture/dev-environment.md) — current Nix shell, Python, Jupyter, and bundled tooling.

## Contracts

- [contracts/index.md](contracts/index.md) — router for all cross-cutting contracts.
- [contracts/security-baseline.md](contracts/security-baseline.md) — identity, secrets, network, access, and audit minimums.
- [contracts/data-lineage-baseline.md](contracts/data-lineage-baseline.md) — dataset and transformation provenance requirements.
- [contracts/experiment-traceability-baseline.md](contracts/experiment-traceability-baseline.md) — required experiment and training metadata.
- [contracts/model-artifact-baseline.md](contracts/model-artifact-baseline.md) — minimum artifact and model-version metadata.
- [contracts/deployment-baseline.md](contracts/deployment-baseline.md) — required deployment metadata and rollback context.
- [contracts/prediction-logging-baseline.md](contracts/prediction-logging-baseline.md) — minimum inference logging requirements.
- [contracts/cost-attribution-baseline.md](contracts/cost-attribution-baseline.md) — required spend attribution metadata.

## Domains

- [domains/index.md](domains/index.md) — router for all bounded domain pages.
- [domains/data-domain.md](domains/data-domain.md) — datasets, schemas, provenance, and transformation lineage.
- [domains/training-domain.md](domains/training-domain.md) — training, experiments, GPUs, and distributed execution.
- [domains/artifact-domain.md](domains/artifact-domain.md) — model packaging, versioning, and promotion.
- [domains/serving-domain.md](domains/serving-domain.md) — local serving plus batch/online inference contracts.
- [domains/infrastructure-domain.md](domains/infrastructure-domain.md) — AWS, Lambda.ai, networking, storage, and env patterns.
- [domains/observability-domain.md](domains/observability-domain.md) — metrics, logs, traces, drift, quality, and alerting.
- [domains/governance-domain.md](domains/governance-domain.md) — approvals, IAM, auditability, and policy boundaries.
- [domains/cost-domain.md](domains/cost-domain.md) — spend attribution, reporting, budgets, and unit economics.

## Topologies

- [topologies/index.md](topologies/index.md) — router for all reference topologies.
- [topologies/local-development-and-single-node-training.md](topologies/local-development-and-single-node-training.md) — local Docker-based iteration and single-node training.
- [topologies/distributed-training-on-lambda-ai.md](topologies/distributed-training-on-lambda-ai.md) — remote distributed training on Lambda.ai.
- [topologies/batch-inference-on-aws-integrated-infrastructure.md](topologies/batch-inference-on-aws-integrated-infrastructure.md) — offline inference with lineage and cost controls.
- [topologies/online-inference-under-production-controls.md](topologies/online-inference-under-production-controls.md) — production online serving with rollout, monitoring, and rollback controls.

## Queries

- [queries/decision-records-and-project-restart.md](queries/decision-records-and-project-restart.md) — why decision records matter and why they are not enough alone.

## Runbooks

- [runbooks/jupyter-and-shell.md](runbooks/jupyter-and-shell.md) — common entry commands and operational notes.

## Decisions

- [decisions/project-scope-and-constraints.md](decisions/project-scope-and-constraints.md) — current purpose, hard constraints, and no-code planning rule.
- [decisions/repository-shape.md](decisions/repository-shape.md) — why this repo is currently implementation-light and what that implies.

## Source summaries

- [sources/flake.nix.md](sources/flake.nix.md) — synthesized summary of the flake definition.
- [sources/flake.lock.md](sources/flake.lock.md) — synthesized summary of flake input pins.
- [sources/gitignore.md](sources/gitignore.md) — synthesized summary of ignored paths and tracking implications.
- [sources/LICENSE.md](sources/LICENSE.md) — synthesized summary of the repository license and its provenance from origin.

## Revision artifacts

- [revisions/2026-05-09-topology-pages.md](revisions/2026-05-09-topology-pages.md) — captures the first pass of reference topology pages.
- [revisions/2026-05-09-domain-pages.md](revisions/2026-05-09-domain-pages.md) — captures the first pass of bounded domain pages.
- [revisions/2026-05-09-decision-records-role.md](revisions/2026-05-09-decision-records-role.md) — captures how decision records should complement the top-down architecture.
- [revisions/2026-05-09-origin-rebase-and-push.md](revisions/2026-05-09-origin-rebase-and-push.md) — captures rebasing onto origin and incorporating the remote license file.
- [revisions/2026-05-09-contract-baselines.md](revisions/2026-05-09-contract-baselines.md) — captures the first cross-cutting contract pages.
- [revisions/2026-05-09-assistant-and-docs-delivery.md](revisions/2026-05-09-assistant-and-docs-delivery.md) — captures the MCP assistant and FastAPI docs-delivery proposals.
- [revisions/2026-05-09-architecture-skeleton-and-toc.md](revisions/2026-05-09-architecture-skeleton-and-toc.md) — captures the first proposed architecture skeleton and documentation TOC.
- [revisions/2026-05-09-planning-direction.md](revisions/2026-05-09-planning-direction.md) — captures the agreed audience, production scope, and top-down planning guidance.
- [revisions/2026-05-09-project-purpose.md](revisions/2026-05-09-project-purpose.md) — captures the agreed project purpose and constraints.
- [revisions/2026-05-09-bootstrap.md](revisions/2026-05-09-bootstrap.md) — initial wiki bootstrap from the existing repository.

## Known gaps

- No application code, notebooks, Docker workflow, or `pyproject.toml` exist yet.
- First-pass topology pages now exist, but they still need formal acceptance and later concrete example mappings.
- The architecture skeleton, documentation TOC, assistant/MCP posture, docs-delivery posture, domain pages, and topology pages are still draft planning artifacts.
- The default monitoring and cost-monitoring choices are still not formally settled.
- `archive/` is intentionally empty until useful material accumulates.
