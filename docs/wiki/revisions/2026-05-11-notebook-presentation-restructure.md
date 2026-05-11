---
updated: 2026-05-11
summary: Reorganized notebook presentation around lifecycle and topology with a dedicated platform narrative notebook and a navigation-first homepage.
read_when:
  - You need to understand the new notebook reading order
  - You are deciding where architecture narrative content should live
sources:
  - ../../nbs/index.ipynb
  - ../../nbs/01_platform_narrative.ipynb
  - ../../nbs/11_infrastructure_overview.ipynb
  - ../sources/nbs.index.ipynb.md
  - ../sources/nbs.01_platform_narrative.ipynb.md
  - ../sources/nbs.11_infrastructure_overview.ipynb.md
---

# Revision: 2026-05-11 notebook presentation restructure

## Trigger

Notebook presentation structure needed to better reflect target infrastructure structure and remove duplicated architecture narrative.

## What changed

1. Added `nbs/01_platform_narrative.ipynb` as the single canonical architecture narrative notebook.
2. Converted `nbs/index.ipynb` into a navigation-first homepage grouped by foundations, lifecycle, and topology/operations.
3. Deprecated `nbs/11_infrastructure_overview.ipynb` and replaced its content with a compatibility migration notice.

## Result

The notebook set now communicates architecture with clearer separation of concerns:

- one canonical architecture story
- one navigation homepage
- reduced duplicated narrative and Mermaid maintenance
