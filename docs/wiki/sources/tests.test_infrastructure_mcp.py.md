---
updated: 2026-05-12
summary: Synthesized summary of executable tests for infrastructure MCP interrogation helpers.
read_when:
  - You are changing infrastructure MCP helper behavior
  - You need to confirm how the helper is validated
source_file: ../../tests/test_infrastructure_mcp.py
---

# Source summary: tests/test_infrastructure_mcp.py

## Role

Validates the runtime helper for infrastructure MCP inventory parsing, availability assessment, and interrogation profile construction.

## Main behavior

- Parses and normalizes comma-delimited inventory input.
- Assesses whether infrastructure MCP servers are available.
- Builds the required default MCP scope and realized infrastructure aspect set when servers are available.
- Rejects unknown server names so unsupported inventory input fails loudly.

## Practical implication

The infrastructure MCP requirement now has executable coverage, not just spec-level assertions.
