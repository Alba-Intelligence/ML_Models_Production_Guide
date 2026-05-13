---
updated: 2026-05-12
summary: Generated Docker Compose development stack including Traefik, dev shell, MLflow, PostgreSQL, and Floci-backed artifacts.
read_when:
  - You need the canonical Docker-first local workflow
  - You are bringing up local MLflow parity services
source_file: ../../docker-compose.dev.yml
---

# Source summary: docker-compose.dev.yml

## Role

Defines the generated containerized local development and MLflow parity stack.

## Services

- `dev` interactive workspace container with project mount and `uv sync --frozen`.
- `postgres` metadata backend for MLflow.
- `MLFLOW_S3_ENDPOINT_URL` points at the shared Floci emulator.
- `mlflow` tracking server using PostgreSQL backend + S3 artifacts destination.
- `traefik` reverse proxy routes MLflow under `/mlflow`.

## Practical implication

The local runtime stack now includes generated reverse-proxy configuration and is regenerated from Nix Terranix definitions.
