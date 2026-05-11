---
updated: 2026-05-11
summary: Added root Quarto project render path so repository `_docs` timestamps and HTML outputs regenerate from `nbs/*.qmd`.
read_when:
  - You need to understand why docs output now appears under `_docs/nbs/`
  - You need the canonical command for regenerating root docs output
sources:
  - ../../_quarto.yml
  - ../../nbs/_quarto.yml
  - ../../scripts/finalize-task.sh
  - ../runbooks/jupyter-and-shell.md
---

# 2026-05-11 — Root docs regeneration from Quarto sources

## What changed

- Added a root Quarto project config (`_quarto.yml`) that renders `nbs/*.qmd` into repository `_docs`.
- Standardized task-finalization docs render step to `quarto render . --no-execute` in `scripts/finalize-task.sh`.
- Updated runbook guidance to use the root render command for fresh repository docs outputs.

## Verification outcome

- Quarto render from root completed with all `nbs/*.qmd` pages.
- Generated HTML timestamps under `_docs/` now reflect current regeneration time (notably `_docs/nbs/*.html` and `_docs/index.html`).
