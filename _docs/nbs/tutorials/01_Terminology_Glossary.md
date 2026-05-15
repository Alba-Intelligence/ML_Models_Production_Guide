# ML Deploy Terminology Glossary


# ML Deploy Terminology Glossary

This comprehensive glossary provides standardized definitions for key
terms and concepts used throughout the ML Deploy documentation.
Understanding these terms is essential for effectively navigating the
platform architecture, implementation patterns, and deployment
workflows. Each definition includes key components, practical purposes,
and contextual relationships to other concepts.

## Foundational Concepts: EX-Series Vertical Slices

### EX-01: Training with Traceability

**Definition**: A comprehensive training workflow that captures
extensive metadata throughout the model training process, ensuring full
reproducibility, complete lineage tracking, and auditability of every
training execution.

**Key Components**: - **Model Training Execution**: Core training
algorithm execution with comprehensive parameter tracking - **MLflow
Experiment Tracking**: Structured experiment management with automatic
metadata capture - **Comprehensive Metadata Capture**: Dataset version
information, hyperparameter configurations, environment snapshots, and
dependency tracking - **Training Artifact Storage**: Systematic storage
and versioning of model checkpoints, logs, and intermediate results -
**Complete Audit Trail**: Immutable record of all training decisions,
parameters, and outcomes for reproducibility

**Purpose**: Establishes the foundational layer for all ML workloads by
ensuring that every training run is fully traceable, reproducible, and
auditable. This creates the necessary groundwork for subsequent
deployment and operational phases.

**Relationship Context**: Serves as the starting point for the EX-01 →
EX-02 → EX-03 workflow, providing the trained models and metadata that
feed into the artifact bundling phase.

### EX-02: Artifact Bundling and Versioning

**Definition**: The systematic process of packaging trained models,
associated artifacts, and comprehensive metadata into versioned,
deployment-ready bundles that maintain integrity across different
environments and deployment scenarios.

**Key Components**: - **Model Serialization**: Conversion of trained
PyTorch models, preprocessing pipelines, and configuration objects into
portable formats - **Version Registration**: Automatic registration of
model artifacts in MLflow model registry with semantic versioning -
**Artifact Bundling**: Comprehensive packaging of model weights,
preprocessing steps, configuration files, and dependencies into cohesive
units - **Semantic Versioning**: Implementation of version promotion
tracking with clear upgrade paths and rollback capabilities -
**Immutable Artifact References**: Creation of unchangeable references
to specific model versions for reproducible deployments

**Purpose**: Creates portable, versioned model artifacts that can be
reliably deployed across different environments while maintaining
complete lineage and enabling proper version management throughout the
deployment lifecycle.

**Relationship Context**: Follows EX-01 training to package the results,
then precedes EX-03 deployment to provide the necessary model artifacts
for local validation and testing.

### EX-03: Local Deployment and Serving

**Definition**: A local model deployment pattern utilizing nbdev/Python
environments for inference execution with comprehensive prediction
logging, lineage preservation, and performance monitoring capabilities.

**Key Components**: - **Local Model Loading**: Efficient loading of
serialized models and associated preprocessing pipelines - **Inference
Execution**: Local prediction generation with proper input validation
and output formatting - **Prediction Logging**: Systematic logging of
predictions, inputs, metadata, and performance metrics in JSONL format -
**Deployment Metadata Tracking**: Comprehensive tracking of deployment
parameters, environment information, and execution context -
**Performance Monitoring**: Real-time performance tracking, drift
detection, and quality assessment capabilities

**Purpose**: Enables local testing, validation, and demonstration of
model artifacts in a controlled environment before production
deployment. This phase ensures model functionality, validates
performance characteristics, and establishes baseline metrics for
production comparison.

**Relationship Context**: Completes the EX-01 → EX-02 → EX-03 workflow
by providing local validation of the bundled artifacts, serving as the
final quality gate before production deployment.

### First Vertical Slice (EX-01 → EX-02 → EX-03)

