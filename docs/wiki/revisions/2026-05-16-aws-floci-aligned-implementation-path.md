---
title: "Revision: 2026-05-16 AWS / Floci-aligned implementation path"
summary: "Captured the recommendation to prefer AWS-native services that also have a Floci-backed local parity path, and documented the consequences for security, observability, artifacts, infrastructure, execution, and governance."
author: "Emmanuel"
---

# 2026-05-16 — AWS / Floci-aligned implementation path

## What changed

- Added a new decision record for preferring AWS-native services that Floci can emulate locally.
- Updated the advanced scenarios tutorial to describe the AWS / Floci parity path and subsystem consequences.
- Updated the security posture reference to call out IAM / STS / Secrets Manager / CloudWatch as the preferred AWS-compatible implementation family.
- Updated the structural gap analysis to include a recommended AWS / Floci alignment matrix.
- Recorded the recommendation in current-state and the wiki log.

## Why it matters

This keeps the biggest implementation choices practical: AWS-compatible where possible, but still locally verifiable through Floci-backed emulation.

## Touched files

- `docs/wiki/decisions/aws-floci-aligned-implementation-path.md`
- `docs/wiki/decisions/security-authorization-architecture.md`
- `docs/wiki/gaps/software-stack-gaps.md`
- `docs/wiki/current-state.md`
- `docs/wiki/index.md`
- `docs/wiki/decisions/index.md`
- `docs/wiki/revisions/2026-05-16-aws-floci-aligned-implementation-path.md`
- `docs/wiki/log.md`
- `nbs/tutorials/05_Advanced_Scenarios.qmd`
- `nbs/reference/03_Security_Authorization_and_Policy.qmd`
