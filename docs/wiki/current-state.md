---
updated: 2026-05-14
summary: Honest snapshot of the repository's present state, notable constraints, and likely next steps.
read_when:
  - You need a current repo snapshot
  - You are deciding what to change next
sources:
  - sources/flake.nix.md
  - sources/devenv.nix.md
  - sources/flake.lock.md
  - sources/.dockerignore.md
  - sources/Dockerfile.md
  - sources/docker-compose.dev.yml.md
  - sources/docker-compose.cloud.yml.md
  - sources/gitignore.md
  - sources/LICENSE.md
  - sources/README.md
  - sources/_quarto.yml.md
  - sources/.github.workflows.ci.yml.md
  - sources/ml_deploy.vertical_slice.py.md
  - sources/nbs.06_vertical_slice.qmd.md
  - sources/tests.test_vertical_slice.py.md
  - architecture/target-system.md
  - architecture/reference-architecture-skeleton.md
  - architecture/documentation-toc.md
  - architecture/assistant-integration-and-docs-delivery.md
  - architecture/example-matrix.md
  - architecture/first-vertical-slice.md
  - architecture/webui-backend-contract.md
  - architecture/distilled-allium-spec.md
  - architecture/local-emulation-stack.md
  - contracts/index.md
  - contracts/security-baseline.md
  - domains/index.md
  - topologies/index.md
  - decisions/project-scope-and-constraints.md
  - decisions/notebook-intake-validation-and-approval.md
  - decisions/mlflow-postgres-s3-contract.md
  - decisions/lambda-ai-slurm-contract.md
  - decisions/security-authorization-architecture.md
  - sources/nbs.reference.03_Security_Authorization_and_Policy.qmd.md
  - sources/ml-deploy-reference-repo.allium.md
  - sources/ml_deploy.webui_contracts.py.md
  - sources/ml_deploy.execution_backends.py.md
  - sources/ml_deploy.mlflow_parity.py.md
  - sources/ml_deploy.governance_gates.py.md
  - sources/ml_deploy.notebook_intake.py.md
  - sources/nbs.07_mlflow_parity.qmd.md
  - sources/nbs.00_introduction.qmd.md
  - sources/nbs.14_infrastructure_mcp.qmd.md
  - sources/nbs.08_execution_backends.qmd.md
  - sources/nbs.09_notebook_intake.qmd.md
  - sources/nbs.01_platform_narrative.qmd.md
  - sources/nbs.12_system_interaction_analysis.qmd.md
  - sources/nbs.13_opentofu_infra.qmd.md
  - sources/nbs.17_governance_gates.qmd.md
  - sources/nbs.15_aws_emulator.qmd.md
  - sources/nbs.16_terranix_infra.qmd.md
  - sources/docker-compose.aws-emulator.yml.md
  - sources/nix.modules.local.nix.md
  - sources/nix.modules.shared.nix.md
  - sources/nbs.index.qmd.md
  - sources/nbs.05_webui_contracts.qmd.md
  - sources/tests.test_webui_contracts.py.md
  - sources/tests.test_docs_freshness.py.md
  - sources/tests.test_mcp_infrastructure_contracts.py.md
  - sources/tests.test_infrastructure_mcp.py.md
  - sources/tests.test_docker_artifacts_generation.py.md
  - sources/tests.test_governance_gates.py.md
  - sources/tests.test_promotion_pipeline.py.md
  - sources/scripts.finalize-task.sh.md
  - sources/scripts.generate-docker-artifacts.py.md
  - sources/nix.terranix.docker-artifacts.nix.md
  - sources/scripts.regenerate-html.sh.md
  - gaps/index.md
  - gaps/software-stack-gaps.md
  - queries/spec-quality-elicitation-session-01.md
---

# Current state

## Snapshot

As of 2026-05-11, the repository contains:

