.. ML Deploy Reference documentation master file, created by
   sphinx-quickstart on Sat May 16 20:36:26 2026.
   You can adapt this file completely to your liking, but it should at least
   contain the root `toctree` directive.

ML Deploy Documentation
=======================

Welcome to the ML Deploy documentation—a comprehensive guide for machine learning deployment with full lifecycle management. This documentation is a permanent work-in-progress, continuously evolving to reflect the latest platform capabilities and best practices.

Key Features
------------
- **Full Lifecycle Management**: Comprehensive coverage from data preparation and model training through deployment and monitoring, ensuring complete management of the ML pipeline
- **Nix-Based Infrastructure**: Reproducible infrastructure as code utilizing Nix capabilities to generate containers without Docker files while automatically producing Terraform and OpenTofu configurations for cloud deployment
- **Comprehensive Lineage**: Complete traceability across all ML pipeline stages, enabling full auditability and reproducibility of data and model transformations
- **Security-First Architecture**: Built-in governance frameworks and security controls designed to meet enterprise requirements while maintaining development flexibility
- **Multi-Environment Support**: Seamless deployment across development, staging, and production environments with consistent tooling and process parity between local and cloud platforms

Platform Architecture
---------------------
The platform architecture is organized into five key component areas, each serving specific functions within the ML deployment ecosystem:

- **ML Training / Inference**:
  - Notebook First: ML Researchers send their notebooks unchanged to the platform, which extracts metadata and executes them in a controlled environment
  - Libraries: Focused on Python-only stack
  - MLflow: For experiment tracking and model registry
- **Data**:
  - Data Catalog: For managing and discovering data assets
  - Data Lineage: For tracking data transformations and dependencies
  - Logging & Monitoring: For observability of data and model performance
- **Orchestration**:
  - Kubeflow: For workflow orchestration and pipeline management
  - Airflow: For scheduling and monitoring workflows
- **Backends**:
  - Cloud: For scalable production deployments: compute resources on Lambda.ai distributed with Slurm, all other tools hosted on AWS
  - Local: For development and testing: Compute resources on Lambda.ai distributed with Slurm, all other tools on Floci replicating AWS services locally
- **Configuration**:
  - Nix: Nix-only for reproducible builds and environment management
  - uv2nix: For generating Nix expressions from uv project definitions
  - Containers: For local emulation and cloud deployment, generated from Nix definitions (no docker files)
  - Terranix: For generating Terraform configurations from Nix definitions

.. toctree::
   :maxdepth: 2
   :caption: Contents:

   Introduction and Overview
   ------------------------
   01_05-platform_narrative
   01_04-core_concepts
   01_03-platform_architecture

   Infrastructure and Integration
   -----------------------------
   03_04-terraniq_integration
   opentofu_infra

   Governance and Security
   ----------------------
   04_05-governance_framework
   17_governance_gates

   User Interfaces
   ---------------
   04_04-user_interfaces

   Example Workflows
   -----------------
   06_vertical_slice
   vertical_slice
   07_mlflow_parity

   Analysis and Reading Paths
   -------------------------
   system_interaction_analysis
   reading-paths

   Comprehensive Test
   ------------------
   comprehensive-test

   simple-test
   opentofu_infra
   reference/index
   tutorials/index
