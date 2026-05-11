---
updated: 2026-05-11
summary: Synthesized summary of Docker Compose development stack including dev shell, MLflow, PostgreSQL, and MinIO.
read_when:
  - You need the canonical Docker-first local workflow
  - You are bringing up local MLflow parity services
source_file: ../../docker-compose.dev.yml
---

# Source summary: docker-compose.dev.yml

## Role

Defines the containerized local development and MLflow parity stack.

## Services

- `dev` interactive workspace container with project mount and `uv sync --frozen`.
- `postgres` metadata backend for MLflow.
- `minio` S3-compatible artifact storage.
- `create-minio-bucket` one-shot bucket bootstrap.
- `mlflow` tracking server using PostgreSQL backend + S3 artifacts destination.

## Practical implication

Docker-first local development is now implemented with the same storage posture expected by the target architecture.
