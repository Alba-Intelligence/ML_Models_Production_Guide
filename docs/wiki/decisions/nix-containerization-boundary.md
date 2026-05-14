---
updated: 2026-05-14
summary: Decision record for Nix-based containerization specifying no Docker files, all containers defined via Nix, and Docker-first reproducibility requirements.
read_when:
  - You are configuring containerization strategies
  - You need to understand Nix-based container definitions
  - You are implementing Docker-first reproducibility workflows
sources:
  - ../../specs/ml-deploy-reference-repo.allium
  - ../queries/spec-quality-elicitation-session-01.md
  - ../architecture/reference-architecture-skeleton.md
  - ../decisions/project-scope-and-constraints.md
---

# Decision: Nix Containerization Boundary (No Docker Files)

**What this page is for**: Decision record specifying the contracted behavior for Nix-based containerization, Docker-first reproducibility, and the complete elimination of Docker files from the stack.

**When to read**: When configuring container builds, implementing reproducibility workflows, or ensuring Nix-based container definitions across all workloads.

**Upstream spec**: `specs/ml-deploy-reference-repo.allium` — `DockerFirstReproducibility`, `NixContainerDefinition`

---

## Decision

### Containerization Strategy: Nix-Only Container Definition

**NO Docker files are allowed in the stack. ALL containers MUST be defined and built using Nix.** This is a hard boundary that eliminates Dockerfile from the entire repository.

#### Nix Container Definition Requirements

All containers MUST be defined using Nix modules that:
1. **Eliminate Dockerfile entirely** - no .dockerfile files allowed
2. **Use Nixpkgs dockerTools** - standard Nix container build tools
3. **Provide multi-stage builds** - build and runtime stages separated
4. **Immutable references** - pinned package versions and build inputs
5. **Reproducible builds** - deterministic container generation
6. **Layer optimization** - efficient layer caching and minimal final images

#### Mandatory Nix Container Definitions

The following container types MUST be defined via Nix:

1. **ML Training Containers**
   - PyTorch training environments with GPU support
   - MLflow tracking server containers
   - Experiment execution environments
   - Distributed training containers for Lambda.ai

2. **Inference Serving Containers**
   - Model serving runtime containers
   - API gateway containers
   - Health check and monitoring containers
   - Batch processing containers

3. **Infrastructure Components**
   - MLflow database containers (PostgreSQL)
   - Redis cache containers
   - Message queue containers
   - Monitoring stack containers (Prometheus/Grafana)

4. **Development Tools**
   - Jupyter notebook containers
   - Data science tool containers
   - CI/CD pipeline containers
   - Local development environments

5. **Platform Services**
   - Airflow worker containers
   - Notebook serving containers
   - Model registry containers
   - API gateway containers

#### Nix Container Structure

```
nix/
├── containers/
│   ├── mlflow/
│   │   ├── build.nix
│   │   └── runtime.nix
│   ├── training/
│   │   ├── pytorch-cpu/
│   │   ├── pytorch-gpu/
│   │   └── distributed/
│   ├── inference/
│   │   ├── model-serving/
│   │   └── batch-processing/
│   ├── infrastructure/
│   │   ├── postgresql/
│   │   ├── redis/
│   │   └── monitoring/
│   └── development/
│       ├── jupyter/
│       └── tools/
└── overlays/
    └── docker-tools.nix
```

#### Nix Container Definition Examples

