---
updated: 2026-05-12
summary: Added an executable helper module for infrastructure MCP inventory assessment and interrogation-profile selection.
---

# Revision: infrastructure MCP interrogation helper

## What changed

- Added `nbs/14_infrastructure_mcp.qmd` as the Quarto source of truth for infrastructure MCP helper code.
- Added `ml_deploy/infrastructure_mcp.py` with inventory parsing, availability assessment, and interrogation profile construction.
- Added tests for parsing, availability, profile construction, and unknown-name rejection.

## Why

This turns the spec rule into a concrete helper that assistant-facing code can call instead of treating the requirement as documentation-only. The helper keeps the default MCP scope and required infrastructure interrogation aspects in one place.

## Touched files

- `nbs/14_infrastructure_mcp.qmd`
- `nbs/14_infrastructure_mcp.html.md`
- `ml_deploy/infrastructure_mcp.py`
- `ml_deploy/_modidx.py`
- `tests/test_infrastructure_mcp.py`
- `docs/wiki/architecture/assistant-integration-and-docs-delivery.md`
- `docs/wiki/current-state.md`
- `docs/wiki/sources/ml_deploy.infrastructure_mcp.py.md`
- `docs/wiki/sources/nbs.14_infrastructure_mcp.qmd.md`
- `docs/wiki/index.md`
- `docs/wiki/log.md`
