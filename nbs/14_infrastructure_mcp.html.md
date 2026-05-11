---
title: "Infrastructure MCP Interrogation"
---

# Infrastructure MCP interrogation

This page owns the executable helper layer for the spec rule that requires infrastructure MCP surfaces, when available, to expose the minimum interrogation scope by default.

## What it contains

- `InfrastructureMcpInventory` for normalized inventory input
- `InfrastructureMcpInterrogationProfile` for default scope plus realized aspects
- helpers to parse inventory, assess availability, and build the interrogation profile

