---
updated: 2026-05-11
summary: Fixed homepage Mermaid rendering by switching to Quarto Mermaid block syntax in nbs/index.ipynb.
read_when:
  - You are debugging docs diagram rendering issues
  - You need to understand why Mermaid loads correctly on the index page
sources:
  - ../../nbs/index.ipynb
  - ../sources/nbs.index.ipynb.md
---

# Revision: 2026-05-11 index Mermaid render fix

## Trigger

The index page diagram was present as code but not rendered as an active Mermaid visualization.

## What changed

1. Switched the diagram fence in `nbs/index.ipynb` from ` ```mermaid ` to Quarto-native ` ```{mermaid} `.
2. Re-rendered docs so `_docs/index.html` includes Mermaid runtime assets and initialization scripts.

## Outcome

The index Mermaid diagram now renders correctly in the generated HTML page.
