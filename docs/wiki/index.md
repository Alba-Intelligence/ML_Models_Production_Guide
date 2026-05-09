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
  - runbooks/jupyter-and-shell.md
  - decisions/repository-shape.md
  - decisions/project-scope-and-constraints.md
  - sources/flake.nix.md
  - sources/flake.lock.md
  - sources/gitignore.md
---

# Wiki index

## Fast routing

| If you need to…                                                      | Read these pages                                                                                                                                                                                                                             |
| -------------------------------------------------------------------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| Understand what this repository currently is                         | [overview.md](overview.md), [current-state.md](current-state.md)                                                                                                                                                                             |
| Understand the intended end-state architecture and stack             | [architecture/target-system.md](architecture/target-system.md), [decisions/project-scope-and-constraints.md](decisions/project-scope-and-constraints.md)                                                                                     |
| Plan the project top-down without losing separation of concerns      | [architecture/top-down-planning.md](architecture/top-down-planning.md), [architecture/reference-architecture-skeleton.md](architecture/reference-architecture-skeleton.md)                                                                   |
| Review the proposed architecture skeleton                            | [architecture/reference-architecture-skeleton.md](architecture/reference-architecture-skeleton.md), [architecture/target-system.md](architecture/target-system.md)                                                                           |
| Review the proposed documentation structure                          | [architecture/documentation-toc.md](architecture/documentation-toc.md), [architecture/reference-architecture-skeleton.md](architecture/reference-architecture-skeleton.md)                                                                   |
| Review assistant/MCP and docs-delivery proposals                     | [architecture/assistant-integration-and-docs-delivery.md](architecture/assistant-integration-and-docs-delivery.md), [architecture/target-system.md](architecture/target-system.md)                                                           |
| Check whether implementation is allowed yet                          | [decisions/project-scope-and-constraints.md](decisions/project-scope-and-constraints.md), [current-state.md](current-state.md)                                                                                                               |
| Modify the Nix dev shell or toolchain                                | [architecture/dev-environment.md](architecture/dev-environment.md), [sources/flake.nix.md](sources/flake.nix.md)                                                                                                                             |
| Understand pinned upstream dependencies                              | [sources/flake.lock.md](sources/flake.lock.md)                                                                                                                                                                                               |
| Run or debug Jupyter / kernel setup                                  | [runbooks/jupyter-and-shell.md](runbooks/jupyter-and-shell.md), [sources/flake.nix.md](sources/flake.nix.md)                                                                                                                                 |
| Understand git tracking, ignored files, or private-doc conventions   | [sources/gitignore.md](sources/gitignore.md), [current-state.md](current-state.md)                                                                                                                                                           |
| Understand durable repo conventions and why the repo is still sparse | [decisions/repository-shape.md](decisions/repository-shape.md), [current-state.md](current-state.md)                                                                                                                                         |
| See what changed in the wiki recently                                | [log.md](log.md), [revisions/2026-05-09-assistant-and-docs-delivery.md](revisions/2026-05-09-assistant-and-docs-delivery.md), [revisions/2026-05-09-architecture-skeleton-and-toc.md](revisions/2026-05-09-architecture-skeleton-and-toc.md) |

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

## Runbooks

- [runbooks/jupyter-and-shell.md](runbooks/jupyter-and-shell.md) — common entry commands and operational notes.

## Decisions

- [decisions/project-scope-and-constraints.md](decisions/project-scope-and-constraints.md) — current purpose, hard constraints, and no-code planning rule.
- [decisions/repository-shape.md](decisions/repository-shape.md) — why this repo is currently implementation-light and what that implies.

## Source summaries

- [sources/flake.nix.md](sources/flake.nix.md) — synthesized summary of the flake definition.
- [sources/flake.lock.md](sources/flake.lock.md) — synthesized summary of flake input pins.
- [sources/gitignore.md](sources/gitignore.md) — synthesized summary of ignored paths and tracking implications.

## Revision artifacts

- [revisions/2026-05-09-assistant-and-docs-delivery.md](revisions/2026-05-09-assistant-and-docs-delivery.md) — captures the MCP assistant and FastAPI docs-delivery proposals.
- [revisions/2026-05-09-architecture-skeleton-and-toc.md](revisions/2026-05-09-architecture-skeleton-and-toc.md) — captures the first proposed architecture skeleton and documentation TOC.
- [revisions/2026-05-09-planning-direction.md](revisions/2026-05-09-planning-direction.md) — captures the agreed audience, production scope, and top-down planning guidance.
- [revisions/2026-05-09-project-purpose.md](revisions/2026-05-09-project-purpose.md) — captures the agreed project purpose and constraints.
- [revisions/2026-05-09-bootstrap.md](revisions/2026-05-09-bootstrap.md) — initial wiki bootstrap from the existing repository.

## Known gaps

- No application code, notebooks, Docker workflow, or `pyproject.toml` exist yet.
- Drafts now exist for the architecture skeleton, documentation TOC, assistant/MCP posture, and docs-delivery posture, but they are not yet frozen final decisions.
- The default monitoring and cost-monitoring choices are still not formally settled.
- `queries/` and `archive/` are intentionally empty until useful material accumulates.
