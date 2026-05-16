ML Deploy Terminology Glossary
=============================

This comprehensive glossary provides standardized definitions for key terms and concepts used throughout the ML Deploy documentation. Understanding these terms is essential for effectively navigating the platform architecture, implementation patterns, and deployment workflows. Each definition includes key components, practical purposes, and contextual relationships to other concepts.

Foundational Concepts: EX-Series Vertical Slices
------------------------------------------------

EX-01: Training with Traceability
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

**Definition**: A comprehensive training workflow that captures extensive metadata throughout the model training process, ensuring full reproducibility, complete lineage tracking, and auditability of every training execution.

**Key Components**:
- **Model Training Execution**: Core training algorithm execution with comprehensive parameter tracking
- **MLflow Experiment Tracking**: Structured experiment management with automatic metadata capture
- **Comprehensive Metadata Capture**: Dataset version information, hyperparameter configurations, environment snapshots, and dependency tracking
- **Training Artifact Storage**: Systematic storage and versioning of model checkpoints, logs, and intermediate results
- **Complete Audit Trail**: Immutable record of all training decisions, parameters, and outcomes for reproducibility

**Purpose**: Establishes the foundational layer for all ML workloads by ensuring that every training run is fully traceable, reproducible, and auditable. This creates the necessary groundwork for subsequent deployment and operational phases.

**Relationship Context**: Serves as the starting point for the EX-01 → EX-02 → EX-03 workflow, providing the trained models and metadata that feed into the artifact bundling phase.

EX-02: Artifact Bundling and Versioning
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

**Definition**: The systematic process of packaging trained models, associated artifacts, and comprehensive metadata into versioned, deployment-ready bundles that maintain integrity across different environments and deployment scenarios.

**Key Components**:
- **Model Serialization**: Conversion of trained PyTorch models, preprocessing pipelines, and configuration objects into portable formats
- **Version Registration**: Automatic registration of model artifacts in MLflow model registry with semantic versioning
- **Artifact Bundling**: Comprehensive packaging of model weights, preprocessing steps, configuration files, and dependencies into cohesive units
- **Semantic Versioning**: Implementation of version promotion tracking with clear upgrade paths and rollback capabilities
- **Immutable Artifact References**: Creation of unchangeable references to specific model versions for reproducible deployments

**Purpose**: Creates portable, versioned model artifacts that can be reliably deployed across different environments while maintaining complete lineage and enabling proper version management throughout the deployment lifecycle.

**Relationship Context**: Follows EX-01 training to package the results, then precedes EX-03 deployment to provide the necessary model artifacts for local validation and testing.
