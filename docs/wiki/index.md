---
updated: 2026-05-11
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
  - architecture/notebook-repository-web-ui.md
  - architecture/webui-backend-contract.md
  - architecture/example-matrix.md
  - architecture/first-vertical-slice.md
  - architecture/distilled-allium-spec.md
  - contracts/index.md
  - domains/index.md
  - topologies/index.md
  - runbooks/jupyter-and-shell.md
  - runbooks/mlflow-tracking-postgres-s3-parity.md
  - decisions/index.md
  - decisions/repository-shape.md
  - decisions/project-scope-and-constraints.md
  - decisions/monitoring-stack-decision.md
  - decisions/cost-monitoring-stack-decision.md
  - decisions/docker-nix-boundary-decision.md
  - decisions/mcp-default-scope-decision.md
  - decisions/documentation-delivery-decision.md
  - decisions/notebook-intake-validation-and-approval.md
  - sources/flake.nix.md
  - sources/devenv.nix.md
  - sources/flake.lock.md
  - sources/gitignore.md
  - sources/LICENSE.md
  - sources/README.md
  - sources/ml-deploy-reference-repo.allium.md
  - sources/ml_deploy.vertical_slice.py.md
  - sources/nbs.06_vertical_slice.ipynb.md
  - sources/ml_deploy.webui_contracts.py.md
  - sources/ml_deploy.execution_backends.py.md
  - sources/ml_deploy.mlflow_parity.py.md
  - sources/ml_deploy.notebook_intake.py.md
  - sources/ml_deploy.terraform_bootstrap.py.md
  - sources/nbs.07_mlflow_parity.ipynb.md
  - sources/nbs.08_execution_backends.ipynb.md
  - sources/nbs.09_notebook_intake.ipynb.md
  - sources/nbs.10_terraform_bootstrap.ipynb.md
  - sources/nbs.05_webui_contracts.ipynb.md
  - sources/tests.test_vertical_slice.py.md
  - sources/tests.test_webui_contracts.py.md
  - sources/scripts.finalize-task.sh.md
  - revisions/2026-05-10-distilled-allium-spec.md
  - revisions/2026-05-10-allium-cli-build-fix.md
  - revisions/2026-05-10-allium-cli-latest-version.md
  - revisions/2026-05-10-uv2nix-dev-shell-fix.md
  - revisions/2026-05-10-architecture-writeup-ratification.md
  - revisions/2026-05-10-first-vertical-slice-implementation.md
  - revisions/2026-05-10-platform-requirements-alignment.md
  - revisions/2026-05-10-webui-contract-and-mlflow-parity.md
  - revisions/2026-05-10-nbdev-webui-contract-translation.md
  - revisions/2026-05-10-nbdev-vertical-slice-translation.md
  - revisions/2026-05-11-runtime-adapters-and-bootstrap.md
  - revisions/2026-05-11-nbdev-runtime-modules-translation.md
  - revisions/2026-05-11-end-of-task-docs-finalization.md
  - revisions/2026-05-11-readme-newcomer-onboarding.md
  - revisions/2026-05-11-quarto-shell-packages.md
  - revisions/2026-05-11-spec-quality-reset-and-elicitation.md
---

# Wiki index

## Fast routing

