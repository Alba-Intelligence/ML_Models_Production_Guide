---
updated: 2026-05-12
summary: Synthesized summary of infrastructure MCP interrogation helpers for assistant-facing runtime code.
read_when:
  - You need the executable helper layer for infrastructure MCP availability and interrogation scope
  - You are wiring assistant-facing code to read infrastructure MCP inventories
source_file: ../../ml_deploy/infrastructure_mcp.py
---

# Source summary: ml_deploy/infrastructure_mcp.py

## Role

Provides runtime helpers for the spec rule that requires infrastructure MCP surfaces, when available, to expose the minimum interrogation scope by default.

## Main components

- `InfrastructureMcpInventory` — normalized list of available infrastructure MCP server names.
- `InfrastructureMcpInterrogationProfile` — default assistant MCP scope plus realized interrogation aspects.
- `parse_infrastructure_mcp_inventory` — parses a comma-delimited inventory string.
- `assess_infrastructure_mcp_availability` — returns whether any known infrastructure MCP server is available.
- `build_infrastructure_mcp_interrogation_profile` — builds the concrete profile from an inventory.

## Ownership

- Generated from `nbs/14_infrastructure_mcp.qmd`.
- Update the Quarto source and re-export if behavior changes.

## Practical implication

Assistant-facing orchestration code now has a small, explicit helper layer for converting infrastructure MCP availability into the required default MCP scope and interrogation aspect set.
