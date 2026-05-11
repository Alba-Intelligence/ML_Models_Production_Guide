---
updated: 2026-05-11
summary: Synthesized summary of the Quarto nbdev source-of-truth for Web UI backend contracts.
read_when:
  - You are editing Web UI execution contract code in the Quarto-first workflow
  - You need to trace generated `ml_deploy/webui_contracts.py` back to source
source_file: ../../nbs/05_webui_contracts.qmd
---

# Source summary: nbs/05_webui_contracts.qmd

## Role

Defines the Quarto nbdev source for:

- immutable notebook execution request contracts
- MLflow deep-link helper behavior
- Web UI run visibility summary mapping

## Export behavior

- `#| default_exp: webui_contracts` exports into `ml_deploy/webui_contracts.py`.
- `nbdev-export --path nbs/` regenerates the Python module and updates nbdev symbol index metadata.

## Practical implication

Future contract edits should happen in this Quarto source and be exported to keep source/code parity.
