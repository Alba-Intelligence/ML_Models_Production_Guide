---
summary: "REVERTED: D2 diagram migration (Quarto lacks native D2 support—diagrams did not render)"
updated: 2026-05-12
status: reverted
---

# Revision: 2026-05-12 D2 diagram migration [REVERTED]

## Why (original intent)

The active docs stack was planned to move from Mermaid to D2 for diagram authoring.

## What happened

This migration was reverted immediately after validation because **Quarto has no native D2 support**. Unlike Mermaid (which Quarto handles natively via `{mermaid}` fence syntax), D2 blocks are treated as plain code blocks and do not render as diagrams. This defeated the purpose of the migration.

## Resolution

All changes were reverted back to Mermaid, which is now the canonical diagram standard. The existing Quarto HTML-only render mitigation (`--to html --no-execute`) in `scripts/regenerate-html.sh` and `scripts/finalize-task.sh` resolves the prior Chromium freeze issue while enabling proper Mermaid diagram rendering.

## Files affected by revert

1. Reverted Quarto docs back to Mermaid blocks:
   - `nbs/01_platform_narrative.qmd`
   - `nbs/15_aws_emulator.qmd`
   - `nbs/16_terranix_infra.qmd`
   - `nbs/index.qmd`
2. Reverted wiki architecture interaction graph to Mermaid:
   - `docs/wiki/architecture/full-system-interaction-analysis.md`
3. Reverted Allium spec back to Mermaid naming:
   - `specs/ml-deploy-reference-repo.allium`
4. Reverted test expectations back to Mermaid blocks:
   - `tests/test_documentation_series_contracts.py`
5. Reverted all wiki narrative pages back to Mermaid references:
   - `docs/wiki/current-state.md`
   - `docs/wiki/overview.md`
   - `docs/wiki/architecture/assistant-integration-and-docs-delivery.md`
   - `docs/wiki/architecture/target-system.md`
   - `docs/wiki/decisions/nbdev-framework-decision.md`
   - `docs/wiki/sources/nbs.01_platform_narrative.qmd.md`
   - `docs/wiki/sources/nbs.index.qmd.md`
   - `docs/wiki/sources/README.md`

## Learning

D2 integration into Quarto is not a simple fence-syntax addition. D2 support would require:
- An external Quarto extension (not currently installed or configured)
- Pre-rendering D2 to SVG/PNG before Quarto processes
- Custom Quarto filters or plugins (out of scope)

For now, Mermaid remains the canonical diagram standard, as it integrates natively with Quarto.
