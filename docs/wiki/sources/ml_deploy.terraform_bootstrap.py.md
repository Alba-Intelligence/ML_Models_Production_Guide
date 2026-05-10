---
updated: 2026-05-11
summary: Synthesized summary of Python-driven Terraform bootstrap helpers for MLflow storage and baseline platform resources.
read_when:
  - You are bootstrapping infrastructure with Python-managed Terraform
  - You need generated Terraform JSON and runner behavior
source_file: ../../ml_deploy/terraform_bootstrap.py
---

# Source summary: ml_deploy/terraform_bootstrap.py

## Role

Provides Python-first Terraform bootstrap support:

- typed stack configuration
- generated Terraform JSON files (`main.tf.json`, `terraform.tfvars.json`)
- subprocess-driven Terraform runner wrapper

## Main components

- `TerraformStackConfig`
- `build_tfvars(...)`
- `write_stack_files(...)`
- `PythonTerraformRunner` (`init`, `plan`, `apply`)

## Practical implication

Infrastructure bootstrap can be initiated from Python orchestration without hand-writing initial Terraform HCL files.
