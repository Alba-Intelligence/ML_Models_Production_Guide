---
title: "Stack Introduction"
---

# Introduction

This page is the front door for MLOps engineers joining the project. It starts with the purpose of the repository, then builds up from the broadest architectural principles into the concrete stack and runtime topology.

## Purpose

The repository exists to guide ML engineers through a complete, specification-first MLOps reference system: how to author it, how to govern it, how to run it locally or in cloud, and how to promote both models and platform changes safely.

## System-at-a-glance

The repository is a specification-first, documentation-first ML deployment guide with executable reference modules. It combines:

- **Purpose and governance** through explicit policy gates and contract-driven workflows.
- **Canonical authoring workflow** through nbdev + Quarto/QMD for ML researchers and architecture writers.
- **Centralized authorization** through OIDC-backed identity and policy-driven capability validation.
- **WebUI-first operations** for triggering notebook execution and monitoring run state.
- **Notebook-owned implementation modules** exported through nbdev.
- **Shared notebook source repository** used by both local emulation and cloud profiles.
- **Local/cloud parity** for infrastructure and runtime wiring.
- **Traceable ML lifecycle** through MLflow and stage-based promotion gates.
- **MLOps promotion control** for Nix/Terranix/OpenTofu system-definition changes.
- **Security, observability, and cost visibility** as first-class cross-cutting concerns.

## Software stack summary

The stack below is ordered from the most structuring choices to the most implementation-local ones.

### Infrastructure and Governance
- **Authorization**: OIDC IdP + Policy Engine for role management
- **Promotion Gates**: Model Artifacts + MLOps for DEV→UAT→REGRESSION→PROD approvals
- **Infrastructure**: Nix + Terranix for Docker/Compose/OpenTofu artifacts

### Development and Workflow
- **Package/Module**: nbdev + Quarto for ML-researcher workflow
- **Python**: uv2nix + uv for Nix-controlled dependencies
- **Documentation**: Quarto + Mermaid for publishable architecture docs

### Execution and Monitoring
- **Web Control**: WebUI + Contracts for execution and monitoring
- **Notebooks**: Shared Repository for local/cloud common source
- **Orchestration**: MLflow-native execution for workflow management
- **Kubernetes**: K3s for local development with optional cloud scaling

### Data and Tracking
- **Tracking**: MLflow for experiments, models, metrics, and UI visualization
- **Lineage**: MLflow Metadata for data training traceability
- **Execution**: Local/Slurm/Kubernetes for compute routing
- **Storage**: PostgreSQL + S3 for tracking and artifacts
- **Observability**: MLflow UI + CloudWatch/Floci for logs and metrics

### Local Environment
- **Local Emulation**: Docker + Floci + K3s for local compute
- **Observability**: Floci-emulated AWS CloudWatch + MLflow UI for metrics and telemetry
- **Cost Visibility**: Floci-emulated AWS Cost Explorer + MLflow tracking for spend reporting

### Quality and Access
- **Assistants**: Read-first + MCP for controlled access to facts
- **Runtime**: Python 3.13 for implementation modules
- **CI Gate**: GitHub Actions for export and testing
- **Validation**: unittest suite for contract and freshness checks

## Local/cloud topology

1. **Local emulation profile**: Docker Compose services for MLflow, PostgreSQL, Floci, Traefik, and local compute services (K3s + Slurm).
2. **Cloud profile**: AWS-hosted services with Traefik-fronted MLflow, PostgreSQL and S3-backed artifacts, and scheduler-integrated execution pathways.
3. **Generated artifacts**: Nix/Terranix is the canonical source that generates Docker, Docker Compose, and OpenTofu JSON artifacts.
4. **Kubeflow placement**: Kubeflow Pipelines sits in the Kubernetes execution lane; it is optional and complements Airflow orchestration rather than replacing Slurm-based paths.
5. **Local testing/emulation**: Kubeflow can run locally on K3s for workflow testing and parity checks before cloud rollout.
6. **Security and governance**: OIDC-backed identity plus a centralized policy engine governs roles, capabilities, audit, and request validation across systems and subsystems.
7. **MLOps promotion**: model artifacts and MLOps system-definition changes both use DEV→UAT→REGRESSION→PROD promotion gates.
8. **Assistant access**: infrastructure and documentation assistants stay read-first, least-privilege, and auditable.

## Lifecycle flow

```{mermaid}
flowchart TD
    Assistant["Read-first MCP / Docs Retrieval"] --> Docs
    NotebookSource["Shared Notebook Repository"] --> Docs["Quarto Docs (QMD)"]
    NotebookSource --> Modules["nbdev Exported Python Modules"]
    WebUI["WebUI Control Plane"] --> Runtime["Execution Backends (Local/Slurm/K8s)"]
    Docs --> WebUI
    Modules --> Runtime
    Airflow["Airflow Orchestration"] --> Runtime
    Airflow --> Kubeflow["Kubeflow Pipelines (K8s lane)"]
    Kubeflow --> Runtime
    Runtime --> Tracking["MLflow Tracking + Registry"]
    Tracking --> Gates["Promotion Gates (DEV->UAT->REGRESSION->PROD)"]
    Gates --> Infra["Nix/Terranix/OpenTofu + Docker Artifacts"]
    Auth["OIDC IdP + Central Policy Engine"] --> WebUI
    Auth --> Runtime
    Auth --> Infra
    Auth --> Gates
    Observability["MLflow UI + CloudWatch/Floci Logs"] --> Tracking
    Cost["AWS Cost Explorer + Floci Emulation + MLflow Tracking"] --> Infra
```

## Where to go next

- Platform architecture narrative: [`01_platform_narrative.rst`](01_03-platform_architecture.rst)
- Runtime and orchestration modules: [`07_mlflow_parity.rst`](02_03-mlflow_integration.rst), [`08_execution_backends.rst`](04_01-execution_framework.rst), [`14_infrastructure_mcp.rst`](03_02-infrastructure_management.rst)
- Governance and promotion gates: [`17_governance_gates.rst`](04_05-governance_framework.rst)