**MLflow Training Container**
```nix
# nix/containers/mlflow/build.nix
{ 
  pkgs, 
  inputs,
  ...
}:

let
  # Build-time dependencies
  buildDeps = with pkgs; [
    python311
    python311Packages.pip
    python311Packages.setuptools
    python311Packages.wheel
    git
    curl
    wget
  ];

  # Python packages
  pythonPkgs = with pkgs.python311Packages; [
    mlflow
    scikit-learn
    pandas
    numpy
    matplotlib
    seaborn
    jupyter
    notebook
    ipykernel
    psycopg2
    boto3
    requests
    fastapi
    uvicorn
    pydantic
    click
    python-dotenv
    prometheus-client
    psutil
  ];

in
pkgs.dockerTools.buildImage {
  name = "mlflow-training";
  tag = "latest";
  created = "now";

  # Build stage
  buildInputs = buildDeps ++ pythonPkgs;

  # Copy build scripts and dependencies
  copyToRoot = pkgs.buildEnv {
    name = "mlflow-build-env";
    paths = buildDeps;
    pathsToLink = ["/bin" "/lib" "/libexec" "/share"];
  };

  # Python environment setup
  extraCommands = ''
    # Set up Python environment
    python -m pip install --no-index --find-links=${pkgs.python311Packages}/lib/python3.11/site-packages -e .
    python -m pip install --no-index --find-links=${pkgs.python311Packages}/lib/python3.11/site-packages ${pythonPkgs}
    
    # Install MLflow
    pip install mlflow
    
    # Create MLflow directory
    mkdir -p /app/mlflow
    
    # Copy application code
    cp -r ${./app} /app/
    
    # Set working directory
    cd /app
    
    # Install requirements
    pip install -r requirements.txt
    
    # Create MLflow configuration
    cat > mlflow-config.yaml << EOF
    tracking_uri: http://localhost:5000
    artifact_root: /app/artifacts
    EOF
  '';

  # Runtime stage
  runAsRoot = ''
    # Create non-root user
    useradd -m -u 1000 mlflow
    chown -R mlflow:mlflow /app
    chmod -R 755 /app
  '';

  # Runtime dependencies
  contents = [
    pkgs.bash
    pkgs.coreutils
    pkgs.gnused
    pkgs.gnugrep
  ];

  # Configure container
  config = {
    Cmd = ["/bin/bash"];
    Entrypoint = ["/app/start.sh"];
    WorkingDir = "/app";
    ExposedPorts = {
      "5000/tcp" = {};
      "8080/tcp" = {};
    };
    Env = [
      "PYTHONPATH=/app"
      "MLFLOW_HOME=/app/mlflow"
      "MLFLOW_TRACKING_URI=http://localhost:5000"
      "MLFLOW_DEFAULT_ARTIFACT_ROOT=/app/artifacts"
      "PATH=/bin:/usr/bin:/usr/local/bin"
    ];
    User = "mlflow";
  };
}
```

**PyTorch GPU Training Container**
```nix
# nix/containers/training/pytorch-gpu/build.nix
{ 
  pkgs, 
  inputs,
  ...
}:

let
  # Build dependencies
  buildDeps = with pkgs; [
    python311
    python311Packages.pip
    python311Packages.setuptools
    python311Packages.wheel
    git
    curl
    wget
    cudaPackages.cudatoolkit
    cudnn
    nccl
  ];

  # Python packages
  pythonPkgs = with pkgs.python311Packages; [
    mlflow
    torchWithCuda
    torchvisionWithCuda
    torchaudioWithCuda
    scikit-learn
    pandas
    numpy
    matplotlib
    seaborn
    jupyter
    notebook
    ipykernel
    psycopg2
    boto3
    requests
    fastapi
    uvicorn
    pydantic
    click
    python-dotenv
    prometheus-client
    psutil
  ];

  # CUDA-specific packages
  cudaPkgs = with pkgs.cudaPackages; [
    cudnn
    nccl
    cutlass
    thrust
  ];

in
pkgs.dockerTools.buildImage {
  name = "pytorch-gpu-training";
  tag = "latest";
  created = "now";

  buildInputs = buildDeps ++ pythonPkgs ++ cudaPkgs;

  copyToRoot = pkgs.buildEnv {
    name = "pytorch-gpu-build-env";
    paths = buildDeps ++ cudaPkgs;
    pathsToLink = ["/bin" "/lib" "/libexec" "/share"];
  };

  extraCommands = ''
    # Set up Python environment
    python -m pip install --no-index --find-links=${pkgs.python311Packages}/lib/python3.11/site-packages -e .
    python -m pip install --no-index --find-links=${pkgs.python311Packages}/lib/python3.11/site-packages ${pythonPkgs}
    
    # Install PyTorch with CUDA
    pip install torch torchvision torchaudio --index-url https://download.pytorch.org/whl/cu118
    
    # Install MLflow
    pip install mlflow
    
    # Create directories
    mkdir -p /app/mlflow /app/checkpoints /app/logs
    
    # Copy application code
    cp -r ${./app} /app/
    
    # Set working directory
    cd /app
    
    # Install requirements
    pip install -r requirements.txt
    
    # Create startup script
    cat > start.sh << EOF
    #!/bin/bash
    set -e
    
    # Set environment variables
    export CUDA_VISIBLE_DEVICES=\${CUDA_VISIBLE_DEVICES:-0}
    export MLFLOW_TRACKING_URI=http://localhost:5000
    export MLFLOW_DEFAULT_ARTIFACT_ROOT=/app/artifacts
    
    # Start training
    python train.py --config config.yaml
    EOF
    
    chmod +x start.sh
  '';

  runAsRoot = ''
    # Create non-root user
    useradd -m -u 1000 trainer
    chown -R trainer:trainer /app
    chmod -R 755 /app
  '';

  contents = [
    pkgs.bash
    pkgs.coreutils
    pkgs.gnused
    pkgs.gnugrep
  ];

  config = {
    Cmd = ["/bin/bash"];
    Entrypoint = ["/app/start.sh"];
    WorkingDir = "/app";
    ExposedPorts = {
      "5000/tcp" = {};
      "8080/tcp" = {};
      "6006/tcp" = {};  # TensorBoard
    };
    Env = [
      "PYTHONPATH=/app"
      "MLFLOW_HOME=/app/mlflow"
      "MLFLOW_TRACKING_URI=http://localhost:5000"
      "MLFLOW_DEFAULT_ARTIFACT_ROOT=/app/artifacts"
      "CUDA_VISIBLE_DEVICES=0"
      "PATH=/bin:/usr/bin:/usr/local/bin"
    ];
    User = "trainer";
    Volumes = {
      "/app/mlflow" = {};
      "/app/checkpoints" = {};
      "/app/logs" = {};
    };
  };
}
```

