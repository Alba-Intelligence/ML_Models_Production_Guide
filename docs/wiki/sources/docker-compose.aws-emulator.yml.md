---
updated: 2026-05-12
summary: Shared Floci-based local AWS emulator compose stack.
read_when:
  - You need to start or modify the local AWS emulator
sources:
  - ../../../../docker-compose.aws-emulator.yml
---

# `docker-compose.aws-emulator.yml`

- Defines the canonical local AWS emulator as Floci plus a bootstrap job.
- Mounts the Docker socket and uses the `ml_local` network so dev, compute, and emulator stacks can talk to each other.
- Bootstrap creates the MLflow and model-registry buckets and a local IAM role.
