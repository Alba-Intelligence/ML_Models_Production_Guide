---
summary: Migrated active architecture diagrams and contract language from Mermaid to D2.
updated: 2026-05-12
---

# Revision: 2026-05-12 D2 diagram migration

## Why

The active docs stack required a full move from Mermaid to D2 for diagram authoring.

## What changed

1. Replaced Mermaid diagram blocks with D2 blocks in active Quarto docs:
   - `nbs/01_platform_narrative.qmd`
   - `nbs/15_aws_emulator.qmd`
   - `nbs/16_terranix_infra.qmd`
2. Converted the active wiki architecture interaction graph to D2 syntax:
   - `docs/wiki/architecture/full-system-interaction-analysis.md`
3. Updated the distilled Allium documentation contract from Mermaid-specific to D2-specific fields and guarantees:
   - `specs/ml-deploy-reference-repo.allium`
4. Updated propagated documentation-series test expectations to require a D2 block in the platform narrative:
   - `tests/test_documentation_series_contracts.py`
5. Updated active wiki narrative pages to describe D2 as the diagram standard:
   - `docs/wiki/current-state.md`
   - `docs/wiki/overview.md`
   - `docs/wiki/architecture/assistant-integration-and-docs-delivery.md`
   - `docs/wiki/architecture/target-system.md`
   - `docs/wiki/decisions/nbdev-framework-decision.md`
   - `docs/wiki/sources/nbs.01_platform_narrative.qmd.md`

## Outcome

Active documentation, specification language, and propagated tests now align on D2 as the canonical diagram format.
