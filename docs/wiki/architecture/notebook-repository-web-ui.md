---
updated: 2026-05-10
summary: Design for a centralized notebook repository web UI that enables engineers to browse, select, and trigger notebook executions across environments while keeping notebooks as the immutable source of truth.
read_when:
  - You are designing the interface for triggering model training/inference runs
  - You are implementing environment promotion workflows
  - You are integrating MCP tooling for monitoring and analysis
sources:
  - AGENTS.md
  - documentation-toc.md
  - nbdev-framework-decision.md
---

# Notebook Repository Web UI

## Purpose

Provide a centralized interface for ML engineers to interact with versioned notebooks, trigger executions across different environments (local replica, Lambda.ai Slurm, AWS Kubernetes), and monitor results—while preserving notebooks as the immutable source of truth.

## Scope and Non-Goals

### In Scope

- Browsing and searching versioned notebooks from the repository
- Executing notebooks with environment-specific configuration injection
- Triggering runs against local replica architecture for development/testing
- Promoting successful runs to production environments (Lambda.ai Slurm, AWS Kubernetes)
- Viewing and monitoring execution results linked to MLflow tracking
- Launching MCP-powered monitoring and analysis tools from execution results
- Role-based access control for notebook access and execution triggering

### Out of Scope

- Editing notebooks through the UI (notebooks remain source of truth in Git)
- Storing execution parameters within notebooks themselves
- Duplicating MLflow tracking functionality (links to existing MLflow UI)
- Long-term notebook storage (uses Git as source of truth)

## Upstream Dependencies

- Git repository containing nbdev notebooks (source of truth)
- MLflow tracking server (for execution results and model lineage)
- Local replica architecture (Slurm-like scheduler, K8s, MinIO, PostgreSQL)
- Production infrastructure (Lambda.ai Slurm, AWS Kubernetes, S3, RDS)
- MCP server ecosystem (for monitoring/analysis tooling)
- Authentication/authorization system (for role-based access)

## Domain Ownership

- **Primary**: ML Engineering / Platform Team
- **Secondary**: DevOps / Infrastructure Team (for environment provisioning)
- **Tertiary**: Data Science Leadership (for oversight and governance)

## Contracts Consumed

- **From Git**: Immutable notebook versions via commit references
- **From MLflow**: Run metadata, metrics, artifacts, and model registry entries
- **From Environment APIs**: Job submission/status interfaces (Slurm, K8s)
- **From MCP**: Monitoring and analysis capabilities triggered from execution results

## Contracts Produced

- **Execution Triggers**: Standardized job specifications for each target environment
- **Configuration Injection**: Environment-specific parameters passed to notebook execution
- **Result Links**: References to MLflow runs, artifacts, and model versions
- **MCP Invocations**: Context for launching assistant-assisted monitoring workflows

## Run visibility baseline

The initial monitoring UX should be MLflow-first:

- Web UI exposes run status/metadata summaries
- each run provides a direct link to the corresponding MLflow run page
- deeper diagnosis flows begin by pivoting engineers to MLflow, then to observability/cost tools as needed

## Topology Relevance

- **Local Development**: Primary interface for triggering runs against local replica
- **Environment Promotion**: Gateway for moving validated runs to production
- **Production Monitoring**: Launchpad for MCP-assisted analysis of production executions
- **Governance**: Audit trail of who triggered what, when, and with which configuration

## Operational/Security/Lineage Implications

- **Immutability Guarantee**: Notebooks cannot be altered through the UI; changes must go through Git
- **Execution Traceability**: Every run links back to exact notebook version + execution config
- **Environment Parity**: Same notebook runs against local replica and production (with config differences)
- **Secret Management**: Execution credentials/tokens injected securely at runtime, never stored
- **Role-Based Execution**: Different roles may have access to different environments or notebook sets
- **Cost Attribution**: Executions tagged with user/project for cost governance visibility

## Code Examples Linked

- [example: notebook-execution-trigger] - How to trigger a notebook execution via the web UI API
- [example: configuration-injection-pattern] - Patterns for environment-specific parameter passing
- [example: mlflow-result-linkage] - How execution results connect to MLflow tracking
- [example: mcp-analysis-launch] - Launching MCP-powered monitoring from execution results

## Open Questions and Deferred Decisions

1. **Execution Configuration Contract**: exact required schema for runtime parameters and environment overrides.
2. **Approval Workflows**: exact gate model for promoting local-validated runs to Lambda.ai/AWS environments.
3. **Notebook Intake Controls**: supported upload sources (direct upload vs Git-only) and mandatory validation pipeline.
4. **Slurm/Kubernetes Mapping**: exact translation layer from notebook execution request into Slurm jobs and Kubernetes workloads.
5. **UI Technology Stack**: what framework/library should implement the web interface (Streamlit, Gradio, custom React/Vue).

## Recommended Implementation Approach

1. Start with a simple prototype that lists notebooks from Git and allows manual execution triggering
2. Add environment selection (local replica vs. production targets)
3. Implement configuration injection mechanism (external YAML/JSON files)
4. Link execution results to MLflow runs
5. Add direct MLflow run links and run-status views in the Web UI
6. Add role-based access control
7. Integrate MCP tool launching from execution results
8. Implement approval workflows for production promotions
9. Add advanced features like notebook diffing, version comparison, and branching
