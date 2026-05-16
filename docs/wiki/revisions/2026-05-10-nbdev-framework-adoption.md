---
updated: 2026-05-10
summary: Adoption of nbdev 3 as the core framework, replacing the earlier serving plan.
---

# nbdev Framework Adoption - 2026-05-10

## Changes Made

### 1. Updated Target System (`docs/wiki/architecture/target-system.md`)

- Replaced the earlier serving-framework references with nbdev 3 (Quarto-based) as the core ML and notebook stack
- Updated documentation section to specify Quarto for rendered documentation
- Updated likely documentation sections to reference nbdev for artifact/model packaging
- Removed local-serving framework references from likely documentation sections

### 2. Updated Documentation TOC (`docs/wiki/architecture/documentation-toc.md`)

- Renamed section 06 from "Local development and local serving" to "Local development and nbdev workflow"
- Updated candidate pages to reflect nbdev workflow instead of a specific serving framework

### 3. Updated Assistant Integration and Docs Delivery (`docs/wiki/architecture/assistant-integration-and-docs-delivery.md`)

- Removed the entire "Part 2 — documentation serving" section
- Added new "Part 2 — Documentation with nbdev/Quarto" section
- Positioned nbdev/Quarto as the accepted documentation framework
- Updated MCP recommendation to keep documentation retrieval scope

### 4. Added New Decision Record (`docs/wiki/decisions/nbdev-framework-decision.md`)

- Created detailed decision record for adopting nbdev 3 as core framework
- Explains context, decision, consequences, implementation details, and revisit triggers

### 5. Updated Decisions Index (`docs/wiki/decisions/index.md`)

- Added reference to the new nbdev-framework-decision.md

### 6. Updated Overview (`docs/wiki/overview.md`)

- Updated technical direction to replace the earlier serving plan with nbdev 3 (Quarto-based)

### 7. Updated Current State (`docs/wiki/current-state.md`)

- Added note about initialized nbdev 3 project structure

### 8. Initialized nbdev Project Structure

- Created `pyproject.toml` with nbdev 3 configuration
- Created basic package structure (`ml_deploy/`, `nbs/`, `tests/`)
- Created initial notebook (`nbs/00_core.ipynb`, `nbs/01_intro.ipynb`)
- Created core module (`ml_deploy/core.py`)
- Created README.md
- Updated `.gitignore` to properly handle nbdev-generated docs/ directory while preserving docs/wiki/
- Created basic test file (`tests/test_core.py`)

### 9. Verified nbdev Installation

- Installed nbdev 3.0.15 in project virtual environment
- Verified nbdev-export works correctly
- Confirmed package can be imported and used

## Motivation

The shift to nbdev 3 provides a notebook-first approach that unifies code, documentation, and experimentation in a single framework, eliminating the need for separate documentation-delivery infrastructure while providing richer documentation capabilities through Quarto.

## Impact

- Repository now has an active nbdev 3 project structure ready for development
- All references to the earlier documentation delivery framework have been removed
- The living wiki in `docs/wiki/` remains unchanged as the project memory layer per AGENTS.md
- Documentation will now be generated from notebooks via Quarto (nbdev 3)
- Local serving patterns will be explored separately once actual model code exists

## Files Modified

- docs/wiki/architecture/target-system.md
- docs/wiki/architecture/documentation-toc.md
- docs/wiki/architecture/assistant-integration-and-docs-delivery.md
- docs/wiki/decisions/nbdev-framework-decision.md (new)
- docs/wiki/decisions/index.md
- docs/wiki/overview.md
- docs/wiki/current-state.md
- .gitignore
- pyproject.toml (new)
- README.md (new)
- ml_deploy/**init**.py (new)
- ml_deploy/core.py (new)
- nbs/00_core.ipynb (new)
- nbs/01_intro.ipynb (new)
- tests/test_core.py (new)