| If you need to…                                                      | Read these pages                                                                                                                                                                                                                                                     |
| -------------------------------------------------------------------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| Understand what this repository currently is                         | [overview.md](overview.md), [current-state.md](current-state.md)                                                                                                                                                                                                     |
| Onboard quickly as a newcomer                                        | [../../README.md](../../README.md), [current-state.md](current-state.md), [architecture/target-system.md](architecture/target-system.md) |
| Understand the intended end-state architecture and stack             | [architecture/target-system.md](architecture/target-system.md), [decisions/project-scope-and-constraints.md](decisions/project-scope-and-constraints.md)                                                                                                             |
| Plan the project top-down without losing separation of concerns      | [architecture/top-down-planning.md](architecture/top-down-planning.md), [architecture/reference-architecture-skeleton.md](architecture/reference-architecture-skeleton.md)                                                                                           |
| Review the ratified architecture skeleton                            | [architecture/reference-architecture-skeleton.md](architecture/reference-architecture-skeleton.md), [architecture/target-system.md](architecture/target-system.md)                                                                                                   |
| Review the ratified documentation structure                          | [architecture/documentation-toc.md](architecture/documentation-toc.md), [architecture/reference-architecture-skeleton.md](architecture/reference-architecture-skeleton.md)                                                                                           |
| Review assistant/MCP and docs-delivery proposals                     | [architecture/assistant-integration-and-docs-delivery.md](architecture/assistant-integration-and-docs-delivery.md), [architecture/target-system.md](architecture/target-system.md)                                                                                   |
| Review the cross-cutting contracts                                   | [contracts/index.md](contracts/index.md), [architecture/reference-architecture-skeleton.md](architecture/reference-architecture-skeleton.md)                                                                                                                         |
| Review the bounded domain pages                                      | [domains/index.md](domains/index.md), [architecture/reference-architecture-skeleton.md](architecture/reference-architecture-skeleton.md)                                                                                                                             |
| Review the reference topologies                                      | [topologies/index.md](topologies/index.md), [architecture/reference-architecture-skeleton.md](architecture/reference-architecture-skeleton.md)                                                                                                                       |
| Review accepted default stack decisions                              | [decisions/monitoring-stack-decision.md](decisions/monitoring-stack-decision.md), [decisions/cost-monitoring-stack-decision.md](decisions/cost-monitoring-stack-decision.md), [decisions/docker-nix-boundary-decision.md](decisions/docker-nix-boundary-decision.md) |
| Review latest platform requirements alignment                        | [decisions/project-scope-and-constraints.md](decisions/project-scope-and-constraints.md), [architecture/target-system.md](architecture/target-system.md), [revisions/2026-05-10-platform-requirements-alignment.md](revisions/2026-05-10-platform-requirements-alignment.md) |
| Review executable Web UI backend contracts                           | [architecture/webui-backend-contract.md](architecture/webui-backend-contract.md), [sources/ml_deploy.webui_contracts.py.md](sources/ml_deploy.webui_contracts.py.md), [sources/tests.test_webui_contracts.py.md](sources/tests.test_webui_contracts.py.md) |
| Review runtime adapter scaffolding                                    | [sources/ml_deploy.execution_backends.py.md](sources/ml_deploy.execution_backends.py.md), [sources/ml_deploy.notebook_intake.py.md](sources/ml_deploy.notebook_intake.py.md), [sources/ml_deploy.mlflow_parity.py.md](sources/ml_deploy.mlflow_parity.py.md) |
| Edit runtime helpers in nbdev workflow                                | [sources/nbs.07_mlflow_parity.ipynb.md](sources/nbs.07_mlflow_parity.ipynb.md), [sources/nbs.08_execution_backends.ipynb.md](sources/nbs.08_execution_backends.ipynb.md), [sources/nbs.09_notebook_intake.ipynb.md](sources/nbs.09_notebook_intake.ipynb.md), [sources/nbs.10_terraform_bootstrap.ipynb.md](sources/nbs.10_terraform_bootstrap.ipynb.md) |
| Edit Web UI contracts in nbdev workflow                              | [sources/nbs.05_webui_contracts.ipynb.md](sources/nbs.05_webui_contracts.ipynb.md), [sources/ml_deploy.webui_contracts.py.md](sources/ml_deploy.webui_contracts.py.md) |
| Review the planned example inventory                                 | [architecture/example-matrix.md](architecture/example-matrix.md), [topologies/index.md](topologies/index.md)                                                                                                                                                         |
| Start the first implementation-aligned architecture slice            | [architecture/first-vertical-slice.md](architecture/first-vertical-slice.md), [architecture/example-matrix.md](architecture/example-matrix.md), [contracts/index.md](contracts/index.md)                                                                            |
| Inspect concrete local slice implementation details                   | [sources/ml_deploy.vertical_slice.py.md](sources/ml_deploy.vertical_slice.py.md), [sources/tests.test_vertical_slice.py.md](sources/tests.test_vertical_slice.py.md)                                                                                                  |
| Edit vertical-slice implementation in nbdev workflow                  | [sources/nbs.06_vertical_slice.ipynb.md](sources/nbs.06_vertical_slice.ipynb.md), [sources/ml_deploy.vertical_slice.py.md](sources/ml_deploy.vertical_slice.py.md) |
| Decide how much weight to give decision records                      | [queries/decision-records-and-project-restart.md](queries/decision-records-and-project-restart.md), [architecture/top-down-planning.md](architecture/top-down-planning.md)                                                                                           |
| Check whether implementation is allowed yet                          | [decisions/project-scope-and-constraints.md](decisions/project-scope-and-constraints.md), [current-state.md](current-state.md)                                                                                                                                       |
| Modify the Nix dev shell or toolchain                                | [architecture/dev-environment.md](architecture/dev-environment.md), [sources/flake.nix.md](sources/flake.nix.md)                                                                                                                                                     |
| Understand pinned upstream dependencies                              | [sources/flake.lock.md](sources/flake.lock.md)                                                                                                                                                                                                                       |
| Understand repository licensing posture                              | [sources/LICENSE.md](sources/LICENSE.md), [overview.md](overview.md)                                                                                                                                                                                                 |
| Understand the distilled repository behavior spec                    | [architecture/distilled-allium-spec.md](architecture/distilled-allium-spec.md), [sources/ml-deploy-reference-repo.allium.md](sources/ml-deploy-reference-repo.allium.md)                                                                                             |
| Run or debug Jupyter / kernel setup                                  | [runbooks/jupyter-and-shell.md](runbooks/jupyter-and-shell.md), [sources/flake.nix.md](sources/flake.nix.md)                                                                                                                                                         |
| Finalize a task with publishable docs                                | [runbooks/jupyter-and-shell.md](runbooks/jupyter-and-shell.md), [sources/scripts.finalize-task.sh.md](sources/scripts.finalize-task.sh.md) |
| Understand git tracking, ignored files, or private-doc conventions   | [sources/gitignore.md](sources/gitignore.md), [current-state.md](current-state.md)                                                                                                                                                                                   |
| Understand durable repo conventions and why the repo is still sparse | [decisions/repository-shape.md](decisions/repository-shape.md), [current-state.md](current-state.md)                                                                                                                                                                 |
| See what changed in the wiki recently                                | [log.md](log.md), [revisions/2026-05-10-allium-cli-latest-version.md](revisions/2026-05-10-allium-cli-latest-version.md), [revisions/2026-05-10-uv2nix-dev-shell-fix.md](revisions/2026-05-10-uv2nix-dev-shell-fix.md)                                                 |