#### Docker-First Reproducibility Requirements

**Docker-First Workflow Definition**
All workflows MUST be reproducible from Docker alone with no Nix dependency:

1. **Container Build**: `nix build .#container-name` → produces Docker image
2. **Container Push**: `docker push <image-name>` → push to registry
3. **Container Run**: `docker run <image-name>` → run without Nix
4. **Container Inspect**: `docker inspect <image-name>` → inspect image
5. **Container Export**: `docker save <image-name>` → export for offline use

**Acceptance Test for Docker-First Reproducibility**
```python
# tests/test_docker_first_reproducibility.py
"""
Test that containers can be built, pushed, and run without Nix dependency.
"""
import subprocess
import json
import tempfile
import os
from pathlib import Path

def test_nix_to_docker_build():
    """Test that Nix container builds produce valid Docker images."""
    # Build container using Nix
    result = subprocess.run([
        "nix", "build", ".#pytorch-gpu-training"
    ], capture_output=True, text=True)
    assert result.returncode == 0, "Nix container build failed"
    
    # Load the built Docker image
    result = subprocess.run([
        "docker", "load", "-i", "result"
    ], capture_output=True, text=True)
    assert result.returncode == 0, "Docker image load failed"
    
    # Verify image exists
    result = subprocess.run([
        "docker", "images", "pytorch-gpu-training:latest", "--format", "{{.ID}}"
    ], capture_output=True, text=True)
    assert result.returncode == 0, "Docker image listing failed"
    assert result.stdout.strip() != "", "Docker image not found"

def test_container_functionality():
    """Test that container runs correctly without Nix."""
    # Run container
    result = subprocess.run([
        "docker", "run", 
        "--rm",
        "pytorch-gpu-training:latest",
        "/bin/sh", "-c", "echo 'Container works'"
    ], capture_output=True, text=True, timeout=30)
    
    assert result.returncode == 0, "Container execution failed"
    assert "Container works" in result.stdout, "Container output mismatch"

def test_container_inspection():
    """Test that container can be inspected."""
    result = subprocess.run([
        "docker", "inspect", "pytorch-gpu-training:latest"
    ], capture_output=True, text=True)
    
    assert result.returncode == 0, "Container inspection failed"
    
    # Parse JSON and verify required fields
    inspection = json.loads(result.stdout)
    container_info = inspection[0]
    
    assert "Config" in container_info, "Container config missing"
    assert "Env" in container_info["Config"], "Container env vars missing"
    assert "ExposedPorts" in container_info["Config"], "Exposed ports missing"

def test_container_export_import():
    """Test that container can be exported and imported."""
    # Export container
    with tempfile.NamedTemporaryFile(suffix=".tar", delete=False) as tmp:
        export_path = tmp.name
    
    result = subprocess.run([
        "docker", "save", "pytorch-gpu-training:latest", "-o", export_path
    ], capture_output=True, text=True)
    assert result.returncode == 0, "Container export failed"
    
    try:
        # Remove existing image
        subprocess.run(["docker", "rmi", "pytorch-gpu-training:latest"], 
                      capture_output=True)
        
        # Import container from export
        result = subprocess.run([
            "docker", "load", "-i", export_path
        ], capture_output=True, text=True)
        assert result.returncode == 0, "Container import failed"
        
        # Verify image exists after import
        result = subprocess.run([
            "docker", "images", "pytorch-gpu-training:latest", "--format", "{{.ID}}"
        ], capture_output=True, text=True)
        assert result.returncode == 0, "Docker image listing failed after import"
        assert result.stdout.strip() != "", "Docker image not found after import"
        
    finally:
        # Clean up
        os.unlink(export_path)
```

#### Nix Helper Artifacts Definition

**Nix Helper Artifacts** are allowed as supplementary outputs that do not become the canonical runtime path:

1. **Build Scripts**: Nix scripts to generate Docker images
2. **Configuration Files**: Nix-generated configuration for containers
3. **Dependency Lists**: Nix package lists for container contents
4. **Build Metadata**: Build-time metadata and version information
5. **Documentation**: Generated documentation for container contents

