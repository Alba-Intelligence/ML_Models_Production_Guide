---
updated: 2026-05-11
summary: Synthesized summary of the docs homepage notebook as the navigation entrypoint for the notebook architecture.
read_when:
  - You need the first page newcomers and stakeholders should read
  - You are updating top-level project positioning in rendered docs
source_file: ../../nbs/index.ipynb
---

# Source summary: nbs/index.ipynb

## Role

Primary rendered documentation homepage (`_docs/index.html`) for structured navigation.

## What it communicates

- Navigation-first reading order grouped by foundations, lifecycle, and topology/operations
- A dedicated architecture-analysis notebook entry for deep interaction mapping
- Notebook-first development model (`nbs/` source of truth, exported package artifacts)
- Link to the canonical architecture narrative notebook (`nbs/01_platform_narrative.ipynb`)
- Backwards-compatible link to deprecated infrastructure overview

## Practical implication

The docs entrypoint now routes readers into the agreed notebook structure while avoiding duplicated architecture narrative on the homepage.
