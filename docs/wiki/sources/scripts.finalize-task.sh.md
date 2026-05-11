---
updated: 2026-05-11
summary: Synthesized summary of the standard end-of-task command that exports notebooks, renders docs, and runs tests.
read_when:
  - You need to produce publishable docs at task end
  - You want one command for export/docs/tests consistency
source_file: ../../scripts/finalize-task.sh
---

# Source summary: scripts/finalize-task.sh

## Role

Defines the standard task-finalization workflow:

1. export notebook code with nbdev
2. render publishable documentation
3. run repository test suite

## Commands executed

- `uv run nbdev-export --path nbs/`
- `quarto render . --no-execute`
- `uv run python -m unittest discover -s tests -q`
