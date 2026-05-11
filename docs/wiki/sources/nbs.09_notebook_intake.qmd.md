---
updated: 2026-05-11
summary: Synthesized summary of Quarto nbdev source-of-truth for notebook intake validation gate helpers.
read_when:
  - You are editing notebook intake validation behavior
  - You need source ownership for generated `ml_deploy/notebook_intake.py`
source_file: ../../nbs/09_notebook_intake.qmd
---

# Source summary: nbs/09_notebook_intake.qmd

## Role

Quarto-first source for notebook intake gates:

- immutable revision validation
- notebook structure validation
- optional nbdev-export compatibility checks

## Export behavior

- `#| default_exp: notebook_intake` exports into `ml_deploy/notebook_intake.py`.
- Re-export via `nbdev-export --path nbs/` keeps module synchronized.
