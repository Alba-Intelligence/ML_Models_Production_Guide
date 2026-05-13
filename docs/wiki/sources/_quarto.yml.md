---
updated: 2026-05-14
summary: Root Quarto project configuration used to regenerate repository `_docs` from `nbs/*.qmd`, including the stack introduction page.
read_when:
  - You need to regenerate publishable HTML docs in repository `_docs`
  - You are changing Quarto project-level output behavior
source_file: ../../_quarto.yml
---

# Source summary: _quarto.yml

## Role

Defines a root-level Quarto website project that renders `nbs/*.qmd` into repository docs output.

## Key behavior

- Project output directory is `_docs`.
- Render scope is all Quarto pages under `nbs/`.
- Generated pages are emitted under `_docs/nbs/` with `_docs/index.html` as the root entry page.
- Sidebar navigation now includes `nbs/00_introduction.qmd` as the overview entry before module pages.

## Practical implication

Use `quarto render . --no-execute` (or `nix develop -c quarto render . --no-execute`) when you need root docs outputs refreshed from Quarto sources.
