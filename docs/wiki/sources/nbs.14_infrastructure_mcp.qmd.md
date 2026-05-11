---
updated: 2026-05-12
summary: Synthesized summary of the Quarto source for infrastructure MCP interrogation helpers.
read_when:
  - You are editing the notebook-backed infrastructure MCP helper module
  - You need the Quarto source that owns the generated runtime helper
source_file: ../../nbs/14_infrastructure_mcp.qmd
---

# Source summary: nbs/14_infrastructure_mcp.qmd

## Role

Quarto source for infrastructure MCP interrogation helpers.

## What it contains

- inventory parsing and validation
- default MCP scope constants
- required infrastructure interrogation aspect constants
- an interrogation profile that turns inventory presence into realized aspects

## Practical implication

The infrastructure MCP rule now has a concrete Quarto-owned helper module rather than only spec text and tests.
