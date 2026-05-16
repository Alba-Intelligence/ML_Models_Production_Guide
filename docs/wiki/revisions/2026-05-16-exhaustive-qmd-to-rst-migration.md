---
updated: 2026-05-16
summary: Exhaustive migration of all Quarto `.qmd` documentation to Sphinx `.rst` files, with logical ToC and complete navigation.
read_when:
  - You need to verify the migration status
  - You want to confirm all `.qmd` files are represented in Sphinx
  - You want to check ToC and navigation completeness
sources:
  - nbs/*.qmd
  - docs/sphinx/source/*.rst
  - docs/sphinx/source/index.rst
  - docs/wiki/architecture/documentation-toc.md
  - docs/wiki/current-state.md
  - README.md
---

# Revision: 2026-05-16 exhaustive qmd-to-rst migration

## Trigger

User requested an exhaustive, professional migration of all Quarto `.qmd` documentation to Sphinx `.rst` files, with a logical, complete ToC and all content accessible in the Sphinx site.

## What changed

- Audited all `.qmd` files in `nbs/` and subfolders.
- Ensured every `.qmd` has a `.rst` equivalent in `docs/sphinx/source/`.
- Updated Sphinx ToC and section index files for logical structure and completeness.
- Systematically replaced all `.qmd` references in `.rst` files (including diagrams and navigation) with `.rst`.
- Verified Sphinx HTML build and navigation.
- No `.qmd` files were deleted or modified.
- All changes tracked in git.

## Outcome

- All `.qmd` files are now represented in Sphinx.
- Navigation and ToC are exhaustive and logical.
- Sphinx HTML build is successful and all content is accessible.
- No `.qmd` references remain in Sphinx docs.
- Wiki, README, and ToC are up to date.