- `LICENSE`
- `flake.nix`
- `flake.lock` (local, but currently gitignored)
- `.gitignore`
- `AGENTS.md`
- `_quarto.yml` (root Quarto project for repository docs output)
- `.github/workflows/ci.yml` (CI pipeline for export/render/tests)
- `devenv.nix`, `devenv.yaml`, and `devenv.lock`
- `docs/wiki/` (the living memory layer, now including architecture decision for notebook repository web UI)
- `specs/ml-deploy-reference-repo.allium` (distilled repository-level Allium specification)
- nbdev 3 project structure with `pyproject.toml`, `nbs/` directory for notebooks, and `ml_deploy/` package
- `nbs/05_webui_contracts.qmd` as nbdev source for Web UI backend contracts
- `nbs/06_vertical_slice.qmd` as nbdev source for first-vertical-slice implementation
- `nbs/07_mlflow_parity.qmd` as nbdev source for MLflow parity helpers
- `nbs/08_execution_backends.qmd` as nbdev source for backend execution adapters
- `nbs/09_notebook_intake.qmd` as nbdev source for notebook intake validation
- `nbs/reference/03_Security_Authorization_and_Policy.qmd` as nbdev source for the traditional auth/roles/policy reference posture
- `nbs/01_platform_narrative.qmd` as the canonical platform architecture narrative page
- `nbs/00_introduction.qmd` as the stack-wide introduction page summarizing software and infrastructure layers
- Quarto `.qmd` counterparts for all active nbdev notebooks in `nbs/` (docs rendering path)
- runtime helper modules for MLflow parity, execution adapters, intake validation, OpenTofu infrastructure, and infrastructure MCP interrogation
- git metadata for a repository now rebased onto `origin/main`

## What is working

- A Nix dev shell can provision a curated toolchain.
- The shell includes Python 3.13, `uv`, `pyright`, `sphinx`, Typst tools, and multiple AI coding-agent CLIs.
- Quarto is now explicitly packaged in both `flake.nix` and `devenv.nix` shells for nbdev docs rendering.
- The shell now exposes `allium` as a `naersk`-built Nix package (`allium-cli` 3.2.3).
- A single helper command (`start-jupyter`) handles kernel setup and JupyterLab launch.
- The auxiliary devenv config now mirrors the same `allium` (naersk build) and Python-backed `start-jupyter` behavior.
- The shell can create/sync and activate a local `.venv` via `uv` using the current `pyproject.toml`.
- `nix develop` no longer depends on building the editable workspace package through uv2nix during shell entry.
- A git repository exists and is currently at `main`, with the local planning commits rebased onto the GitHub origin history.
- The project now has a much clearer target specification captured in the wiki.
- The reference architecture skeleton and documentation TOC are now ratified in the wiki.
- The project now also has accepted defaults for MCP scope (including infrastructure interrogation when MCP servers are available), monitoring stack, cost stack, Docker/Nix posture, and docs-delivery posture captured in decision records.
- Infrastructure MCP coverage now has explicit minimum interrogation aspects (IaC state/plans, Kubernetes runtime state, Lambda.ai/Slurm runtime state, cloud resource inventory, cost/usage signals) plus a default-vs-optional server inventory decision page.
- The first pass of cross-cutting contract pages now exists in the wiki.
- The first pass of bounded domain pages now exists in the wiki.
- The topology pages now include explicit control/data/artifact flow specifications and contract checkpoints.
- The first architecture-aligned example matrix now exists in the wiki.
- The first implementation-aligned architecture slice is now defined in `architecture/first-vertical-slice.md`.
- The first local vertical slice is now implemented in `ml_deploy/vertical_slice.py` with tests in `tests/test_vertical_slice.py`.
- The vertical-slice module is now Quarto-owned and exported from `nbs/06_vertical_slice.qmd`.
- A thin Web UI backend contract module now exists in `ml_deploy/webui_contracts.py` with tests in `tests/test_webui_contracts.py`.
- Spec-propagated tests now enforce documentation-series completeness obligations in `tests/test_documentation_series_contracts.py`.
- Spec-propagated tests now also enforce infrastructure MCP scope and minimum interrogation-aspect obligations in `tests/test_mcp_infrastructure_contracts.py`.
- The Web UI contract module is now Quarto-owned and exported from `nbs/05_webui_contracts.qmd`.
- Execution adapter mappings now exist for local, Slurm, and Kubernetes payloads.
- The traditional auth/roles/policy posture is now documented in `nbs/reference/03_Security_Authorization_and_Policy.qmd` and mirrored in the wiki.
- Notebook intake validation gates now exist for immutable refs, notebook structure, and optional nbdev export checks.
- Nix/Terranix-oriented OpenTofu infrastructure helpers and documentation now describe the platform bootstrap story, and repository Docker artifacts are generated from Nix Terranix definitions.
- Runtime helper modules are now Quarto-owned and exported through nbdev, not maintained as hand-edited Python sources.
- MLflow parity helpers now also render local emulation compose configuration (Floci, K3s, Slurm) and a merged full local-emulation stack config.
- Infrastructure MCP interrogation now has a concrete helper module that turns available server inventory into the required default assistant scope and realized infrastructure aspects.
- The old Python Terraform-bootstrap helper path has been removed; Nix/Terranix-generated OpenTofu remains the active infrastructure bootstrap direction.
- Runtime orchestration now routes notebook execution requests across local, Slurm, and Kubernetes targets with explicit submitted/completed backend states.
- Docker-first reproducible development is now implemented with `Dockerfile` and `docker-compose.dev.yml` (data plane: MLflow, PostgreSQL, Floci-backed artifacts).
- **Phase 1 (2026-05-12):** Traefik reverse proxy service now integrated into `docker-compose.dev.yml` (local_emulation profile).
  - MLflow routed through Traefik with Docker label-based routing (`/mlflow` path prefix).
  - Dev container updated to use Traefik endpoint; dashboard accessible on port 8080.
  - MlflowTrackingServer dataclass added to `ml_deploy/mlflow_parity.py` with new `reverse_proxy_tool: Literal["traefik"]` field (spec compliance w007).
  - Terranix infrastructure generation approach documented in `nix/TERRANIX_IMPLEMENTATION.md` with Phase 1 (script-based) and Phase 2 (full integration) recommendations.
  - Re-audit conducted post-spec-update; 6 of 9 divergences resolved or documented (w001, w007, w008, w009 complete; w004 documented; w002, w003, w005, w006 pending Phase 2).
