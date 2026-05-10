---
updated: 2026-05-11
summary: Replaced redirect-style docs index with a real notebook homepage describing infrastructure, notebook-first approach, and traceability.
read_when:
  - You need provenance for the docs homepage redesign
  - You are evaluating onboarding/documentation entrypoint quality
sources:
  - ../../nbs/index.ipynb
  - ../sources/nbs.index.ipynb.md
---

# Revision: 2026-05-11 docs index overview homepage

## Trigger

The docs index needed to communicate overall structure instead of redirecting to a single page.

## What changed

1. Added `nbs/index.ipynb` as the rendered homepage source.
2. Added a top-level architecture Mermaid diagram.
3. Added explicit sections for:
   - infrastructure structure
   - notebook-first development model
   - traceability spine
4. Added fast links to key notebooks for navigation.

## Outcome

`_docs/index.html` now acts as a true project overview page for mixed audiences.
