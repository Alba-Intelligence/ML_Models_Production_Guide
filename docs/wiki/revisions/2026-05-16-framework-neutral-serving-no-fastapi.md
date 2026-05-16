---
title: "Revision: 2026-05-16 framework-neutral serving posture"
summary: "Removed framework-specific serving mentions from the active docs and rewrote serving examples and security guidance to stay framework-neutral."
author: "Emmanuel"
---

# 2026-05-16 — Framework-neutral serving posture

## What changed

- Rewrote active serving examples in the QMD docs to avoid framework-specific imports, decorators, and terminology.
- Updated the security baseline to refer to the same API framework generically.
- Revised the nbdev framework decision note to speak about an HTTP-serving stack.
- Updated the current-state snapshot to explicitly record a framework-neutral serving posture.
- Removed framework-specific serving references from the structural gap analysis and wiki index.

## Why it matters

The reference stack is now explicitly framework-neutral on the serving layer. This keeps the docs aligned with the user's requirement to avoid a specific serving framework in the reference stack.

## Touched files

- `nbs/02_02-model_development.qmd`
- `nbs/reference/01_Implementation_Patterns.qmd`
- `nbs/tutorials/05_Advanced_Scenarios.qmd`
- `nbs/tutorials/06_Migration_Guide.qmd`
- `docs/wiki/contracts/security-baseline.md`
- `docs/wiki/decisions/nbdev-framework-decision.md`
- `docs/wiki/gaps/software-stack-gaps.md`
- `docs/wiki/index.md`
- `docs/wiki/current-state.md`
- `docs/wiki/revisions/2026-05-16-framework-neutral-serving-no-fastapi.md`
