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

4. **python-terraform ownership boundary** ✅ RESOLVED
   - Which infrastructure components must be generated/controlled only via `python-terraform` wrappers? → **Answered**: ALL infrastructure components MUST be generated/controlled exclusively through Nix/Terranix/OpenTofu workflows with no exceptions for core components.
   - Are hand-written Terraform files ever allowed, and if yes, for which exceptions? → **Answered**: NO hand-written Terraform/OpenTofu files are allowed for core infrastructure. Limited acceptable exceptions include external service dependencies, emergency hotfixes, and provider-specific native features, but only with documented justification and migration plans.
   - What spec artifact proves parity between generated Terraform JSON and deployed resources? → **Answered**: OpenTofu state diff verification, infrastructure inventory verification, configuration hash verification, and acceptance tests demonstrating parity between generated OpenTofu JSON and deployed resources.

5. **Docker-first reproducibility vs Nix helper boundary** ✅ RESOLVED
   - Which workflows must be reproducible from Docker alone with no Nix dependency? → **Answered**: ALL workflows must be reproducible from Docker alone with no Nix dependency. Containers are built via Nix but run as standard Docker images without Nix runtime.
   - Which Nix outputs are allowed as helper-only artifacts without becoming the canonical runtime path? → **Answered**: Nix helper artifacts include build scripts, configuration files, dependency lists, build metadata, and documentation. The canonical runtime path is always the Docker image.
   - What acceptance test demonstrates local Docker parity with production storage/control planes? → **Answered**: Comprehensive tests verify Docker image build, push, run, inspection, and export/import capabilities without Nix dependency.
   - Which workflows must be reproducible from Docker alone with no Nix dependency?
   - Which Nix outputs are allowed as helper-only artifacts without becoming the canonical runtime path?
   - What acceptance test demonstrates local Docker parity with production storage/control planes?

6. **Immutable notebook Web UI execution contract**
   - Notebook Reference Format: What constitutes an immutable notebook reference? (git commit SHA only vs git tag vs approved branch refs vs semantic version tags) How do we handle git history rewriting? What about notebook versioning strategy (sequential numbering vs semantic versioning)?
   - Runtime Parameter Variability: Which parameters are locked by notebook revision (code version, dependencies, compute requirements) vs allowed to vary (hyperparameters, input data paths, resource scaling) vs fully dynamic (user preferences, environment-specific configs)? How do we parameterize different environments (dev/staging/prod) while maintaining immutability?
   - Execution Status Timeline: What exact status progression must be displayed for all execution backends (Slurm, Kubernetes, local)? What are the status transitions (PENDING → SCHEDULING → RUNNING → COMPLETED/FAILED/CANCELLED)? How do we handle retries, rollbacks, and manual interventions? What are the timeout policies and how are they displayed?
   - Web UI Integration: How do we integrate with existing MLflow/Web UI patterns? What metadata must be displayed (git commit, execution time, resource usage, parameters, outputs)? How do we handle notebook version conflicts and rollback capabilities?

7. **Cross-Topology Security + Lineage Minimums**
   - Secrets Management: Which secrets must be runtime-injected only (database credentials, API keys, encryption keys, cloud credentials) and never persisted in notebooks, logs, or MLflow params? What are the allowed secret sources (AWS Secrets Manager, HashiCorp Vault, Kubernetes secrets) and injection mechanisms (environment variables, mounted volumes, secret managers)? How do we handle secret rotation and lifecycle management?
   - Identity and Audit Trail: What identity fields are mandatory on every action (user ID, service account, external system ID)? What role information must be captured (role name, permissions, scope)? What audit fields are required (timestamp, IP address, user agent, request ID)? How do we handle approval workflows and ticket references (JIRA ticket, GitHub PR, manual approval ID)? What are the retention policies for audit data?
   - Lineage Break Conditions: Which conditions should trigger hard-stop failures (missing lineage fields, invalid data provenance, unauthorized parameter changes, broken dependency chains, security policy violations)? What are the validation rules for lineage completeness (data source tracking, model versioning, execution environment snapshotting)? How do we handle partial lineage vs complete lineage requirements?
   - Cross-Topology Consistency: How do we ensure security and lineage requirements are consistently applied across all topologies (local development, distributed training, batch inference, online serving)? What are the minimum requirements for each topology? How do we handle topology-specific exceptions vs baseline requirements?

## Done criteria for this question set

- Each question is answered in a normative page (decision, contract, or topology spec), not only in notes.
- Each answer includes at least one acceptance criterion that can be tested.
- Open items are explicitly deferred with owner and revisit trigger.
