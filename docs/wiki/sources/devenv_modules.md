---
updated: 2026-05-18
summary: Modular devenv setup with Terranix infrastructure modules
read_when:
  - Working with devenv-based development environment
  - Understanding modular Terranix configuration
  - Setting up local vs cloud development profiles
source_files:
  - ../../devenv.nix
  - ../../devenv_modules/
---

# Modular Devenv Setup

## Overview

The repository uses a **modular devenv setup** that separates the main development environment configuration from Terranix infrastructure-as-code modules. This allows for clean separation of development tooling from deployment infrastructure configuration.

## Structure

```
devenv.nix                    # Main devenv configuration
├── devenv_modules/           # Modular Terranix configuration
│   ├── modules/             # Core Terranix modules
│   │   ├── empty.nix       # Empty module for testing (NEW)
│   │   ├── shared.nix      # Shared mlDeploy configuration
│   │   ├── local.nix       # Local emulation profile
│   │   └── cloud.nix       # Cloud deployment profile
│   ├── profiles/            # Devenv profiles
│   │   ├── local.nix       # Local development profile
│   │   └── cloud.nix       # Cloud development profile
│   └── terranix/           # Terranix-specific configurations
│       └── docker-artifacts.nix  # Docker configuration
```

## Main Devenv Configuration (`devenv.nix`)

### Purpose

Provides the primary development environment with:

- Allium CLI 3.2.3 (compiled with naersk)
- Python package management via UV
- Notebook development with nbdev support
- Documentation rendering with Quarto
- Custom start-jupyter script for kernel management

### Key Components

#### Packages

- **devPkgs**: Core development tools (git, curl, wget, etc.)
- **localPkgs**: Local-specific packages (allium-cli, start-jupyter-script)
- **pythonPkgs**: Python-related packages
- **llmPkgs**: LLM/ML-related packages

#### Scripts

- **start-jupyter**: Custom script that:
  - Sets up development environment variables
  - Manages Python virtual environment via UV
  - Handles Jupyter kernel configuration
  - Supports both local and cloud profiles

#### Profiles

- **localDev**: Sets `ENVIRONMENT=LOCAL` for local development
- **cloudProd**: Sets up cloud development environment

## Terranix Modules (`devenv_modules/`)

### Architecture

The modular setup uses a layered approach:

1. **empty.nix**: Empty module for testing modular loading (NEW)
2. **shared.nix**: Base configuration for both local and cloud
3. **local.nix**: Extends shared for local emulation with Floci
4. **cloud.nix**: Extends shared for cloud deployment with AWS endpoints

### Modules

#### `modules/empty.nix` (NEW)

Empty module for testing modular devenv loading:

```nix
{ config, pkgs, ... }:
{
  # This module intentionally left empty for testing
  options = {};
}
```

#### `modules/shared.nix`

- Defines shared `mlDeploy` options
- Creates S3 buckets for artifacts and model registry
- Exposes MLflow tracking URI and deployment profile as OpenTofu outputs
- Base configuration for both environments

#### `modules/local.nix`

- Configures local profile with `http://localhost:4566`
- Uses Floci-compatible AWS provider endpoints
- Targets local K3s kubeconfig path
- Suitable for local development and testing

#### `modules/cloud.nix`

- Configures cloud profile with real AWS endpoints
- Uses secrets injected via environment variables
- Targets production infrastructure
- Compatible with Lambda.ai training infrastructure

### Profiles

#### `profiles/local.nix`

- Imports `../modules/local.nix`
- Activates local emulation profile
- Configures local development environment

#### `profiles/cloud.nix`

- Imports `../modules/cloud.nix`
- Activates cloud deployment profile
- Configures cloud development environment

### Terranix Configuration

#### `terranix/docker-artifacts.nix`

- Contains Docker configuration for local emulation
- Supports containerized development environment
- Integrates with local infrastructure stack

## Usage

### Local Development

```bash
# Use local development profile
devenv shell --profile localDev

# Use cloud development profile
devenv shell --profile cloud
```

### Profile-specific Configuration

Each profile inherits from its corresponding module:

- Local profile uses Docker-based local emulation
- Cloud profile uses real AWS endpoints

## Current Status

### ✅ Completed

- Basic devenv setup with all required packages
- Modular Terranix configuration structure
- Profile separation for local/cloud development
- Custom start-jupyter script integration
- Empty module created for testing modular loading

### 🔄 In Progress

- Integration of Terranix-generated infrastructure files
- Testing of modular configuration loading

### ⚠️ Known Issues

- Minor environment variable handling in start-jupyter script
- Colliding subpath warnings in package build (cosmetic)

## Next Steps

1. **Test Profile Loading**: Verify both local and cloud profiles load correctly
2. **Terranix Integration**: Test infrastructure generation from Terranix modules
3. **Documentation**: Add examples for common development workflows
4. **Testing**: Add automated tests for profile-specific configurations

## Integration Notes

- The devenv setup mirrors the flake.nix behavior for development workflows
- Terranix modules can be used independently of devenv for infrastructure deployment
- Profile switching allows seamless transition between local and cloud development contexts
- The empty.nix module provides a starting point for adding new modular configuration
