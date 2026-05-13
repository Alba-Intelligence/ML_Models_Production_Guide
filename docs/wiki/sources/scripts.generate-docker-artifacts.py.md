---
updated: 2026-05-12
summary: Generator script that materializes Dockerfile and compose artifacts from Nix Terranix definitions.
read_when:
  - You need to refresh generated Docker artifacts
source_file: ../../scripts/generate-docker-artifacts.py
---

# Source summary: scripts/generate-docker-artifacts.py

## Role

Generates repository Docker runtime artifacts from `nix/terranix/docker-artifacts.nix`.

## Outputs written

- `Dockerfile`
- `docker-compose.dev.yml`
- `docker-compose.aws-emulator.yml`
- `docker-compose.cloud.yml`

## Practical implication

Docker artifacts now have an automated, Nix-defined generation path instead of hand-maintenance.
