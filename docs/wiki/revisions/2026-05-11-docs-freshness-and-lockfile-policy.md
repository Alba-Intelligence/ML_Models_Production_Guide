---
updated: 2026-05-11
summary: Added docs freshness test coverage and clarified durable local-only `flake.lock` policy in wiki pages.
read_when:
  - You need to understand how stale docs outputs are prevented
  - You need the current lockfile tracking policy rationale
sources:
  - ../../tests/test_docs_freshness.py
  - ../../.gitignore
  - ../decisions/repository-shape.md
  - ../current-state.md
  - ../overview.md
---

# 2026-05-11 — Docs freshness and lockfile policy hardening

## What changed

- Added `tests/test_docs_freshness.py` to enforce that `_docs/nbs/*.html` is present and not older than corresponding `nbs/*.qmd`.
- Clarified and stabilized lockfile policy: `flake.lock` remains intentionally local-only (gitignored) to avoid noisy churn.
- Updated wiki source summaries and state pages to reflect both behaviors.

## Why

- Prevent stale rendered docs from being mistaken as current source-derived outputs.
- Make lockfile behavior explicit so recurring `nix develop` lock updates are treated as expected local noise rather than ambiguous drift.

## Verification outcome

- The docs freshness test is part of the unit test suite and validates rendered output currency.
