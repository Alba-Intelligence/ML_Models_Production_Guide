---
updated: 2026-05-09
summary: Captures newly agreed audience, delivery depth, full production scope, and top-down planning guidance.
read_when:
  - You need provenance for the current planning direction
  - You want to know why the project is being structured top-down
sources:
  - ../architecture/target-system.md
  - ../architecture/top-down-planning.md
  - ../decisions/project-scope-and-constraints.md
---

# Revision: 2026-05-09 planning direction

## Trigger

The user clarified the target audience, delivery depth, production scope, lineage scope, and preferred top-down planning direction.

## Decisions captured

- Primary audience is **ML engineers in hedge funds**.
- The reference should include **runnable end-to-end reference patterns**, not just architecture notes.
- The project must cover **distributed training**, **batch inference**, and **online inference**.
- AWS guidance should use **full production patterns**.
- Lineage scope covers **datasets, features/transformations, experiments, model artifacts, model versions, deployments, and operational runs where relevant**.
- Docker remains the required reproducible development artifact.
- Nix may assist in generating or supporting Docker workflows, but Docker files must exist directly.

## Planning guidance captured

The recommended top-down planning order is:

1. mission and audience
2. lifecycle map
3. architectural domains
4. cross-cutting requirements
5. contracts between domains
6. reference topologies
7. documentation tree
8. code-example inventory
9. only then implementation

## Wiki pages added

- `docs/wiki/architecture/top-down-planning.md`

## Wiki pages updated

- `docs/wiki/architecture/target-system.md`
- `docs/wiki/decisions/project-scope-and-constraints.md`
- `docs/wiki/index.md`
- `docs/wiki/log.md`
