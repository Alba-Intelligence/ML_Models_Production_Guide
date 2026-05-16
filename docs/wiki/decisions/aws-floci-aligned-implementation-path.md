---
updated: 2026-05-16
summary: Decision record for preferring AWS-native services that are also available through Floci-backed local parity.
read_when:
  - You are choosing implementation options for the biggest remaining gaps
  - You need to understand which choices preserve local/cloud parity
sources:
  - ../architecture/local-emulation-stack.md
  - ../architecture/target-system.md
  - ../gaps/software-stack-gaps.md
  - ../contracts/security-baseline.md
---

# AWS / Floci-aligned implementation path

## Purpose

Select implementation options that work well in cloud and still have a credible local parity story through Floci.

## Decision

For the biggest remaining gaps, prefer **AWS-native components that Floci can emulate locally**.

That means prioritizing choices that use:

- OIDC at the edge for human authn
- IAM / STS / Secrets Manager for machine identity and secrets
- S3 for artifact and model storage
- PostgreSQL for MLflow backend state
- CloudWatch for logs, metrics, and alarms
- Terranix/OpenTofu for AWS resource generation and apply-time control

## Why this fits the stack

The reference stack already treats local emulation as a first-class contract.
If a subsystem can be expressed with an AWS service that Floci can emulate, it is easier to keep the local and cloud behaviors aligned.

## Consequences for other subsystems

### Security and identity

- Web UI and backend services should use OIDC plus role/capability mapping.
- Automation should use scoped AWS identities rather than ambient credentials.
- Secret handling should flow through Secrets Manager in cloud and the Floci-backed analogue locally.

### Observability

- Logging and audit trails should route through CloudWatch-compatible paths.
- Local and cloud metrics names should stay aligned so investigations do not need two mental models.

### Data and artifacts

- Model artifacts and MLflow state should live on S3/PostgreSQL-compatible storage.
- URLs and artifact identity should remain stable across local and cloud profiles.

### Infrastructure

- Terranix/OpenTofu should generate AWS resources that can be mirrored in local emulation.
- Infrastructure changes should remain reviewable and environment-scoped.

### Execution and promotion

- Execution backends should assume environment-scoped credentials and artifact access.
- Promotion should stay approval-aware and storage-backed, not framework-specific.

## What this does not solve

This does **not** make every gap AWS-native.
In particular:

- Lambda.ai / Slurm remains a topology-specific distributed-training path.
- Kubernetes/EKS remains a topology-specific online-serving path.
- Custom data ingestion still needs a design that fits the actual source systems.

## Related pages

- `docs/wiki/architecture/local-emulation-stack.md`
- `docs/wiki/gaps/software-stack-gaps.md`
- `docs/wiki/decisions/security-authorization-architecture.md`
- `docs/wiki/decisions/mlflow-postgres-s3-contract.md`

## Summary

Prefer AWS-native components that Floci can emulate locally when they cover the gap well.
That keeps the stack practical, cloud-realistic, and parity-friendly.
