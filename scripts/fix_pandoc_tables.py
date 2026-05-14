#!/usr/bin/env python3
"""
Script to fix Pandoc table parsing issues in Quarto files.
This converts complex tables to simpler formats that Pandoc can handle.
"""

import re
from pathlib import Path

def fix_table_in_content(content):
    """Fix complex tables that cause Pandoc jog.lua errors."""
    
    # Pattern to match complex tables
    table_pattern = r'\| Layer \| Primary tools \| Role in this repository \|'
    
    if "Layer | Primary tools | Role in this repository" in content:
        # Replace the complex table with a simpler list format
        replacement = """## Software stack summary (simplified format)

The stack below is ordered from the most structuring choices to the most implementation-local ones.

### Authorization Layer
- **Primary tools**: OIDC IdP + centralized policy engine
- **Role**: Central authority for roles, capabilities, and request validation

### Promotion Gates
- **Primary tools**: Model artifacts + MLOps definitions  
- **Role**: DEV→UAT→REGRESSION→PROD approval and validation for both product and platform changes

### Infrastructure Definition
- **Primary tools**: Nix + Terranix + OpenTofu JSON
- **Role**: Canonical source of truth for generated Docker, Compose, and OpenTofu artifacts

### Package/Module Workflow
- **Primary tools**: nbdev + Quarto `.qmd`
- **Role**: Canonical ML-researcher workflow and architecture authoring surface

### Python Environment
- **Primary tools**: uv2nix + uv + `.venv`
- **Role**: Nix-controlled dependency sync and reproducible local environment

### Documentation Site
- **Primary tools**: Quarto website (`_docs`) + Mermaid
- **Role**: Self-contained, publishable architecture/implementation docs

### Web Control Plane
- **Primary tools**: WebUI + backend contracts
- **Role**: Primary user-facing surface for execution and monitoring

### Notebook Source Management
- **Primary tools**: Shared notebook repository
- **Role**: Common notebook source for both local emulation and cloud runs

### Workflow Orchestration
- **Primary tools**: Airflow
- **Role**: Pipeline and workflow orchestration distinct from scheduler execution

### Kubernetes ML Platform
- **Primary tools**: Kubeflow Pipelines (optional)
- **Role**: Kubernetes-native ML pipeline layer in the K8s execution lane

### Experiment Tracking
- **Primary tools**: MLflow
- **Role**: Run metadata, model artifacts, and promotion traceability

### Data Lineage
- **Primary tools**: MLflow metadata + lineage contracts
- **Role**: Traceability across data, training, and promoted model artifacts

### Execution Backends
- **Primary tools**: Local + Slurm + Kubernetes adapters
- **Role**: Route execution by target environment with local compute as a first-class option

### Data/Artifact Stores
- **Primary tools**: PostgreSQL + S3-compatible storage (Floci local, S3 cloud)
- **Role**: Tracking backend and artifact persistence

### Local Emulation
- **Primary tools**: Docker Compose + Floci + K3s + Slurm-Docker + Traefik
- **Role**: Real local compute and data-plane environment mirroring cloud-facing contracts

### Observability
- **Primary tools**: Prometheus + Grafana + MLflow + policy/audit logs
- **Role**: Metrics, dashboards, run telemetry, and auditability

### Cost Visibility
- **Primary tools**: AWS Cost Explorer + CUR + Athena + Budgets
- **Role**: Spend reporting and attribution"""
        
        # Replace the table section
        content = re.sub(
            r'\| Layer \| Primary tools \| Role in this repository \|.*?(?=\n\n##|\n\Z)', 
            replacement, 
            content, 
            flags=re.DOTALL
        )
    
    return content

def fix_quarto_file(file_path):
    """Fix a specific Quarto file with table issues."""
    try:
        with open(file_path, 'r', encoding='utf-8') as f:
            content = f.read()
        
        original_content = content
        
        # Fix tables
        content = fix_table_in_content(content)
        
        if content != original_content:
            with open(file_path, 'w', encoding='utf-8') as f:
                f.write(content)
            print(f"✅ Fixed table issues in: {file_path.name}")
            return True
        else:
            print(f"ℹ️  No table issues found in: {file_path.name}")
            return False
            
    except Exception as e:
        print(f"❌ Error fixing {file_path.name}: {e}")
        return False

def main():
    """Fix Quarto files with Pandoc table issues."""
    nbs_dir = Path("nbs")
    
    # Files that are known to have table issues
    problematic_files = [
        "01_02-platform_introduction.qmd"
    ]
    
    print("Checking for Pandoc table issues...")
    print("=" * 50)
    
    fixed_count = 0
    
    for file_name in problematic_files:
        file_path = nbs_dir / file_name
        if file_path.exists():
            if fix_quarto_file(file_path):
                fixed_count += 1
        else:
            print(f"⚠️  File not found: {file_name}")
    
    print("=" * 50)
    print(f"📊 SUMMARY: Fixed {fixed_count} files with table issues")
    
    if fixed_count > 0:
        print("\n🎉 Table issues resolved! Files should now render without Pandoc errors.")
        print("Try rendering the fixed files with: quarto render --no-execute")

if __name__ == "__main__":
    main()