## Core pages

- [README.md](README.md) — how this living wiki works.
- [overview.md](overview.md) — high-level project summary.
- [current-state.md](current-state.md) — honest snapshot of the repository today.
- [log.md](log.md) — append-only change log for the wiki.

## Architecture

- [architecture/target-system.md](architecture/target-system.md) — intended end-state scope, audience, stack, and monitoring options.
- [architecture/top-down-planning.md](architecture/top-down-planning.md) — recommended planning method and separation-of-concerns structure.
- [architecture/reference-architecture-skeleton.md](architecture/reference-architecture-skeleton.md) — ratified architectural spine for lifecycle, domains, contracts, and topologies.
- [architecture/documentation-toc.md](architecture/documentation-toc.md) — ratified table of contents for the documentation set.
- [architecture/assistant-integration-and-docs-delivery.md](architecture/assistant-integration-and-docs-delivery.md) — accepted MCP defaults plus docs delivery guidance.
- [architecture/notebook-repository-web-ui.md](architecture/notebook-repository-web-ui.md) — centralized interface for triggering notebook executions across environments while keeping notebooks immutable.
- [architecture/webui-backend-contract.md](architecture/webui-backend-contract.md) — executable request/response contract for Web UI backend run triggering and MLflow-linked status.
- [architecture/example-matrix.md](architecture/example-matrix.md) — proposed example inventory mapped to lifecycle, domains, contracts, and topologies.
- [architecture/first-vertical-slice.md](architecture/first-vertical-slice.md) — concrete first end-to-end architecture slice with explicit I/O and success criteria.
- [architecture/dev-environment.md](architecture/dev-environment.md) — current Nix shell, Python, Jupyter, and bundled tooling.
- [architecture/distilled-allium-spec.md](architecture/distilled-allium-spec.md) — repository-wide distilled Allium behavior baseline.

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
- [queries/spec-quality-elicitation-session-01.md](queries/spec-quality-elicitation-session-01.md) — prioritized clarification questions to improve specification quality before more implementation.

## Runbooks

- [runbooks/jupyter-and-shell.md](runbooks/jupyter-and-shell.md) — common entry commands and operational notes.
- [runbooks/mlflow-tracking-postgres-s3-parity.md](runbooks/mlflow-tracking-postgres-s3-parity.md) — local/production MLflow storage parity posture.

## Decisions

