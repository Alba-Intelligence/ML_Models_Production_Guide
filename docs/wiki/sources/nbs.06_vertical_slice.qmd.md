---
updated: 2026-05-11
summary: Synthesized summary of the Quarto nbdev source that owns first-vertical-slice implementation code.
read_when:
  - You are editing EX-01/EX-02/EX-03 implementation logic
  - You need to track generated `ml_deploy/vertical_slice.py` back to source
source_file: ../../nbs/06_vertical_slice.qmd
---

# Source summary: nbs/06_vertical_slice.qmd

## Role

Defines Quarto-first source for the concrete local first vertical slice:

- EX-01 training with MLflow traceability
- EX-02 model packaging and version records
- EX-03 local prediction logging and deployment linkage

## Export behavior

- `#| default_exp: vertical_slice` exports into `ml_deploy/vertical_slice.py`.
- `nbdev-export --path nbs/` regenerates the module and symbol index metadata.

## Practical implication

Future edits to vertical-slice logic should be done in this Quarto source and exported, not hand-edited in generated Python.
