---
updated: 2026-05-14
summary: Decision record for Nix/Terranix/OpenTofu ownership boundary specifying infrastructure components, exceptions, and parity verification requirements.
read_when:
  - You are configuring infrastructure workflows
  - You need to understand which components must be generated via Nix/Terranix
  - You are verifying parity between generated OpenTofu JSON and deployed resources
sources:
  - ../../specs/ml-deploy-reference-repo.allium
  - ../queries/spec-quality-elicitation-session-01.md
  - ../architecture/reference-architecture-skeleton.md
  - ../decisions/project-scope-and-constraints.md
---

# Decision: Nix/Terranix/OpenTofu Ownership Boundary

**What this page is for**: Decision record specifying the contracted behavior for infrastructure component generation, control boundaries, and parity verification using Nix/Terranix/OpenTofu workflows.

**When to read**: When designing infrastructure workflows, implementing OpenTofu configurations, or verifying parity between generated and deployed resources.

**Upstream spec**: `specs/ml-deploy-reference-repo.allium` — `TerranixOutputRequired`, `LocalEmulationStack`, `CloudProfileRequirements`

---

## Decision

### Infrastructure Generation: Nix/Terranix/OpenTofu Mandate

**ALL infrastructure components MUST be generated/controlled exclusively through Nix/Terranix/OpenTofu workflows.** This is a hard boundary with no exceptions for core infrastructure components.

#### Mandatory Nix/Terranix/OpenTofu Components

The following infrastructure components MUST be generated exclusively via Nix/Terranix/OpenTofu:

1. **AWS Infrastructure Components**
   - VPC configurations and networking
   - EC2 instances and auto-scaling groups
   - Load balancers and target groups
   - S3 buckets and storage configurations
   - RDS/Aurora databases and parameter groups
   - CloudWatch alarms and dashboards
   - IAM roles, policies, and users
   - Security groups and network ACLs
   - Lambda functions (if not on Lambda.ai)
   - EKS clusters and node groups

2. **Kubernetes Infrastructure**
   - EKS cluster configurations
   - Kubernetes manifests and Helm charts
   - Ingress controller configurations
   - Storage classes and persistent volumes
   - Network policies and service mesh
   - Resource quotas and limit ranges

3. **Monitoring and Observability Infrastructure**
   - Prometheus/Grafana stacks
   - Logging aggregation (Fluentd/Logstash)
   - Alerting configurations
   - Metrics collection pipelines
   - Cost monitoring dashboards

4. **ML Platform Infrastructure**
   - MLflow server and database configurations
   - Model registry infrastructure
   - Notebook serving environments
   - Data storage and access patterns
   - Artifact storage and retrieval systems