**Definition**: The foundational implementation pattern that
demonstrates the complete end-to-end workflow from model training
through local deployment, serving as the reference implementation for
understanding core ML deployment patterns and providing a template for
extension to more complex scenarios.

**Key Components**: - **Complete End-to-End Workflow Implementation**:
Seamless integration of training, bundling, and deployment phases -
**Comprehensive Metadata Capture**: Consistent metadata collection
throughout all pipeline stages - **Artifact Versioning and Promotion**:
Robust version management and promotion mechanisms - **Local Validation
Capabilities**: Comprehensive testing and validation infrastructure -
**Reference Implementation Architecture**: Template structure that can
be extended for specific use cases

**Purpose**: Provides a concrete, working example of the complete ML
deployment workflow that demonstrates the platform’s capabilities while
serving as an educational tool and reference implementation for
extension to more complex deployment scenarios.

**Relationship Context**: Serves as the foundational pattern upon which
all other deployment patterns are built, establishing the core
principles and architectural patterns that guide platform development.

## Architecture Components

### Execution Backends

**Definition**: The computational environments and orchestration systems
where ML workloads are executed, providing consistent execution
interfaces across different deployment topologies and resource
configurations.

**Types and Characteristics**: - **Local Execution**: Direct execution
on development machines with full debugging access and immediate
feedback - **Slurm Execution**: Distributed training job orchestration
with resource allocation, job scheduling, and failure handling -
**Kubernetes Execution**: Containerized workload management with
automatic scaling, health monitoring, and service discovery

**Purpose**: Abstracts the computational layer from the ML workflow
logic, enabling consistent execution behavior across different
environments while optimizing for specific resource and performance
requirements.

**Relationship Context**: Interacts with governance gates to enforce
execution policies and with web UI contracts to provide standardized
execution interfaces.

### Web UI Contracts

**Definition**: Standardized interfaces and data exchange formats for
notebook execution requests and run visibility summaries that enable
immutable notebook execution without requiring source code
modifications.

**Key Components**: - **NotebookExecutionRequest**: Structured request
format containing execution parameters, environment specifications, and
output requirements - **RunVisibility**: Output sharing and access
control mechanisms for execution results and artifacts -
**ExecutionOrchestrator**: Backend routing logic that maps execution
requests to appropriate backends - **MLflow Integration**: Seamless
linkage between execution runs and MLflow tracking systems

**Purpose**: Provides a consistent, abstract interface for triggering
notebook executions and accessing results across different execution
backends, enabling platform-agnostic notebook development and execution.

**Relationship Context**: Bridges user interfaces with execution
backends, providing the contract layer that enables consistent
interaction regardless of underlying infrastructure.

### Governance Gates

**Definition**: Implementation-phase control mechanisms that enforce
specification-first development methodologies and quality requirements
before allowing production-ready code changes to be merged.

**Key Components**: - **RepositoryPhase**: Phase management between
specification_first and implementation_enabled states -
**OperationKind**: Operation controls between implementation_blocked and
implementation_allowed states - **SpecQualityGate**: Quality validation
requirements and thresholds for specification ratification -
**Transition Logic**: Automated and manual phase change enforcement
mechanisms

**Purpose**: Ensures that implementation work meets established quality
standards, follows proper specification-first development processes, and
maintains architectural consistency across the platform.

**Relationship Context**: Controls the transition between specification
and implementation phases, working in conjunction with CI/CD pipelines
to enforce quality standards.

### MLflow Parity

**Definition**: Configuration management and utilities that ensure
consistent MLflow behavior and functionality across local development
and production environments, maintaining a unified experience regardless
of deployment topology.

**Key Components**: - **Storage Configuration**: PostgreSQL database and
S3 storage backend setup with consistent configurations - **Tracking
Configuration**: MLflow URI and artifact root settings that work across
environments - **Local Emulation**: Floci + K3s + Slurm integration for
local development consistency - **Cloud Configuration**: AWS-backed
MLflow services with equivalent functionality to local setups

**Purpose**: Provides a unified MLflow experience that enables seamless
transitions between local development and production environments while
maintaining consistent tracking, storage, and artifact management
capabilities.

