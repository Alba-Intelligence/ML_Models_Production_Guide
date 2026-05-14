# AGENTS.md

This repository uses a **living Karpathy-style wiki** in `docs/wiki` as its long-term memory layer.

## Prime directive

**If you change the repository or learn something durable about it, update `docs/wiki` before you finish.**

Work is not complete until the wiki reflects the new reality.

## What the wiki is for

The wiki is the compact, curated knowledge layer that lets future agents avoid re-reading the entire repository every session.

- Repository files are the canonical raw sources.
- `docs/wiki` is the synthesized layer.
- Agents should read the wiki first, then drill into raw files only when needed.

## Required workflow

### 1) At the start of a task

Read:

1. `docs/wiki/index.md`
2. Only the routed pages relevant to the task
3. Raw repo files only as needed

### 2) During the task

When you discover durable facts, decisions, commands, constraints, or open questions, fold them into the wiki instead of leaving them trapped in the session.

If the user has put the project into a planning/specification phase, **do not write implementation code** until the user explicitly confirms the specs are understood well enough to proceed. In that phase, prefer wiki/spec updates, tradeoff analysis, and clarification questions.

### 3) Before the final response

If anything substantive changed, update all relevant parts of the wiki:

- relevant page(s) under `docs/wiki/sources/`
- relevant topical page(s) under `docs/wiki/architecture/`, `docs/wiki/runbooks/`, or `docs/wiki/decisions/`
- `docs/wiki/current-state.md`
- `docs/wiki/index.md` if pages were added, removed, or repurposed
- `docs/wiki/revisions/YYYY-MM-DD-*.md` for non-trivial changes
- `docs/wiki/log.md` with an append-only entry

## Wiki structure

- `docs/wiki/index.md` — primary router and catalog
- `docs/wiki/overview.md` — high-level project summary
- `docs/wiki/current-state.md` — current repo snapshot, gaps, and near-term reality
- `docs/wiki/architecture/` — durable technical structure
- `docs/wiki/runbooks/` — commands and operational steps
- `docs/wiki/decisions/` — durable decisions and rationale
- `docs/wiki/sources/` — one synthesized page per important raw source file
- `docs/wiki/plans/` — active project plans and tracking documents
- `docs/wiki/revisions/` — artifacts describing significant wiki-affecting updates
- `docs/wiki/queries/` — reusable answers worth keeping
- `docs/wiki/archive/` — superseded or demoted pages

## Page conventions

Prefer compact, high-signal pages.

Each active page should ideally include:

- what it is for
- when it should be read
- links to upstream source files or wiki pages
- concise facts, not raw dumps
- explicit uncertainty where needed
- progress tracking for active plans
- completion status and next steps
- risk assessment and dependencies

## Special Instructions for Active Plans

When working on active plans (found in `docs/wiki/plans/`):

1. **Read the full plan first** before starting work
2. **Update progress** as tasks are completed
3. **Report new risks or gaps** discovered during work
4. **Check dependencies** before starting new tasks
5. **Update completion status** when milestones are reached
6. **Document any deviations** from the original plan
7. **Archive the plan** when completed

### Plan Tracking Format

Active plans should include:

- Clear status indicators (🟢 COMPLETE, 🟡 IN PROGRESS, ⏳ PENDING, ❌ BLOCKED)
- Progress checklist with completion percentages
- Risk assessment with mitigation strategies
- Dependencies and blocking issues
- Next steps and milestones
- Success criteria and quality metrics

## Current Active Plans

### 🟡 Documentation Restructuring Plan

- **Location**: `docs/wiki/plans/documentation-restructuring-plan.md`
- **Goal**: Split documentation into Tutorial and Reference sections
- **Status**: Phase 2 (Content Restructuring) in progress
- **Next**: Tutorial Section Creation
- **Owner**: Emmanuel
- **Priority**: High
- **Deadline**: Within 2 weeks

This plan addresses critical issues with unclear terminology (EX-01, EX-02, EX-03) and mixed content types that confuse users.

## Maintenance rules

- Do not duplicate large raw file contents into the wiki.
- Summarize and link back to canonical files.
- Prefer updating an existing page over creating a near-duplicate.
- Keep cross-links and index entries in sync.
- Keep `docs/wiki/current-state.md` honest.
- If a change affects commands, dependencies, behavior, architecture, or project shape, the wiki must change too.
- If a task produces a reusable explanation, consider saving it under `docs/wiki/queries/`.

## Scope rules

- Use the active wiki for current, high-value knowledge.
- Move stale or superseded material to `docs/wiki/archive/` instead of deleting context blindly.
- External sources should only be added if the user asks or if they are necessary for durable project knowledge.

## Quality bar

The wiki should help a future agent answer:

- What is this repo?
- What exists right now?
- How do I run it?
- What are the important constraints?
- What changed recently?
- Which raw files matter for this task?

If the wiki cannot answer those quickly, improve it.
