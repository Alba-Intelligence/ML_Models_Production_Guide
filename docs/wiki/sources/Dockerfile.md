---
updated: 2026-05-11
summary: Synthesized summary of the Docker-first development image for reproducible local workflows.
read_when:
  - You need the canonical Docker development container entrypoint
  - You are validating Docker/Nix boundary implementation status
source_file: ../../Dockerfile
---

# Source summary: Dockerfile

## Role

Defines the default development container for this repository.

## What it does

- Uses `python:3.13-slim` as the base image.
- Installs build essentials, curl, and git for development tooling.
- Installs `uv` and runs `uv sync --frozen` against project dependencies.
- Sets `/workspace` as the working directory.

## Practical implication

The repository now has an explicit Docker artifact that can reproduce the Python/uv environment without requiring Nix.
