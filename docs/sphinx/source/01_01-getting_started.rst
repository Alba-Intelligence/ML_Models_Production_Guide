---
title: "ML Deploy Reference"
---

# Welcome to the ML Deployment Reference

This documentation provides a **self-contained, specification-driven guide** to the ML deployment platform. All diagrams, code examples, and infrastructure definitions are published directly in these pages—**no repository source browsing required**.

## Reading Guide

The platform documentation is organized around a **Platform Overview** with five logical subsections. Choose your entry point based on your role:

### For Infrastructure & Operations Engineers

Start with system components, then dive into deployment and infrastructure:

```{mermaid}
graph TD
    A["Platform Overview<br/>01_02-platform_introduction.rst"] -->|System Components & Roles| B["Entity Models<br/>Class Diagrams"]
    A -->|Deployment & Infrastructure| C["Local vs Cloud<br/>Topology Diagrams"]
    A -->|Governance & Safety| D["Promotion Gates<br/>State Machines"]
    B --> E["Execution Backends<br/>08_execution_backends.rst"]
    C --> F["Infrastructure MCP<br/>14_infrastructure_mcp.rst"]
    F --> G["OpenTofu & Terranix<br/>13_opentofu_infra.rst"]
    D --> H["Governance Gates<br/>17_governance_gates.rst"]
```

**Recommended path:**
1. [Platform Overview — System Components](01_03-platform_architecture.rst#1-system-components--roles)
2. [Platform Overview — Deployment & Infrastructure](01_03-platform_architecture.rst#3-deployment--infrastructure)
3. [Execution Backends](04_01-execution_framework.rst)
4. [Infrastructure MCP](03_02-infrastructure_management.rst)
5. [OpenTofu & Terranix](03_01-infrastructure_as_code.rst)

### For Data Scientists & ML Researchers

Start with platform architecture, then focus on model development and promotion:

```{mermaid}
graph TD
    A["Platform Overview<br/>01_02-platform_introduction.rst"] -->|Execution & Data Flow| B["Workflows<br/>Sequence Diagrams"]
    A -->|Learning Paths| C["ML Researcher Path<br/>Recommended Reading"]
    B --> D["Vertical Slice<br/>06_vertical_slice.rst"]
    D --> E["Data & Training<br/>02_data + 03_model_training"]
    E --> F["MLflow Parity<br/>07_mlflow_parity.rst"]
    F --> G["Model Promotion<br/>17_governance_gates.rst"]
```

**Recommended path:**
1. [Platform Overview — Execution & Data Flow](01_02-platform_introduction.rst#2-execution--data-flow)
2. [Vertical Slice Reference](02_04-complete_workflow.rst)
3. [Data & Model Training](02_01-data_management.rst) + [Model Training](02_02-model_development.rst)
4. [MLflow Parity Setup](02_03-mlflow_integration.rst)
5. [Model Promotion & Governance](04_05-governance_framework.rst)

---

## Foundations

- [Stack introduction](01_02-platform_introduction.rst)
- [Platform narrative](01_03-platform_architecture.rst)
- [Core module baseline](01_04-core_concepts.rst)

## Lifecycle notebooks

- [Data loading and exploration](02_01-data_management.rst)
- [Model training](02_02-model_development.rst)
- [Web UI reference context](04_04-user_interfaces.rst)
- [Vertical slice reference](02_04-complete_workflow.rst)
- [Web UI contracts](04_03-api_contracts.rst)

## Topology and operations notebooks

- [MLflow parity](02_03-mlflow_integration.rst)
- [Infrastructure MCP interrogation](03_02-infrastructure_management.rst)
- [Execution backends](04_01-execution_framework.rst)
- [Notebook intake validation](04_02-notebook_management.rst)

## Architecture analysis

- [System interaction analysis](05_01-system_architecture.rst)
- [OpenTofu infrastructure architecture](03_01-infrastructure_as_code.rst)
- [Floci AWS emulator](03_03-local_development.rst)
- [Terranix infrastructure source](03_04-terraniq_integration.rst)

---

## Quick Start

### Option 1: I want to understand the system (5 min)
→ Read [Platform Overview](01_03-platform_architecture.rst) sections 1–3

### Option 2: I want to set up local development (15 min)
→ [MLflow Parity](02_03-mlflow_integration.rst) + [Execution Backends](04_01-execution_framework.rst)

### Option 3: I want to run a complete example (20 min)
→ [Vertical Slice Reference](02_04-complete_workflow.rst)

### Option 4: I want to deploy to production (30 min)
→ [OpenTofu & Terranix](03_01-infrastructure_as_code.rst) + [Governance Gates](04_05-governance_framework.rst)

---

## Navigation Tips

- **All diagrams are in Mermaid format** — Rendered directly in the pages
- **All code examples are copy-pastable** — No need to hunt in the repository
- **Cross-links connect related sections** — Use them to navigate by topic
- **Learning paths are role-specific** — Choose the path that matches your background

---

## Key Principles

1. **Self-contained documentation**: Implement the system from these pages alone
2. **Hierarchical structure**: Start broad (architecture), then dive deep (details)
3. **Extensive diagramming**: Class, sequence, state machine, and topology diagrams for each subsection
4. **Spec-driven**: All behavior is specified first, then implemented
5. **Traceability**: MLflow links all training to promotion workflows