5. **Cross-Cutting Infrastructure**
   - Certificate management (Let's Encrypt, ACM)
   - Domain and DNS configurations
   - Backup and disaster recovery systems
   - Networking and routing
   - Security and compliance configurations

#### Nix/Terranix/OpenTofu Workflow Requirements

**Terranix Module Structure**
All infrastructure components MUST be implemented as Terranix modules:

```nix
# Example: AWS VPC module
{ config, lib, ... }:
{
  resources.vpc = {
    main = {
      cidr_block = "10.0.0.0/16";
      enable_dns_support = true;
      enable_dns_hostnames = true;
      tags = {
        Name = "${config.project.name}-vpc";
        Environment = config.project.environment;
      };
    };
  };

  resources.subnet = {
    public = {
      vpc_id = "${config.resources.vpc.main.id}";
      cidr_block = "10.0.1.0/24";
      availability_zone = "us-east-1a";
      map_public_ip_on_launch = true;
      tags = {
        Name = "${config.project.name}-public-subnet";
        Environment = config.project.environment;
      };
    };
  };
}
```

**Nix Profile Generation**
Infrastructure configurations MUST be generated from both `flake.nix` and `devenv.nix` profiles:

```nix
# nix/profiles/cloud.nix
{ inputs, ... }:
{
  imports = [
    inputs.nixpkgs.terranixModules.aws
    ./modules/vpc.nix
    ./modules/rds.nix
    ./modules/s3.nix
    ./modules/eks.nix
    ./modules/mlflow.nix
  ];

  project = {
    environment = "cloud";
    name = "ml-deploy-cloud";
  };
}
```

**OpenTofu JSON Output**
All configurations MUST generate OpenTofu JSON that can be applied directly:

```bash
# Generate OpenTofu JSON from Nix
nix build .#cloud-infra

# Apply generated OpenTofu
opentofu apply -auto-approve tf.json
```

### Exceptions: Hand-Written Infrastructure Files

**NO hand-written Terraform/OpenTofu files are allowed for core infrastructure components.** All infrastructure MUST be generated through Nix/Terranix.

#### Limited Acceptable Exceptions

The following scenarios MAY allow hand-written infrastructure files, but only for specific edge cases:

1. **External Service Dependencies**
   - Third-party service integrations (e.g., external monitoring SaaS)
   - Legacy systems that cannot be migrated to Nix generation
   - Cloud provider-specific features not yet supported by Terranix

2. **Emergency Hotfixes**
   - Critical security patches requiring immediate deployment
   - Infrastructure failures requiring rapid remediation
   - Temporary workarounds for provider outages

3. **Provider-Specific Native Features**
   - New AWS/GCP/Azure features not yet supported by Terranix
   - Alpha/beta cloud services requiring native provider syntax
   - Experimental features that haven't stabilized in Terranix

**Emergency Exception Process:**
1. Document the exception and business justification
2. Create a migration plan to return to Nix generation
3. Schedule review and removal of the exception
4. Update the Nix/Terranix modules to support the missing functionality

### Parity Verification: Generated vs Deployed Resources

**Spec Artifact for Parity Verification**

The following spec artifact proves parity between generated OpenTofu JSON and deployed resources:

#### 1. OpenTofu State Diff Verification

```bash
# Generate current state from Nix configuration
nix build .#cloud-infra
opentofu state pull > current-state.json

# Compare with deployed state
opentofu state show -json > deployed-state.json

# Verify parity
opentofu state show -json | jq '.resources | sort_by(.address)' > deployed-resources.json
opentofu state show -json | jq '.resources[] | {address: .address, type: .type}' | sort_by(.address) > deployed-summary.json
```

#### 2. Infrastructure Inventory Verification

```python
# scripts/verify_infrastructure_parity.py
"""
Verifies that all deployed infrastructure matches Nix/Terranix generation.
"""
import json
import subprocess
from typing import Dict, List, Any

def generate_nix_resource_inventory() -> Dict[str, List[str]]:
    """Generate expected resource inventory from Nix configuration."""
    # Execute Nix build and extract resource addresses
    result = subprocess.run(
        ["nix", "build", ".#cloud-infra", "--json"],
        capture_output=True, text=True
    )
    nix_output = json.loads(result.stdout)
    
    # Parse Terranix module output for resource addresses
    expected_resources = []
    for module in nix_output.get("outputs", {}):
        resources = module.get("resources", {})
        for resource_type in resources:
            for resource_name in resources[resource_type]:
                expected_resources.append(f"{resource_type}.{resource_name}")
    
    return {"expected_resources": expected_resources}

def verify_deployment_parity() -> bool:
    """Verify deployed resources match Nix-generated configuration."""
    # Get deployed state
    result = subprocess.run(
        ["opentofu", "state", "show", "-json"],
        capture_output=True, text=True
    )
    deployed_state = json.loads(result.stdout)
    
    # Extract deployed resources
    deployed_resources = []
    for resource in deployed_state.get("resources", []):
        deployed_resources.append(resource.get("address", ""))
    
    expected_resources = generate_nix_resource_inventory()["expected_resources"]
    
    # Verify parity
    missing = set(expected_resources) - set(deployed_resources)
    extra = set(deployed_resources) - set(expected_resources)
    
    print(f"Expected resources: {len(expected_resources)}")
    print(f"Deployed resources: {len(deployed_resources)}")
    print(f"Missing resources: {missing}")
    print(f"Extra resources: {extra}")
    
    return len(missing) == 0 and len(extra) == 0
```

#### 3. Configuration Hash Verification

```nix
# nix/verify.nix
{ 
  lib, 
  pkgs, 
  inputs,
  terraform,
}:

let
  # Generate OpenTofu JSON from Nix configuration
  generated-infra = pkgs.stdenv.mkDerivation {
    name = "ml-deploy-infra";
    src = ./.;
    buildInputs = [ terraform ];
    buildPhase = ''
      nix eval --json --file flake.nix#cloud-infra > tf.json
      terraform fmt -recursive tf.json
    '';
    installPhase = ''
      cp tf.json $out/
    '';
  };

  # Generate hash of generated configuration
  infra-hash = builtins.hashFile "sha256" "${generated-infra}/tf.json";
in
{
  # Verification script
  verify = pkgs.writeShellScript "verify-infra-parity" ''
    # Generate current configuration hash
    CURRENT_HASH=$(nix eval --raw --file flake.nix#cloud-infra-hash)
    STORED_HASH=${infra-hash}
    
    if [ "$CURRENT_HASH" = "$STORED_HASH" ]; then
      echo "Infrastructure configuration parity verified"
      exit 0
    else
      echo "Infrastructure configuration mismatch detected"
      echo "Expected hash: $STORED_HASH"
      echo "Current hash: $CURRENT_HASH"
      exit 1
    fi
  '';
}
```

#### 4. Acceptance Test for Parity

```python
# tests/test_infrastructure_parity.py
"""
Acceptance test demonstrating Nix/Terranix/OpenTofu parity with deployed resources.
"""
import pytest
import subprocess
import json
from pathlib import Path

def test_nix_terraform_parity():
    """Test that Nix-generated OpenTofu JSON matches deployed state."""
    # Step 1: Generate OpenTofu JSON from Nix
    result = subprocess.run(
        ["nix", "build", ".#cloud-infra"],
        capture_output=True, text=True
    )
    assert result.returncode == 0, "Nix infrastructure build failed"
    
    # Step 2: Verify generated OpenTofu JSON is valid
    with open("tf.json", "r") as f:
        infra_config = json.load(f)
    
    assert "resource" in infra_config, "Generated OpenTofu missing resource section"
    
    # Step 3: Apply infrastructure in dry-run mode
    result = subprocess.run(
        ["opentofu", "plan", "-out=tf.plan"],
        capture_output=True, text=True
    )
    assert result.returncode == 0, "OpenTofu plan failed"
    
    # Step 4: Verify no changes detected (parity confirmed)
    with open("tf.plan", "rb") as f:
        plan_data = json.load(f)
    
    resource_changes = plan_data.get("resource_changes", [])
    changes = [rc for rc in resource_changes if rc.get("change", {}).get("actions", []) != ["no-op"]]
    
    assert len(changes) == 0, f"Infrastructure parity failed: {changes}"

def test_emulation_vs_cloud_parity():
    """Test that local emulation stack matches cloud profile."""
    # Generate local emulation infrastructure
    result = subprocess.run([
        "nix", "build", ".#local-infra"
    ], capture_output=True, text=True)
    assert result.returncode == 0
    
    # Generate cloud infrastructure
    result = subprocess.run([
        "nix", "build", ".#cloud-infra"
    ], capture_output=True, text=True)
    assert result.returncode == 0
    
    # Verify both produce valid OpenTofu JSON
    with open("tf.json", "r") as f:
        local_config = json.load(f)
    
    # Extract and compare resource types and configurations
    # (Implementation depends on specific comparison logic)
    assert validate_infrastructure_structure(local_config)
```

### Implementation Guidance

#### Nix Module Organization
```
nix/
├── modules/
│   ├── aws/
│   │   ├── vpc.nix
│   │   ├── rds.nix
│   │   ├── s3.nix
│   │   └── eks.nix
│   ├── kubernetes/
│   │   ├── ingress.nix
│   │   ├── monitoring.nix
│   │   └── mlflow.nix
│   └── shared/
│       ├── networking.nix
│       ├── security.nix
│       └── monitoring.nix
├── profiles/
│   ├── local.nix
│   ├── cloud.nix
│   └── ci.nix
└── verify.nix
```

#### Terranix Configuration
```nix
# flake.nix
{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    terranix.url = "github:terranix/terranix";
  };

  outputs = { self, nixpkgs, terranix }:
  let
    system = "x86_64-linux";
    pkgs = nixpkgs.legacyPackages.${system};
  in
  {
    # Cloud infrastructure profile
    cloud-infra = terranix.lib.mkTerraform {
      inherit pkgs;
      configuration = ./nix/profiles/cloud.nix;
    };

    # Local emulation profile
    local-infra = terranix.lib.mkTerraform {
      inherit pkgs;
      configuration = ./nix/profiles/local.nix;
    };

    # Verification script
    checks.${system}.parity = pkgs.writeShellScript "verify-infrastructure-parity" ''
      # Implementation of parity verification
    '';
  };
}
```

### Acceptance Criteria

1. **Complete Infrastructure Coverage**: All infrastructure components are generated through Nix/Terranix/OpenTofu
2. **No Hand-Written Exception**: No hand-written Terraform/OpenTofu files for core infrastructure
3. **Parity Verification**: Automated tests verify generated OpenTofu JSON matches deployed state
4. **Dual-Profile Support**: Both local_emulation and cloud profiles use Nix/Terranix generation
5. **Hash Verification**: Configuration changes are detected and validated through hash verification
6. **Emergency Process**: Documented exception process for rare edge cases
7. **CI Integration**: Infrastructure parity checks are integrated into CI/CD pipeline

### Related Decisions

- [Project Scope and Constraints](../decisions/project-scope-and-constraints.md) - Overall architectural direction
- [AWS Kubernetes Contract](../decisions/aws-kubernetes-contract.md) - Kubernetes infrastructure requirements
- [MLflow PostgreSQL+S3 Contract](../decisions/mlflow-postgres-s3-contract.md) - MLflow storage infrastructure
- [Lambda.ai Slurm Contract](../decisions/lambda-ai-slurm-contract.md) - Distributed training infrastructure

### Open Items

- Specific Terranix module versioning and update strategy
- Integration with infrastructure-as-code scanning tools
- Detailed emergency exception approval process
- Performance optimization for large infrastructure generation
- Integration with drift detection and remediation automation

---

## Rationale

### Why Nix/Terranix/OpenTofu Exclusively?

1. **Reproducibility**: Nix provides hermetic, reproducible builds
2. **Declarative**: Infrastructure defined in pure functional code
3. **Multi-Profile Support**: Single source for local_emulation and cloud profiles
4. **Version Control**: Infrastructure changes tracked in git
5. **Dependency Management**: Nix manages all dependencies
6. **Security**: Reduced risk of manual errors and drift

### Why No Hand-Written Exceptions?

1. **Maintainability**: Single source of truth prevents drift
2. **Auditability**: All changes are tracked and reviewable
3. **Testing**: Automated testing of all infrastructure changes
4. **Documentation**: Code-based documentation is always up-to-date
5. **Scalability**: Nix scales to large, complex infrastructure sets

### Why Parity Verification?

1. **Trust**: Confidence that deployed resources match specification
2. **Change Detection**: Early detection of unauthorized modifications
3. **Compliance**: Ensure deployed infrastructure meets security and compliance requirements
4. **Drift Prevention**: Automated detection and remediation of infrastructure drift
5. **Audit Trail**: Complete history of infrastructure changes and verifications

---

## Implementation Notes

### Local Development Workflow
1. Modify Nix/Terranix modules
2. Generate OpenTofu JSON with `nix build .#cloud-infra`
3. Test with `opentofu plan`
4. Apply with `opentofu apply`
5. Verify parity with acceptance tests

### CI/CD Integration
1. Infrastructure changes trigger build verification
2. Parity tests run before deployment
3. Hash verification ensures configuration consistency
4. Drift detection runs periodically

### Monitoring and Alerting
1. Infrastructure drift alerts
2. Configuration hash mismatch notifications
3. Resource compliance violations
4. Performance metrics for infrastructure generation
