---
updated: 2026-05-11
summary: Added CI enforcement for export/render/tests and marked older .ipynb ownership revisions as historical.
read_when:
  - You need CI provenance for docs freshness enforcement
  - You need context for older revision pages that still reference `.ipynb` ownership
sources:
  - ../../.github/workflows/ci.yml
  - ./2026-05-10-nbdev-webui-contract-translation.md
  - ./2026-05-10-nbdev-vertical-slice-translation.md
  - ./2026-05-11-nbdev-runtime-modules-translation.md
---

# 2026-05-11 — CI enforcement and revision archive notes

## What changed

- Added `.github/workflows/ci.yml` to enforce:
  - `uv sync`
  - `uv run nbdev-export --path nbs/`
  - `quarto render . --no-execute`
  - `uv run python -m unittest discover -s tests -q`
- Added historical archive notes to older revision pages that recorded `.ipynb` code ownership phases, pointing to the Quarto ownership switch revision.

## Why

- CI now catches stale docs and export drift automatically on PRs and pushes.
- Historical revision pages remain accurate without being mistaken for current ownership policy.
