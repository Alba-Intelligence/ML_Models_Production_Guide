---
updated: 2026-05-10
summary: Accepted use of nbdev 3 (Quarto-based) as the core framework for notebook-first development.
---

# nbdev framework decision

## Context

The project originally considered an HTTP-serving stack for local serving and documentation delivery. However, the shift to nbdev 3 provides a notebook-first approach that unifies code, documentation, and experimentation in a single framework.

## Decision

**Use nbdev 3 (Quarto-based) as the core framework for:**

- Notebook-first development (source of truth in Jupyter notebooks)
- Automatic Python package generation from notebooks
- Documentation generation with Quarto (Mermaid diagrams, cross-references, indexing)
- Experiment tracking integration with MLflow
- Local development workflow

## Consequences

### Positive

- Unified workflow: code, docs, and experiments live in notebooks
- Automatic package generation via `nbdev_export`
- Rich documentation with Quarto (Mermaid, callouts, tabsets, etc.)
- Easy local preview with `nbdev_preview`
- Standardized project structure
- Seamless integration with MLflow for experiment tracking
- Version control remains notebook-based (reviewable diffs)

### Tradeoffs

- Learning curve for Quarto syntax (though it's markdown-based)
- Generated `docs/` directory is typically gitignored (source remains in notebooks)
- Need to discipline notebook structure for clean exports
- Less flexibility than raw Python files for complex package structures

## Implementation details

### Project structure

```
ml_deploy/
├── ml_deploy/              # Python package (exported from notebooks)
├── nbs/                    # Jupyter notebooks (source of truth)
├── tests/
├── docs/                   # Generated Quarto docs (gitignored)
├── pyproject.toml          # Project config + nbdev settings
├── README.md               # Generated from index.ipynb
└── .gitignore
```

### Commands

- `nbdev_export --path nbs/` - export notebooks to Python package
- `nbdev_test` - run tests defined in notebooks
- `nbdev_preview` - preview documentation locally
- `nbdev_build_docs` - build final documentation
- `nbdev_publish` - publish to PyPI and documentation hosting

### Documentation

- Source: notebooks in `nbs/` (markdown and code cells)
- Output: Quarto-rendered site in `docs/` (typically gitignored)
- Features: Mermaid diagrams, cross-references, automatic indexing, callouts
- The living wiki in `docs/wiki/` remains separate as project memory per AGENTS.md

### Serving

Local serving patterns should be built from nbdev-exported Python modules and infrastructure-specific adapters selected by topology requirements.

## Related decisions

- See [project-scope-and-constraints.md](project-scope-and-constraints.md) for overall constraints
- See [documentation-toc.md](architecture/documentation-toc.md) for how documentation is organized
- See [assistant-integration-and-docs-delivery.md](architecture/assistant-integration-and-docs-delivery.md) for assistant/MCP integration

## Revisit triggers

- Significant pain with notebook-based development for large-scale refactoring
- Need for features not well-supported by nbdev/Quarto ecosystem
- Team consensus that alternative framework provides better productivity
