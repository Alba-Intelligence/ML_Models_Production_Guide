---
updated: 2026-05-09
summary: Why decision records are valuable for a restartable project, and why they should complement rather than replace architecture, contracts, and TOC artifacts.
read_when:
  - You are deciding how to make the project restartable after long pauses
  - You are deciding how much weight to give decision records in the planning system
sources:
  - ../architecture/top-down-planning.md
  - ../architecture/documentation-toc.md
  - ../architecture/reference-architecture-skeleton.md
  - ../contracts/index.md
---

# Decision records and project restartability

## Short answer

**Yes — decision records are highly valuable, but they are not sufficient on their own.**

They are best used as the project's **memory checkpoints**, not as the primary architectural backbone.

## Why they help

Decision records are excellent for preserving:

- why a choice was made
- what alternatives were rejected
- what assumptions were in force
- what would trigger revisiting the choice

That makes them extremely useful when:

- restarting after a long pause
- onboarding a new contributor or agent
- re-evaluating earlier tradeoffs
- explaining why the project is shaped the way it is

## Why they are not enough by themselves

A pile of decision records does **not** automatically give you:

- the current system structure
- the canonical lifecycle
- the domain boundaries
- the cross-cutting invariants
- the current documentation map

Those belong in:

- the **reference architecture skeleton**
- the **documentation TOC**
- the **cross-cutting contracts**
- the **current-state** and **index** pages

## Best role for decision records

Decision records should sit **under** the top-down structure and do four jobs:

1. preserve why major decisions were made
2. record when a draft became accepted or rejected
3. mark boundaries where future contributors should not casually improvise
4. make project restart safer after time passes

## Recommended restart bundle

If the project had to be restarted at any time, the minimum high-value bundle would be:

1. `docs/wiki/index.md`
2. `docs/wiki/current-state.md`
3. `docs/wiki/architecture/reference-architecture-skeleton.md`
4. `docs/wiki/architecture/documentation-toc.md`
5. `docs/wiki/contracts/index.md`
6. key contract pages
7. decision records for major choices
8. `docs/wiki/log.md`

## Recommendation

Use decision records as a **stabilizer layer**:

- architecture tells you **what the system is**
- contracts tell you **what must always be true**
- decision records tell you **why it ended up that way**

That combination is much better for restartability than decision records alone.
