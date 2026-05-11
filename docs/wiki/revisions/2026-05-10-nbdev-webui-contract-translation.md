---
updated: 2026-05-10
summary: Records translation of Web UI backend contract code into an nbdev notebook source and synchronized exports.
read_when:
  - You need provenance for notebook-first ownership of Web UI contract code
  - You are investigating why generated module hashes changed after export
sources:
  - ../../nbs/05_webui_contracts.ipynb
  - ../../ml_deploy/webui_contracts.py
  - ../../ml_deploy/_modidx.py
---

# Revision: 2026-05-10 nbdev translation for Web UI contracts

> Historical note (2026-05-11): This revision records a superseded `.ipynb` ownership phase. Canonical code ownership now lives in Quarto sources (`.qmd`) per `2026-05-11-quarto-code-ownership-switch.md`.

## Trigger

The implementation needed to move from hand-edited Python module form into nbdev notebook ownership.

## What changed

1. Added `nbs/05_webui_contracts.ipynb` as the source notebook for Web UI contract logic.
2. Ran `nbdev-export --path nbs/` to regenerate `ml_deploy/webui_contracts.py` from notebook cells.
3. Accepted the associated nbdev symbol-index update in `ml_deploy/_modidx.py`.

## Outcome

Web UI contract code is now notebook-first and export-driven, matching the repository's nbdev workflow direction.