**Non-Canonical Nix Outputs** (helper-only, not runtime paths):
- `nix-build-result.tar.gz` - Docker image archive
- `container-metadata.json` - Container metadata
- `build-log.txt` - Build execution log
- `dependency-graph.json` - Package dependency graph

**Canonical Runtime Path** (Docker image):
- `docker.io/registry/pytorch-gpu-training:latest` - Actual runtime container

### Acceptance Criteria

1. **No Docker Files**: Zero .dockerfile files exist in the repository
2. **Nix-Only Container Definitions**: All containers defined via Nix dockerTools
3. **Docker-First Reproducibility**: Containers can be built, pushed, run, and inspected without Nix
4. **Multi-Stage Support**: Build and runtime stages separated for efficiency
5. **Immutable References**: All container contents pinned to specific versions
6. **Reproducible Builds**: Same Nix input produces identical Docker output
7. **Layer Optimization**: Efficient layer caching and minimal final images
8. **Multi-Platform Support**: Optional support for multiple architectures (amd64, arm64)

### Related Decisions

- [Project Scope and Constraints](../decisions/project-scope-and-constraints.md) - Overall architectural direction
- [Nix/Terranix/OpenTofu Boundary](../decisions/nix-terranix-opentofu-boundary.md) - Infrastructure generation requirements
- [AWS Kubernetes Contract](../decisions/aws-kubernetes-contract.md) - Kubernetes container deployment requirements
- [MLflow PostgreSQL+S3 Contract](../decisions/mlflow-postgres-s3-contract.md) - MLflow container requirements

### Open Items

- Multi-platform container build support (amd64, arm64)
- Container registry integration and push automation
- Container image vulnerability scanning integration
- Container image signing and verification
- Container lifecycle management automation
- Container resource optimization and size reduction

---

## Rationale

### Why Eliminate Docker Files Entirely?

1. **Reproducibility**: Nix provides hermetic, deterministic builds
2. **Version Control**: Container definitions tracked in git, not Dockerfile
3. **Dependency Management**: Nix manages all dependencies precisely
4. **Multi-Platform Support**: Nix can build for multiple architectures
5. **Security**: Reduced risk of supply chain attacks in Dockerfile
6. **Layer Optimization**: Nix provides better layer caching and deduplication

### Why Docker-First Reproducibility?

1. **Runtime Independence**: Containers can run without Nix installed
2. **Ecosystem Compatibility**: Works with existing Docker/Kubernetes ecosystems
3. **Portability**: Docker images can be exported and imported anywhere
4. **Tooling Integration**: Compatible with all Docker tooling and CI/CD systems
5. **Offline Usage**: Docker images can be saved and used offline
6. **Registry Integration**: Seamless integration with container registries

### Why Nix Helper Artifacts?

1. **Build Efficiency**: Nix handles complex dependency resolution
2. **Version Pinning**: Precise package version control
3. **Metadata Generation**: Automatic generation of build metadata
4. **Documentation**: Self-documenting container definitions
5. **Testing**: Nix-based testing and validation
6. **Multi-Stage Builds**: Efficient build and runtime separation

---

## Implementation Notes

### Container Build Workflow
1. Define container in Nix (`nix/containers/name/build.nix`)
2. Build container: `nix build .#container-name`
3. Load Docker image: `docker load -i result`
4. Push to registry: `docker push registry/name:tag`
5. Deploy to Kubernetes: Use standard Kubernetes deployment manifests

### CI/CD Integration
```yaml
# .github/workflows/container-build.yml
name: Build and Push Containers

on:
  push:
    paths: ['nix/containers/**']

jobs:
  build-containers:
    runs-on: ubuntu-latest
    steps:
    - uses: actions/checkout@v4
    
    - name: Set up Nix
      uses: DeterminateSystems/nix-installer-action@main
      with:
        extra-channel: https://nixos.org/channels/nixos-unstable
    
    - name: Build containers
      run: |
        nix build .#mlflow-training
        nix build .#pytorch-gpu-training
        nix build .#model-serving
    
    - name: Load Docker images
      run: |
        docker load -i result
        docker load -i result
        docker load -i result
    
    - name: Push to registry
      run: |
        docker push registry/mlflow-training:latest
        docker push registry/pytorch-gpu-training:latest
        docker push registry/model-serving:latest
```

### Local Development
```bash
# Build and test containers locally
nix build .#mlflow-training
docker load -i result
docker run --rm registry/mlflow-training:latest /bin/sh -c "echo 'test'"

# Build all containers
nix build .#all-containers

# Push to registry
docker push registry/mlflow-training:latest
```
