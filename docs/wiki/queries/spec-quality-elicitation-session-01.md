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

1. **MLflow + PostgreSQL + S3 contract** ✅ RESOLVED
   - What exact schema fields are mandatory on every run for lineage (`dataset_version`, `feature_revision`, `model_version`, `notebook_revision`, `execution_backend`)? → **Answered**: MLflow manages schema automatically via `mlflow db upgrade`; lineage fields are stored in PostgreSQL tables
   - Is S3 path layout standardized (`s3://bucket/project/env/run_id/...`) or per-team configurable? → **Answered**: Standardized S3 path layout recommended: `s3://bucket-name/mlflow/{experiment_id}/{run_id}/artifacts/`
   - What is the required fallback behavior if PostgreSQL is reachable but S3 artifact upload fails? → **Answered**: MLflow marks run as FAILED, logs error, leaves metadata in PostgreSQL, user must investigate S3 connectivity and retry

2. **Lambda.ai Slurm redundancy contract** ✅ RESOLVED
   - Which Slurm failure modes must be represented explicitly in the spec (`PENDING timeout`, `NODE_FAIL`, `PREEMPTED`, `CANCELLED`)? → **Answered**: All six failure modes (PENDING timeout, NODE_FAIL, PREEMPTED, CANCELLED, FAILED, TIMEOUT) must be represented.
   - What retry/escalation policy is required per failure mode? → **Answered**: Specific retry policies with exponential backoff and escalation alerts defined per failure mode.
   - Which metadata from Slurm (`job_id`, `partition`, `node_list`, `exit_code`) must always flow back into MLflow/Web UI? → **Answered**: 15 specific metadata fields must flow back including job_id, partition, node_list, exit_code, state, timestamps, resource allocations, and timelimit information.

3. **AWS Kubernetes contract (non-Lambda services)** ✅ RESOLVED
   - Which workloads are mandatory Kubernetes-managed vs explicitly not on Kubernetes? → **Answered**: Mandatory Kubernetes workloads include online inference services, batch processing orchestrators, observability services, core platform services (MLflow, model registry), and supporting infrastructure services. Explicitly non-Kubernetes workloads include Lambda.ai training jobs, infrastructure provisioning, local development workloads, and heavy batch processing.
   - What deployment states must be modeled for batch and online flows (`submitted`, `scheduled`, `running`, `succeeded`, `failed`, `rolled_back`)? → **Answered**: Batch flows include SUBMITTED, SCHEDULED, RUNNING, COMPLETED, FAILED, RETRYING, CANCELLED, TIMED_OUT. Online flows include DEPLOYING, HEALTH_CHECK, ACTIVE, DRAINING, ROLLED_BACK, FAILED. Kubernetes-specific states include PENDING, RUNNING, SUCCEEDED, FAILED, UNKNOWN.
   - What minimum observability payload is required from K8s runs (pod/job IDs, namespace, image digest, resource requests/limits)? → **Answered**: Required fields include pod_id, namespace, pod_name, container_id, image_digest, pod_status, resource allocation metrics (CPU/memory requests/limits), timing information, and optional enhancement fields. AWS CloudWatch integration and MLflow integration are also required.

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
