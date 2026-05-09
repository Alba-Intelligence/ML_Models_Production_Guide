---
updated: 2026-05-09
summary: Infrastructure domain responsibilities for AWS, Lambda.ai, networking, storage, environments, and python-terraform workflows.
read_when:
  - You are defining platform shape or cloud resources
  - You are deciding where infrastructure concerns stop and application/domain concerns begin
sources:
  - index.md
  - ../contracts/security-baseline.md
  - ../contracts/deployment-baseline.md
  - ../contracts/cost-attribution-baseline.md
  - ../architecture/reference-architecture-skeleton.md
---

# Infrastructure domain

## Owns

- `python-terraform` workflows
- AWS resource patterns
- Lambda.ai compute patterns
- environment separation
- networking model
- storage topology
- container/runtime environment boundaries

## Does not own

- model semantics
- evaluation policy
- serving request semantics
- promotion policy rationale

## Lifecycle coverage

Primary coverage:
- infrastructure provisioning
- distributed compute workflows
- environment setup for training, batch, online, and docs delivery

## Contracts consumed

- [../contracts/security-baseline.md](../contracts/security-baseline.md)
- [../contracts/deployment-baseline.md](../contracts/deployment-baseline.md)
- [../contracts/cost-attribution-baseline.md](../contracts/cost-attribution-baseline.md)

## Topology relevance

- Topology A: Docker-based local dev environment
- Topology B: Lambda.ai distributed training
- Topology C: AWS-integrated batch infrastructure
- Topology D: AWS-integrated online inference controls

## Key questions this domain must answer

- How are environments separated?
- What does `python-terraform` own vs what remains manual or external?
- How are Lambda.ai and AWS integrated in one mental model?
- How does infrastructure expose the metadata needed by security, deployment, and cost contracts?

## Assistant implications

Useful assistant capabilities here include:
- surfacing environment drift
- comparing intended vs deployed resource shape
- checking presence of required tags, network assumptions, or secret integrations

## Open decisions

- exact environment model
- exact networking/storage reference pattern
- exact Terraform state and review posture
