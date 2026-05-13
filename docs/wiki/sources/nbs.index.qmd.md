---
updated: 2026-05-14
summary: Synthesized summary of the Quarto homepage source that routes readers to the new stack introduction and core runtime pages.
read_when:
  - You need the current docs landing page source-of-truth
  - You are editing documentation navigation structure
source_file: ../../nbs/index.qmd
---

# Source summary: nbs/index.qmd

## Role

Primary Quarto homepage for docs navigation.

## What it contains

- Foundations, lifecycle, architecture analysis, and operations navigation groups.
- Foundations now include a dedicated stack-introduction page (`00_introduction.qmd`).
- Links to Quarto-converted architecture pages and notebook-backed runtime/module pages, including the infrastructure MCP helper notebook.
- Explicit statement that architecture diagrams use Mermaid across the documentation set.
- Deprecated content removed from the landing navigation.

## Practical implication

Homepage content is now maintained as Quarto markdown rather than notebook JSON, improving maintainability and reducing stale notebook drift.
