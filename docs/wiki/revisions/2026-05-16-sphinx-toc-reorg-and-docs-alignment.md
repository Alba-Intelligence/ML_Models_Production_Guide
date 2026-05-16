---
updated: 2026-05-16
summary: Sphinx ToC reorganization and documentation alignment
---

# Sphinx ToC Reorganization and Documentation Alignment

## What changed
- The Sphinx `index.rst` ToC was reorganized into logical sections and subsections for improved navigation and accessibility.
- The top-level `README.md` was updated to point to the Sphinx docs and reflect the new structure.
- The wiki `index.md` was updated to clarify that Sphinx `.rst` files are now the canonical user-facing documentation and to clarify the wiki's role as the knowledge layer.
- `docs/wiki/architecture/documentation-toc.md` now explicitly references Sphinx `index.rst` as the canonical ToC.
- `.gitignore` was updated to allow versioning of Sphinx docs.

## Why
- To ensure all documentation is accessible, logically organized, and navigable from the Sphinx site.
- To clarify the separation of user-facing docs (Sphinx) and architectural/rationale docs (wiki).
- To ensure the ToC is always up to date and reflects the actual content.

## Next steps
- Maintain all user-facing docs in Sphinx `.rst` files.
- Use the wiki for architecture, rationale, and decision history.
- Keep the ToC in `index.rst` as the single source of truth for navigation.