**Relationship Context**: Supports execution backends by providing
consistent experiment tracking and artifact storage across different
deployment scenarios.

## Infrastructure Components

### Nix Containerization

**Definition**: A container definition approach utilizing Nix
dockerTools that eliminates Dockerfile dependencies while maintaining
Docker-first reproducibility and standard container ecosystem
compatibility.

**Key Components**: - **Nix dockerTools.buildImage**: Container image
construction using Nix package management - **Multi-stage Builds**:
Separated build and runtime stages for optimized image sizes -
**Immutable References**: Pinned package versions with exact
reproducibility guarantees - **Layer Optimization**: Efficient caching
and deduplication strategies for build performance

**Purpose**: Provides reproducible, versioned container images without
requiring Dockerfile syntax, enabling infrastructure as code with Nix
while maintaining compatibility with existing Docker/Kubernetes
ecosystems.

**Relationship Context**: Supports execution backends by providing
container images that work across local and cloud environments, and
integrates with Terranix/OpenTofu for infrastructure provisioning.

### Terranix/OpenTofu

**Definition**: Infrastructure-as-code approach using Terranix modules
to generate OpenTofu JSON configurations for AWS infrastructure
provisioning, enabling declarative infrastructure management with
version control and reproducibility.

**Key Components**: - **Terranix Modules**: Shared and profile-specific
infrastructure definitions written in Nix - **OpenTofu JSON**: Generated
infrastructure configurations compatible with OpenTofu CLI - **Dual
Profiles**: Separate configurations for local_emulation and cloud
deployment scenarios - **State Management**: Infrastructure lifecycle
management with state file handling

**Purpose**: Declarative infrastructure provisioning with full version
control, reproducibility, and consistency between development and
production environments.

**Relationship Context**: Works with execution backends to provision the
necessary infrastructure resources and integrates with Nix
containerization for complete infrastructure definition.

### Local Emulation Stack

**Definition**: A comprehensive local development environment that
closely mirrors production control planes using Floci (AWS service
emulator), K3s (lightweight Kubernetes), and Slurm-Docker for compute
orchestration.

**Key Components**: - **Floci**: Complete AWS service emulation
including S3, RDS, and other managed services - **K3s**: Lightweight
Kubernetes distribution for local container orchestration -
**Slurm-Docker**: Job orchestration system combining Slurm scheduling
with Docker containers - **Service Composition**: Integrated data and
compute planes that replicate production architecture

**Purpose**: Enables local development that closely matches production
behavior without cloud dependencies, allowing developers to work offline
while maintaining architectural fidelity.

**Relationship Context**: Provides the local execution environment for
governance gates and enables local testing of components that will run
in production.

## Deployment Topologies

### Local Development Topology

**Definition**: A development environment focused on iterative model
development and local validation with comprehensive traceability and
governance controls.

**Key Components**: - **Local Execution Backends**: Direct execution on
development machines with full debugging capabilities - **MLflow
Tracking with Local Storage**: Experiment tracking with local database
and artifact storage - **Containerized Dependencies**: Docker containers
for consistent runtime environments - **Development-Specific Governance
Gates**: Relaxed governance requirements for development work

**Purpose**: Supports rapid iteration during model development while
maintaining traceability, quality standards, and consistency with
production systems.

**Relationship Context**: Serves as the entry point for the EX-01 →
EX-02 → EX-03 workflow and provides the foundation for more complex
deployment topologies.

### Distributed Training Topology

**Definition**: A production topology for distributed model training
utilizing Lambda.ai infrastructure with Slurm coordination,
comprehensive failure handling, and cross-job metadata synchronization.

**Key Components**: - **Lambda.ai Job Submission**: Distributed training
job submission with proper resource allocation - **Slurm Failure Mode
Handling**: Comprehensive failure detection, retry logic, and graceful
degradation - **Distributed Training Orchestration**: Coordination of
training processes across multiple compute nodes - **Cross-Job Metadata
Synchronization**: Consistent metadata sharing between distributed
training jobs