- **Phase 1.5 (2026-05-12):** Drift gaps from the weed audit are now implemented in code.
  - `scripts/generate-docker-artifacts.py` now regenerates `Dockerfile`, `docker-compose.dev.yml`, `docker-compose.aws-emulator.yml`, and `docker-compose.cloud.yml` from `nix/terranix/docker-artifacts.nix`.
  - Cloud profile compose artifact now includes Traefik-fronted MLflow and `MLFLOW_CREATE_MODEL_VERSION_SOURCE_VALIDATION_REGEX`.
  - Promotion pipeline gate logic now exists in `ml_deploy/vertical_slice.py` (`promote_model_artifact`) with dedicated tests.
  - Spec-first implementation gating now has executable state/decision logic in `ml_deploy/governance_gates.py`.
  - Shell entry sync logic now supports explicit requests (`UV_SYNC_REQUESTED=1`) and dependency-drift checks (`uv sync --check`) in both `flake.nix` and `devenv.nix`.
- **Phase 1.6 (2026-05-13):** Remaining weed decisions from check-mode are now implemented.
  - Full local emulation compose now merges data plane, compute plane, and AWS emulator services (`floci`, `floci_bootstrap`) in one renderer.
  - Governance gate behavior now allows no-op requests when repository phase is already `implementation_enabled`.
  - Distilled Allium spec now includes explicit promotion/MLflow safety contracts and top-level invariants for implementation gating and production/cloud safety properties.
  - Rendered Quarto docs under `_docs/nbs/*.html` are now tracked and validated against numbered source filenames (for example `00_core.qmd -> 00_core.html`).
