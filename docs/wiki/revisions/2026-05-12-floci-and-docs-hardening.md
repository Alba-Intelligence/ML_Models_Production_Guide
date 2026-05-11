# Floci migration and docs hardening

## Summary

Replaced the local AWS parity path with Floci as the sole local emulator and expanded the notebook/wiki coverage so the emulator and Terranix source can be read without folder spelunking.

## What changed

- Added `docker-compose.aws-emulator.yml` for Floci plus bootstrap.
- Removed MinIO and LocalStack from the canonical local compose flow.
- Added Quarto pages for the emulator and Terranix source snippets.
- Updated wiki routing, current-state, and runbooks to match the new stack.

## Why it matters

The repo now tells one coherent local-emulation story: Floci for AWS APIs, PostgreSQL for MLflow metadata, and separate K3s/Slurm compute-plane services. The docs also expose the relevant source snippets directly so the website is usable as an implementation reference.