**Purpose**: Enables scalable distributed training with fault tolerance,
comprehensive job management, and complete metadata preservation across
the training lifecycle.

**Relationship Context**: Extends the EX-01 training phase to handle
distributed workloads and provides the foundation for large-scale model
training scenarios.

### Batch Inference Topology

**Definition**: A production topology for batch inference processing
with comprehensive lineage preservation, cost controls, and efficient
resource utilization.

**Key Components**: - **Batch Job Orchestration**: Automated job
scheduling and execution with proper queue management - **Model Artifact
Management**: Efficient loading and management of multiple model
versions - **Output Lineage Tracking**: Complete tracking of processing
inputs, outputs, and metadata - **Cost Attribution and Monitoring**:
Detailed cost tracking and resource utilization monitoring

**Purpose**: Enables efficient batch processing with comprehensive
lineage tracking, cost management, and scalability for large-scale
inference workloads.

**Relationship Context**: Builds upon the EX-02 artifact bundling phase
to enable production-scale batch processing while maintaining complete
lineage and cost awareness.

### Online Inference Topology

**Definition**: A production topology for real-time model inference with
deployment rollbacks, comprehensive monitoring, and service health
management capabilities.

**Key Components**: - **Containerized Model Serving**: Production-ready
model serving with container isolation - **Deployment Rollbacks**:
Automated rollback capabilities with version switching - **Service
Health Monitoring**: Real-time health checks and performance
monitoring - **Real-time Performance Tracking**: Comprehensive metrics
collection and alerting

**Purpose**: Provides reliable, production-ready online inference with
comprehensive deployment controls, monitoring, and scalability for
real-time applications.

**Relationship Context**: Represents the final production deployment
phase, extending EX-03 local deployment to provide production-ready
online serving capabilities.

## Security and Governance Framework

### OIDC-backed Authorization

**Definition**: A comprehensive identity and access management system
utilizing OpenID Connect protocols for centralized authentication,
role-based access control, and audit logging.

**Key Components**: - **Identity Providers**: Integration with GitHub,
Okta, and other identity providers - **Role Definitions and
Permissions**: Granular role definitions with specific access
permissions - **Access Control Policies**: Policy-driven access control
with inheritance and override capabilities - **Audit Logging and
Compliance**: Comprehensive audit trails for compliance and security
review

**Purpose**: Ensures secure access to ML deployment resources with
proper authentication, authorization, and compliance tracking across all
platform components.

**Relationship Context**: Underpins all governance mechanisms and
provides the security foundation for all deployment topologies and
execution backends.

### Data Lineage

**Definition**: Comprehensive tracking of data flow through the complete
ML pipeline, including dataset versions, transformation history, feature
engineering processes, and model training lineage.

**Key Components**: - **Dataset Version Tracking**: Complete version
history of input datasets with change tracking - **Feature Engineering
Lineage**: Tracking of data transformations and feature creation
processes - **Model Training Metadata**: Detailed metadata about
training runs, parameters, and outcomes - **Output Artifact
Provenance**: Complete provenance tracking for all output artifacts

**Purpose**: Ensures complete traceability of data through the entire ML
lifecycle for compliance auditing, reproducibility, and operational
transparency.

**Relationship Context**: Supports EX-01 training by providing
comprehensive data tracking and enables governance through complete
lineage transparency.

### Model Traceability

**Definition**: End-to-end tracking of model artifacts from initial
training through production deployment, including version management,
promotion tracking, and deployment metadata.

**Key Components**: - **Model Version Management**: Comprehensive
version control with semantic versioning - **Promotion Pipeline
Tracking**: Complete tracking of model movement through deployment
stages - **Deployment Metadata**: Detailed metadata about deployment
environments and configurations - **Performance and Drift Monitoring**:
Ongoing performance tracking and concept drift detection

**Purpose**: Ensures models can be traced from conception to production
with complete metadata, version control, and ongoing performance
monitoring capabilities.

