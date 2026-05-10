---
updated: 2026-05-10
summary: Synthesized summary of the nbdev notebook that now acts as source-of-truth for Web UI backend contracts.
read_when:
  - You are editing Web UI execution contract code in nbdev-first workflow
  - You need to trace generated `ml_deploy/webui_contracts.py` back to notebook source
source_file: ../../nbs/05_webui_contracts.ipynb
---

# Source summary: nbs/05_webui_contracts.ipynb

## Role

Defines the nbdev notebook source for:

- immutable notebook execution request contracts
- MLflow deep-link helper behavior
- Web UI run visibility summary mapping

## Export behavior

- `#| default_exp webui_contracts` exports into `ml_deploy/webui_contracts.py`.
- `nbdev-export --path nbs/` regenerates the Python module and updates nbdev symbol index metadata.

## Practical implication

Future contract edits should happen in this notebook first, then exported to keep notebook/code parity.
