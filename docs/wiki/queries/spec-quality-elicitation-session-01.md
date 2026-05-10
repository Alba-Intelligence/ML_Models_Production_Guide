---
updated: 2026-05-11
summary: Concrete, technology-bound clarification questions aligned to required stack decisions.
read_when:
  - You need to run a structured clarification session
  - You are deciding if specs are complete enough to permit implementation
sources:
  - ../decisions/project-scope-and-constraints.md
  - ../architecture/reference-architecture-skeleton.md
  - ../architecture/notebook-repository-web-ui.md
  - ../../specs/ml-deploy-reference-repo.allium
---

# Spec quality elicitation — session 01 (technology-bound)

## Why this exists

These questions are intentionally tied to the mandated stack:
MLflow (PostgreSQL + S3), Lambda.ai + Slurm, AWS + Kubernetes, python-terraform, Docker-first reproducibility, and immutable notebook execution through Web UI.

## Questions to close first

1. **MLflow + PostgreSQL + S3 contract**
   - What exact schema fields are mandatory on every run for lineage (`dataset_version`, `feature_revision`, `model_version`, `notebook_revision`, `execution_backend`)?
   - Is S3 path layout standardized (`s3://bucket/project/env/run_id/...`) or per-team configurable?
   - What is the required fallback behavior if PostgreSQL is reachable but S3 artifact upload fails?

2. **Lambda.ai Slurm redundancy contract**
   - Which Slurm failure modes must be represented explicitly in the spec (`PENDING timeout`, `NODE_FAIL`, `PREEMPTED`, `CANCELLED`)?
   - What retry/escalation policy is required per failure mode?
   - Which metadata from Slurm (`job_id`, `partition`, `node_list`, `exit_code`) must always flow back into MLflow/Web UI?

3. **AWS Kubernetes contract (non-Lambda services)**
   - Which workloads are mandatory Kubernetes-managed vs explicitly not on Kubernetes?
   - What deployment states must be modeled for batch and online flows (`submitted`, `scheduled`, `running`, `succeeded`, `failed`, `rolled_back`)?
   - What minimum observability payload is required from K8s runs (pod/job IDs, namespace, image digest, resource requests/limits)?

4. **python-terraform ownership boundary**
   - Which infrastructure components must be generated/controlled only via `python-terraform` wrappers?
   - Are hand-written Terraform files ever allowed, and if yes, for which exceptions?
   - What spec artifact proves parity between generated Terraform JSON and deployed resources?

5. **Docker-first reproducibility vs Nix helper boundary**
   - Which workflows must be reproducible from Docker alone with no Nix dependency?
   - Which Nix outputs are allowed as helper-only artifacts without becoming the canonical runtime path?
   - What acceptance test demonstrates local Docker parity with production storage/control planes?

6. **Immutable notebook Web UI execution contract**
   - What is the required immutable notebook reference format (`git SHA only` vs `SHA/tag/approved ref`)?
   - Which execution parameters are allowed to vary at run time, and which are locked by notebook revision?
   - Which exact run status timeline must be shown in Web UI for all backends?

7. **Cross-topology security + lineage minimums**
   - Which secrets are required to be runtime-injected only (never persisted in notebooks, logs, or MLflow params)?
   - What identity/audit fields are mandatory on every trigger action (`actor`, `role`, `time`, `ticket/approval ref`)?
   - Which lineage break conditions are treated as hard-stop failures?

## Done criteria for this question set

- Each question is answered in a normative page (decision, contract, or topology spec), not only in notes.
- Each answer includes at least one acceptance criterion that can be tested.
- Open items are explicitly deferred with owner and revisit trigger.
