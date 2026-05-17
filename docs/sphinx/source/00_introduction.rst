---
title: "Introduction to ML Deploy"
---

# Introduction to ML Deploy

This page provides a concise overview of the entire repository stack, covering the purpose, system-at-a-glance description, and the software stack table.

## Repository Purpose and System-at-a-Glance

The ML Deploy platform is designed for full lifecycle management of machine learning workloads, with a focus on reproducibility, security, and multi-environment support.

## Software Stack Table

The stack is ordered from structuring choices to implementation-local concerns:

| Layer | Technology |
|-------|------------|
| Structuring Choices | Authorization, Promotion |
| Infrastructure | Nix, Terranix, OpenTofu |
| Authoring Workflow | nbdev, QMD, uv2nix |
| Python Environment | uv, Nix |
| Documentation | Quarto, Sphinx |
| WebUI | Custom Streamlit/FastAPI |
| Orchestration | Airflow, Kubeflow |
| Tracking | MLflow |
| Execution | Local, Slurm, Kubernetes |
| Stores | PostgreSQL, S3 |
| Local Emulation | Floci |
| Observability | Metrics, Logs, Traces |
| Cost | Attribution, Reporting |
| Assistant Access | MCP |
| Runtime | Python, Docker |
| CI | GitHub Actions |
| Testing | pytest, nbdev |

## Local vs Cloud Topology

- **Local**: Development environment using Floci for AWS emulation, local Kubernetes (K3s), and local Slurm.
- **Cloud**: AWS infrastructure with Lambda.ai for Slurm, managed services for other components.

## Lifecycle Flow

The platform follows a purpose-driven lifecycle:
1. Purpose (Notebooks) → Shared Notebook Source → Docs → Modules → WebUI
2. Airflow Orchestration → Optional Kubeflow (Kubernetes lane) → Runtime → Tracking → Promotion → Authorization
3. Observability → Cost → Infrastructure

## Key Follow-On Pages

- [Architecture](01_03-platform_architecture.rst): Detailed technical architecture
- [Runtime](04_01-execution_framework.rst): Execution backend details
- [Governance](04_05-governance_framework.rst): Governance and safety mechanisms

