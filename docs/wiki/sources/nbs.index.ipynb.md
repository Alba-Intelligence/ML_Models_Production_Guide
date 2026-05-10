---
updated: 2026-05-11
summary: Synthesized summary of the docs homepage notebook that presents infrastructure, notebook-first workflow, and traceability.
read_when:
  - You need the first page newcomers and stakeholders should read
  - You are updating top-level project positioning in rendered docs
source_file: ../../nbs/index.ipynb
---

# Source summary: nbs/index.ipynb

## Role

Primary rendered documentation homepage (`_docs/index.html`) for high-level orientation.

## What it communicates

- End-to-end infrastructure picture with Mermaid diagram
- Notebook-first development model (`nbs/` source of truth, exported package artifacts)
- Traceability spine from immutable notebook revisions to MLflow and operational visibility
- Fast navigation to the most important architecture notebooks
- Uses Quarto Mermaid block syntax (` ```{mermaid} `) to ensure diagram assets are loaded in rendered HTML

## Practical implication

The docs entrypoint now explains what the platform is and how pieces connect before readers dive into detailed pages.
