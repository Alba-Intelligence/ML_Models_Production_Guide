---
updated: 2026-05-12
summary: Generated cloud-profile compose artifact with Traefik-fronted MLflow and source-validation env wiring.
read_when:
  - You need cloud-profile reverse proxy and MLflow runtime wiring
source_file: ../../docker-compose.cloud.yml
---

# Source summary: docker-compose.cloud.yml

## Role

Defines the generated cloud deployment profile compose artifact.

## Key behavior

- Exposes a `traefik` reverse proxy service as the MLflow ingress boundary.
- Routes MLflow via Traefik labels (`Host(mlflow.internal)` on `websecure`).
- Sets `MLFLOW_CREATE_MODEL_VERSION_SOURCE_VALIDATION_REGEX` on the MLflow service.

## Practical implication

Cloud-profile MLflow now has explicit reverse-proxy and model-source validation configuration in repository-managed runtime artifacts.
