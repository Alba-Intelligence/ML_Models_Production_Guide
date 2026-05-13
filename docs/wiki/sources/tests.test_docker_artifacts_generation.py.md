---
updated: 2026-05-12
summary: Tests that generated Docker artifacts exist and include expected generation/proxy/validation markers.
read_when:
  - You are modifying Docker artifact generation
source_file: ../../tests/test_docker_artifacts_generation.py
---

# Source summary: tests/test_docker_artifacts_generation.py

## Role

Verifies that Docker artifacts are generated and include cloud reverse-proxy/security config markers.

## Coverage

- Dockerfile contains generated marker header
- local dev compose contains generated marker header
- cloud compose includes Traefik + MLflow source-validation env marker
