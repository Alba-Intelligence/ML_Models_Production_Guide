---
updated: 2026-05-09
summary: How this living wiki works and how agents should use it.
read_when:
  - You are new to the repository
  - You want to understand the wiki pattern
  - You are about to add or reorganize wiki pages
sources:
  - ../../AGENTS.md
---

# docs/wiki

This is the repository's **Karpathy-style living wiki**: a compact, persistent markdown knowledge layer maintained by the agent.

## Why it exists

Instead of forcing future sessions to repeatedly reread the whole repo, the agent compiles durable knowledge into a small set of linked pages.

The intended flow is:

1. Read `index.md`
2. Open only the routed pages needed for the task
3. Read raw repo files only when necessary
4. Push durable findings back into the wiki before finishing

## Design principles

- **Repository files are the source of truth.** The wiki summarizes them.
- **Keep pages short and linked.** The wiki should reduce token usage, not recreate the entire repo.
- **Prefer synthesis over transcripts.** Capture facts, constraints, decisions, commands, and open questions.
- **Keep it current.** A stale wiki is worse than no wiki.

## Current layout

- `index.md` — router and catalog
- `overview.md` — high-level summary
- `current-state.md` — what is true right now
- `architecture/` — durable technical structure
- `runbooks/` — operational commands and workflows
- `decisions/` — persistent decisions and rationale
- `sources/` — per-file summaries of important raw files
- `revisions/` — significant update artifacts
- `queries/` — reusable answers
- `archive/` — demoted or superseded pages

## Update contract

When a change is made that affects repo behavior or understanding, update:

- the relevant source summary page(s)
- the relevant topical page(s)
- `current-state.md`
- `index.md` if navigation changed
- `log.md`
- a revision artifact for non-trivial changes

For the operational rules, see [../../AGENTS.md](../../AGENTS.md).
