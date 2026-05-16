---
title: "Revision: 2026-05-16 docs compaction for line-limit control"
summary: "Compacted the large reference/tutorial QMD files and several decision pages so the active docs stay below the 500-line threshold and remain easier to load in context."
author: "Emmanuel"
---

# 2026-05-16 — Docs compaction for line-limit control

## What changed

- Rewrote the largest reference QMD pages into shorter, more focused narrative docs.
- Rewrote the longest tutorial QMD pages into compact guides that preserve the workflow shape without huge embedded examples.
- Shortened several long wiki decision pages so they remain below the 500-line threshold.
- Updated source summaries to match the new compact docs shape.

## Why it matters

This reduces context bloat for future work while keeping the docs useful and aligned with the repository's contract-first style.

## Touched files

- `nbs/reference/01_Implementation_Patterns.qmd`
- `nbs/reference/02_API_Documentation.qmd`
- `nbs/reference/03_Security_Authorization_and_Policy.qmd`
- `nbs/tutorials/03_Concepts_and_Architecture.qmd`
- `nbs/tutorials/04_End_to_End_Workflow.qmd`
- `nbs/tutorials/05_Advanced_Scenarios.qmd`
- `nbs/tutorials/06_Migration_Guide.qmd`
- `docs/wiki/decisions/mlflow-storage-sync-strategy.md`
- `docs/wiki/decisions/nix-containerization-boundary.md`
- `docs/wiki/decisions/nix-terranix-opentofu-boundary.md`
- `docs/wiki/decisions/mlflow-notebook-execution-contract.md`
- `docs/wiki/sources/nbs.reference.01_Implementation_Patterns.qmd.md`
- `docs/wiki/sources/nbs.reference.02_API_Documentation.qmd.md`
- `docs/wiki/sources/nbs.reference.03_Security_Authorization_and_Policy.qmd.md`