- **Local AWS emulator** now exists in `docker-compose.aws-emulator.yml` (Floci + bootstrap).
- **Local emulation compute plane** now exists in `docker-compose.local-infra.yml` (K3s, Slurm-Docker).
- **Nix/Terranix module structure** now exists in `nix/` (shared, local, cloud modules; local and cloud profiles) and is mirrored in self-contained Quarto docs pages.
- The docs now need to read top-down, include Mermaid diagrams where they help, and expose implementation-relevant code/config from the published pages.
- The distilled Allium spec now explicitly requires docs to be self-sufficient for implementation: repository source browsing must be unnecessary for required behavior/config/wiring.
- **Dual-mode OpenTofu spec** is encoded: `DeploymentProfile` enum, `LocalEmulationStack` entity, `RequireLocalEmulationParity` rule in Allium spec.
- **Quarto page 13** (`nbs/13_opentofu_infra.qmd`) documents the dual-mode infrastructure profile architecture.
- A full five-layer system interaction analysis now exists in Quarto-page and wiki forms.
- A distilled repository-wide Allium specification now exists and is indexed in the wiki.
- An nbdev 3 project structure has been initialized with pyproject.toml, nbs/ directory, and ml_deploy/ package placeholder.
- `nbs/00_core.qmd` now doubles as a practical MLflow + XGBoost quickstart alongside the package scaffold.
- Notebooks can be successfully exported to Python packages using `nbdev-export --path nbs/`.
- A single end-of-task command now exists to export notebooks, render docs, and run tests: `./scripts/finalize-task.sh`.
- A canonical platform narrative Quarto page now owns the architecture story and Mermaid diagram.
- The platform narrative's component-interaction overview now explicitly includes data-lineage coupling and role/capability security checks across data, modeling, execution (local/cloud), infrastructure, and promotion actions.
- The detailed entity-relationship/responsibility class diagram was moved from the top-level platform narrative to the system interaction analysis page to keep introductory content concise.
- The distilled Allium spec now explicitly encodes the same documentation split: interaction overviews must include lineage/security-capability coverage, and detailed entity relationship maps must live in the interaction-analysis layer rather than the introductory narrative.
- The rendered docs homepage is now Quarto-driven (`nbs/index.qmd`) and functions as navigation-first entrypoint.
- The docs now include a dedicated stack introduction page (`nbs/00_introduction.qmd`) linked from homepage foundations and sidebar navigation.
- The stack introduction page now explicitly frames the whole stack in purpose-first order: canonical nbdev/QMD authorship, uv2nix-managed Python environments, WebUI as primary control plane, MLflow-native execution for workflow management, K3s for local development with optional cloud scaling, shared notebook repository flow across local/cloud, central authorization, MLOps promotion gates, MLflow UI + CloudWatch/Floci for observability, Floci-emulated AWS Cost Explorer + MLflow tracking for cost visibility, and Nix/Terranix as canonical artifact-generation source.
- Full Quarto website generation from `.qmd` sources succeeds via `nix develop -c quarto render . --no-execute`.
- Rendered Quarto outputs are refreshed under `_docs/nbs/*.html` with `_docs/index.html` as root entrypoint; that root page now forwards to the Quarto navigation homepage at `_docs/nbs/index.html`, whose links target HTML docs, the root sidebar no longer references the retired Terraform-bootstrap page, and the stale legacy `nbs/_docs/` snapshot has been removed.
- CI now enforces export/render/tests on pull requests and pushes, including docs freshness coverage.

## Current limitations

- `ipykernel` is included in the flake-provided toolchain for Jupyter kernel setup.
- Building `allium` may require network access for Rust crate dependency fetches during Nix builds.
- CUDA support is explicitly commented out in `flake.nix`.
- There is no production-ready ML data pipeline or deployment implementation yet.
- Contract validation is currently test-level for the local vertical slice, not yet generalized across all topologies.
- New architecture requirements now specify MLflow PostgreSQL/S3 storage, Lambda.ai Slurm coordination/redundancy, AWS Kubernetes for non-Lambda.ai services, and Nix (flake+devenv) Terranix-generated OpenTofu JSON infrastructure workflows; OpenTofu apply orchestration remains partly documented.
- Dual-profile (`local_emulation | cloud`) infrastructure now implemented: `docker-compose.aws-emulator.yml` (Floci), `docker-compose.local-infra.yml` (K3s + Slurm), Nix/Terranix modules in `nix/modules/` and `nix/profiles/`, and Quarto pages `nbs/13_opentofu_infra.qmd`, `nbs/15_aws_emulator.qmd`, `nbs/16_terranix_infra.qmd`.
- Allium spec now covers MLflow storage backends (SQLite/PostgreSQL/S3-compatible local emulation), security (reverse proxy, MLFLOW_CREATE_MODEL_VERSION_SOURCE_VALIDATION_REGEX, central OIDC-backed authorization authority, capability catalogs, and request validation), and parallel DEV→UAT→REGRESSION→PROD promotion gates for both model artifacts and MLOps system definitions (Nix/Terranix/OpenTofu) with approval controls.
- Zero open questions formally recorded in the spec (all original 7 questions now resolved with expanded details). (Lambda.ai scheduling preference, MLflow PostgreSQL+S3 contract, AWS Kubernetes, Nix/Terranix boundary, and Nix containerization decisions resolved)
- mlflow-go (`mlflow-go` server + `mlflow-go-backend` Python package) is the recommended approach for profile-switchable MLflow tracking (SQLite local, PostgreSQL cloud — no code changes required).
- Slurm/Kubernetes paths currently emit backend-ready submission payloads, but external scheduler client integrations remain to be connected.
- The distilled Allium spec currently models repository posture, shell behavior, and governance constraints; it does not yet cover any real ML implementation logic because that code still does not exist.
- The distilled Allium spec now also models a spec-quality readiness gate required for default implementation allowance.
- The distilled Allium spec now models notebook-series completeness requirements (architecture steps, trade-offs, security, examples, audience learning paths, and implementation/docs linkage).
- `flake.lock` is intentionally not tracked by git under the current ignore rules; local lockfile churn is expected and non-canonical.
- Full Quarto render with execution enabled depends on a valid active Jupyter kernel path; `--no-execute` is the stable validation mode for docs generation.
- The origin currently contributes a `LICENSE` file, while the expected remote `README.md` was not present during synchronization.

