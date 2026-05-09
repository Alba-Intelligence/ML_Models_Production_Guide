---
updated: 2026-05-09
summary: Captures the role of decision records as checkpoint memory that complements, but does not replace, the top-down architecture artifacts.
read_when:
  - You need provenance for how decision records should be used
  - You want to know how restartability is being designed into the project
sources:
  - ../architecture/top-down-planning.md
  - ../architecture/documentation-toc.md
  - ../queries/decision-records-and-project-restart.md
---

# Revision: 2026-05-09 decision records role

## Trigger

The user asked whether decision records are the optimal mechanism for preserving the top-down approach and making the project restartable at any time.

## Conclusion captured

- Decision records are **high-value and necessary**.
- They are best treated as the project's **checkpoint memory layer**.
- They should preserve rationale, rejected options, assumptions, and revisit triggers.
- They are **not sufficient on their own**.
- Restartability depends on the combination of:
  - architecture skeleton
  - documentation TOC
  - cross-cutting contracts
  - decision records
  - current-state and log pages

## Wiki pages added or updated

- `docs/wiki/queries/decision-records-and-project-restart.md`
- `docs/wiki/architecture/top-down-planning.md`
- `docs/wiki/architecture/documentation-toc.md`
- `docs/wiki/index.md`
- `docs/wiki/log.md`