- [decisions/index.md](decisions/index.md) — router for durable architectural and stack decisions.
- [decisions/project-scope-and-constraints.md](decisions/project-scope-and-constraints.md) — current purpose, hard constraints, and working-mode expectations.
- [decisions/repository-shape.md](decisions/repository-shape.md) — why this repo is currently implementation-light and what that implies.
- [decisions/monitoring-stack-decision.md](decisions/monitoring-stack-decision.md) — accepted default monitoring stack.
- [decisions/cost-monitoring-stack-decision.md](decisions/cost-monitoring-stack-decision.md) — accepted default cost stack.
- [decisions/docker-nix-boundary-decision.md](decisions/docker-nix-boundary-decision.md) — accepted Docker/Nix boundary.
- [decisions/mcp-default-scope-decision.md](decisions/mcp-default-scope-decision.md) — accepted default MCP scope.
- [decisions/documentation-delivery-decision.md](decisions/documentation-delivery-decision.md) — accepted docs-delivery posture.
- [decisions/notebook-intake-validation-and-approval.md](decisions/notebook-intake-validation-and-approval.md) — accepted intake gates for immutable executable notebook revisions.

## Source summaries

- [sources/flake.nix.md](sources/flake.nix.md) — synthesized summary of the flake definition.
- [sources/devenv.nix.md](sources/devenv.nix.md) — synthesized summary of the auxiliary devenv shell definition.
- [sources/flake.lock.md](sources/flake.lock.md) — synthesized summary of flake input pins.
- [sources/gitignore.md](sources/gitignore.md) — synthesized summary of ignored paths and tracking implications.
- [sources/LICENSE.md](sources/LICENSE.md) — synthesized summary of the repository license and its provenance from origin.
- [sources/README.md](sources/README.md) — synthesized summary of root newcomer-onboarding guidance.
- [sources/ml-deploy-reference-repo.allium.md](sources/ml-deploy-reference-repo.allium.md) — synthesized summary of the distilled repository-level Allium spec.
- [sources/ml_deploy.vertical_slice.py.md](sources/ml_deploy.vertical_slice.py.md) — synthesized summary of the implemented local vertical-slice module.
- [sources/nbs.06_vertical_slice.ipynb.md](sources/nbs.06_vertical_slice.ipynb.md) — synthesized summary of nbdev notebook source-of-truth for vertical-slice implementation.
- [sources/ml_deploy.webui_contracts.py.md](sources/ml_deploy.webui_contracts.py.md) — synthesized summary of Web UI execution/run-visibility contract helpers.
- [sources/ml_deploy.execution_backends.py.md](sources/ml_deploy.execution_backends.py.md) — synthesized summary of local/slurm/k8s execution adapter mappings.
- [sources/ml_deploy.mlflow_parity.py.md](sources/ml_deploy.mlflow_parity.py.md) — synthesized summary of local MLflow parity stack helpers.
- [sources/ml_deploy.notebook_intake.py.md](sources/ml_deploy.notebook_intake.py.md) — synthesized summary of notebook intake validation gates.
- [sources/ml_deploy.terraform_bootstrap.py.md](sources/ml_deploy.terraform_bootstrap.py.md) — synthesized summary of Python-first Terraform bootstrap helpers.
- [sources/nbs.07_mlflow_parity.ipynb.md](sources/nbs.07_mlflow_parity.ipynb.md) — synthesized summary of nbdev source-of-truth for MLflow parity helpers.
- [sources/nbs.08_execution_backends.ipynb.md](sources/nbs.08_execution_backends.ipynb.md) — synthesized summary of nbdev source-of-truth for execution adapters.
- [sources/nbs.09_notebook_intake.ipynb.md](sources/nbs.09_notebook_intake.ipynb.md) — synthesized summary of nbdev source-of-truth for notebook intake gates.
- [sources/nbs.10_terraform_bootstrap.ipynb.md](sources/nbs.10_terraform_bootstrap.ipynb.md) — synthesized summary of nbdev source-of-truth for Terraform bootstrap helpers.
- [sources/nbs.05_webui_contracts.ipynb.md](sources/nbs.05_webui_contracts.ipynb.md) — synthesized summary of nbdev notebook source-of-truth for Web UI contracts.
- [sources/tests.test_vertical_slice.py.md](sources/tests.test_vertical_slice.py.md) — synthesized summary of vertical-slice behavior tests.
- [sources/tests.test_webui_contracts.py.md](sources/tests.test_webui_contracts.py.md) — synthesized summary of Web UI contract behavior tests.
- [sources/scripts.finalize-task.sh.md](sources/scripts.finalize-task.sh.md) — synthesized summary of the canonical end-of-task export/docs/tests command.