**Relationship Context**: Connects EX-02 and EX-03 phases, providing the
tracking framework that enables model lifecycle management and
operational monitoring.

## Development Methodologies

### Immutable Notebooks

**Definition**: A notebook development approach where notebook source
code remains immutable and execution parameters are injected externally,
ensuring reproducibility while enabling parameter variation across
different environments.

**Key Components**: - **Immutable Notebook References**: Git commit SHA
references for exact notebook versions - **External Parameter
Injection**: Dynamic parameter injection without code modification -
**Execution Request/Response Contracts**: Standardized interfaces for
notebook execution - **Result Caching and Deduplication**: Intelligent
caching to avoid redundant executions

**Purpose**: Ensures notebook reproducibility while enabling flexible
parameter variation across different environments and use cases.

**Relationship Context**: Supports the EX-01 training phase by providing
reproducible notebook execution with parameter flexibility.

### Docker-First Reproducibility

**Definition**: A containerization approach where containers are built
using Nix but output standard Docker images without runtime Nix
dependency, maintaining reproducibility while ensuring ecosystem
compatibility.

**Key Components**: - **Nix-Based Container Definition**: Container
specification using Nix package management - **Docker Image Output**:
Standard Docker image format for maximum compatibility - **No Runtime
Nix Dependency**: Containers run with standard Docker runtime -
**Standard Docker Ecosystem Compatibility**: Full compatibility with
Docker/Kubernetes ecosystems

**Purpose**: Provides reproducible container images that work with
existing Docker and Kubernetes infrastructure without requiring Nix
runtime dependencies.

**Relationship Context**: Supports all execution backends by providing
container images that work across local and cloud environments.

### Spec-First Development

**Definition**: A development methodology where specifications are
defined, reviewed, and ratified before implementation begins, ensuring
architectural consistency and quality standards throughout the
development process.

**Key Components**: - **Specification Definition and Ratification**:
Formal specification creation and approval process - **Quality Gates and
Validation**: Automated and manual quality validation mechanisms -
**Implementation Constraints**: Clear boundaries and requirements for
implementation work - **Architecture Review Processes**: Structured
review of implementation against specifications

**Purpose**: Ensures implementation work aligns with architectural
requirements, maintains quality standards, and follows established
development patterns.

**Relationship Context**: Governs the entire development process,
ensuring that EX-01 → EX-02 → EX-03 implementations meet quality and
architectural standards.

## Related Documentation and References

### Core Implementation Documents

- **[Implementation
  Patterns](../reference/01_Implementation_Patterns.qmd)**: Detailed
  implementation guidance and code examples for EX-01 → EX-03 patterns
- **[API Documentation](../reference/02_API_Documentation.qmd)**:
  Complete technical API reference for contracts, interfaces, and
  integration points
- **[Infrastructure Setup](../reference/03_Infrastructure_Setup.qmd)**:
  Infrastructure configuration, deployment procedures, and environment
  setup

### Architecture and Design Documents

- **[Architecture Overview](../reference/04_Architecture_Details.qmd)**:
  Deep technical architecture review and design decisions
- **[Security
  Architecture](../reference/05_Security_Architecture.qmd)**: Security
  model, threat analysis, and compliance requirements
- **[Performance
  Guidelines](../reference/06_Performance_Guidelines.qmd)**: Performance
  optimization strategies and best practices

### Operational Documentation

- **[Deployment
  Procedures](../reference/07_Deployment_Procedures.qmd)**: Step-by-step
  deployment guides and operational procedures
- **[Monitoring and
  Observability](../reference/08_Monitoring_Observability.qmd)**:
  Monitoring strategies, alerting, and operational visibility
- **[Troubleshooting
  Guide](../reference/09_Troubleshooting_Guide.qmd)**: Common issues,
  debugging procedures, and resolution strategies

------------------------------------------------------------------------

*This terminology glossary represents a living document that will be
continuously updated as the ML Deploy platform evolves and new concepts
are introduced. For questions about specific terminology or concepts,
please refer to the related implementation documents and architecture
specifications.*
