---
title: "Infrastructure MCP Interrogation Helpers"
---

# Infrastructure MCP Interrogation Helpers

This page provides the Quarto source for infrastructure MCP interrogation helpers, which turn inventory presence into realized aspects.

## Role

The infrastructure MCP rule now has a concrete Quarto-owned helper module rather than only spec text and tests.

## What It Contains

- Inventory parsing and validation
- Default MCP scope constants
- Required infrastructure interrogation aspect constants
- An interrogation profile that turns inventory presence into realized aspects

## Practical Implication

The infrastructure MCP rule now has a concrete Quarto-owned helper module rather than only spec text and tests.

## Usage

These helpers are used by the infrastructure MCP server to validate inventory and determine which aspects should be enabled based on what infrastructure components are present.

## Key Functions

- `parse_inventory`: Parses and validates the infrastructure inventory
- `get_default_scope`: Returns the default MCP scope constants
- `get_required_aspects`: Returns required infrastructure interrogation aspect constants
- `create_interrogation_profile`: Creates an interrogation profile from inventory

## Related Components

- [Infrastructure MCP Server](ml_deploy.infrastructure_mcp.py): The actual MCP server implementation
- [Infrastructure MCP Inventory](decisions/infrastructure-mcp-server-inventory.md): Required infrastructure MCP interrogation coverage and server inventory defaults