## Revision artifacts

- [revisions/2026-05-10-distilled-allium-spec.md](revisions/2026-05-10-distilled-allium-spec.md) — captures the first repository-wide Allium distillation baseline.
- [revisions/2026-05-10-allium-cli-build-fix.md](revisions/2026-05-10-allium-cli-build-fix.md) — captures the flake fix for allium-cli build reliability.
- [revisions/2026-05-10-allium-cli-latest-version.md](revisions/2026-05-10-allium-cli-latest-version.md) — captures the move from pinned allium-cli packaging to latest-version runtime resolution.
- [revisions/2026-05-10-uv2nix-dev-shell-fix.md](revisions/2026-05-10-uv2nix-dev-shell-fix.md) — captures the uv2nix/dev-shell change that unblocks `nix develop`.
- [revisions/2026-05-10-architecture-writeup-ratification.md](revisions/2026-05-10-architecture-writeup-ratification.md) — captures ratification of architecture/TOC, topology flow specs, and first vertical-slice definition.
- [revisions/2026-05-10-first-vertical-slice-implementation.md](revisions/2026-05-10-first-vertical-slice-implementation.md) — captures code implementation of the first local vertical slice and test coverage.
- [revisions/2026-05-10-platform-requirements-alignment.md](revisions/2026-05-10-platform-requirements-alignment.md) — captures alignment to MLflow PostgreSQL/S3, Lambda.ai Slurm, AWS Kubernetes, notebook Web UI, and Python-managed Terraform requirements.
- [revisions/2026-05-10-webui-contract-and-mlflow-parity.md](revisions/2026-05-10-webui-contract-and-mlflow-parity.md) — captures executable Web UI backend contracts plus intake/MLflow parity artifacts.
- [revisions/2026-05-10-nbdev-webui-contract-translation.md](revisions/2026-05-10-nbdev-webui-contract-translation.md) — captures migration of Web UI contract code into nbdev notebook source-of-truth.
- [revisions/2026-05-10-nbdev-vertical-slice-translation.md](revisions/2026-05-10-nbdev-vertical-slice-translation.md) — captures migration of vertical-slice implementation into nbdev notebook source-of-truth.
- [revisions/2026-05-11-runtime-adapters-and-bootstrap.md](revisions/2026-05-11-runtime-adapters-and-bootstrap.md) — captures runtime adapter, intake gate, parity helper, and Terraform bootstrap implementation pass.
- [revisions/2026-05-11-nbdev-runtime-modules-translation.md](revisions/2026-05-11-nbdev-runtime-modules-translation.md) — captures migration of runtime helper modules into nbdev notebook source-of-truth.
- [revisions/2026-05-11-end-of-task-docs-finalization.md](revisions/2026-05-11-end-of-task-docs-finalization.md) — captures the standard publishable-docs finalization workflow addition.
- [revisions/2026-05-11-readme-newcomer-onboarding.md](revisions/2026-05-11-readme-newcomer-onboarding.md) — captures improvements to explicit newcomer onboarding in root README.
- [revisions/2026-05-11-quarto-shell-packages.md](revisions/2026-05-11-quarto-shell-packages.md) — captures explicit Quarto packaging in flake/devenv shells and synchronized wiki coverage.
- [revisions/2026-05-11-spec-quality-reset-and-elicitation.md](revisions/2026-05-11-spec-quality-reset-and-elicitation.md) — captures spec-quality-first reset, clarified open questions, and tightened implementation gating in the distilled spec.
- [revisions/2026-05-09-example-matrix.md](revisions/2026-05-09-example-matrix.md) — captures the first architecture-aligned example inventory.
- [revisions/2026-05-09-default-stack-decisions.md](revisions/2026-05-09-default-stack-decisions.md) — captures the accepted default stack and boundary decisions.
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

- Docker-based reproducible workflow is a hard requirement but is not yet implemented in-repo.
- A distilled `.allium` baseline exists, but it still reflects repository posture more than implemented ML runtime behavior.
- The first local vertical slice is implemented, but Docker-first execution and multi-topology expansion remain pending.
- Contract checks exist for the local slice, but generalized validation hooks are not implemented yet.
- `archive/` is intentionally empty until useful material accumulates.