## Repo posture

The repo is currently best understood as a **specification-first and documentation-first bootstrap**, not as a completed or started ML deployment system.

## Most likely next additions

**Phase 2 (Immediate priorities — spec-first implementation gating):**

- Enforce generated-artifact freshness in CI as a hard-fail path (generation drift must fail builds).
- Connect governance and promotion gate helpers into runtime orchestration paths beyond unit tests.
- Extend cloud profile Traefik/MLflow security wiring from compose artifacts into Terranix/OpenTofu apply-time resources.
- Complete documentation restructuring plan (Tutorial/Reference separation)

**Phase 3+ (Downstream work):**

- local replica topology that mirrors production control planes (Kubernetes/Slurm/storage) where feasible
- deeper executable coverage for remote scheduler lifecycle states (submitted/running/failed/finished)
- promotion of the implemented local slice into Docker-first execution flow
- expansion into distributed, batch, and online production topologies
- notebook Web UI execution flow with immutable notebook source semantics
- concrete Slurm/Kubernetes submission clients and orchestration runners on top of current mapping helpers
- validation hooks for contract compliance checks

## If you are modifying the repo

- Keep architecture/spec quality first; implement concrete slices only when user-directed and keep wiki in lockstep.
- Scope and stack decisions should update [architecture/target-system.md](architecture/target-system.md) and [decisions/project-scope-and-constraints.md](decisions/project-scope-and-constraints.md).
- Changes to shell packages or startup behavior should update [architecture/dev-environment.md](architecture/dev-environment.md).
- Changes to commands or Jupyter behavior should update [runbooks/jupyter-and-shell.md](runbooks/jupyter-and-shell.md).
- Any new important root file should get a source summary under `docs/wiki/sources/`.
- When working on documentation restructuring, follow the plan in `docs/wiki/plans/documentation-restructuring-plan.md`
- Update progress as tasks are completed and report new issues discovered

## Observability Stack (2026-05-15)

**Lightweight MLflow + Floci Approach**: Updated observability strategy to eliminate heavyweight components while maintaining perfect local/cloud parity.

### Components:

- **MLflow UI**: Native experiment visualization and tracking
- **MLflow Tracking**: Complete experiment metadata capture
- **MLflow Model Registry**: Model versioning and promotion
- **MLflow Metrics**: Performance metrics collection
- **CloudWatch/Floci**: Application logs and audit trails (emulated locally, real in cloud)
- **Floci-emulated AWS Cost Explorer**: Local cost visibility with MLflow tracking
- **K3s**: Lightweight Kubernetes for local development with cloud scaling

### Benefits:

- Perfect local/cloud parity with Floci AWS emulation
- Minimal infrastructure overhead (no Prometheus/Grafana/Airflow/Kubeflow)
- Unified MLflow experience across environments
- Industry-standard ML tracking capabilities
- Cost-effective with no additional licensing requirements

### Implementation:

- Local: Floci emulates all AWS services including CloudWatch
- Cloud: Real AWS CloudWatch services with identical MLflow API
- Observability needs fully met through MLflow + CloudWatch/Floci stack

**Note**: This represents a significant simplification from the previous Prometheus/Grafana/Airflow/Kubeflow approach, maintaining full functionality while reducing complexity.
