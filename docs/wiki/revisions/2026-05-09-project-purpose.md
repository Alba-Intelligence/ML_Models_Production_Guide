---
updated: 2026-05-09
summary: Captures the newly defined project purpose, hard constraints, and planning-phase rules.
read_when:
  - You need provenance for the current project direction
  - You are deciding whether implementation work is allowed yet
sources:
  - ../architecture/target-system.md
  - ../decisions/project-scope-and-constraints.md
---

# Revision: 2026-05-09 project purpose

## Trigger

The user clarified the intended purpose and non-negotiable constraints for the project.

## Key decisions captured

- The project is for **extensive reference documentation plus code examples**.
- The content should cover **all steps from model development to distributed production**.
- The project should be **Python only to the maximum practical extent**.
- The supported platform is **Linux only**.
- **PyTorch only** is in scope for models and training.
- **GPU support** is required.
- **FastAPI** is the local development / local serving framework.
- **MLflow** is part of the core stack.
- **python-terraform** is part of the infrastructure story.
- **Lambda.ai** is the distributed compute platform in scope.
- **AWS** is the tooling / production platform in scope.
- **Docker** is the reproducible development requirement.
- **Security**, **data lineage**, **traceability**, and **reproducibility** are permanent requirements.
- No implementation code should be written until the user and agent are both comfortable that the specifications are understood.

## Wiki pages added

- `docs/wiki/architecture/target-system.md`
- `docs/wiki/decisions/project-scope-and-constraints.md`

## Wiki pages updated

- `AGENTS.md`
- `docs/wiki/index.md`
- `docs/wiki/overview.md`
- `docs/wiki/current-state.md`
- `docs/wiki/decisions/repository-shape.md`
- `docs/wiki/log.md`

## Open questions remaining

- What exact table of contents should organize the reference?
- Which monitoring stack should be the default recommended path?
- Which cost-monitoring stack should be the default recommended path?
- How far should AWS deployment examples go?
- What is the long-term relationship between Docker and the current Nix setup?
- What is the priority order among training, batch inference, online inference, and distributed production topics?
