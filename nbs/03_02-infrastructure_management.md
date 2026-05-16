# OpenTofu Infrastructure Profiles


# Infrastructure MCP interrogation

This page owns the executable helper layer for the spec rule that
requires infrastructure MCP surfaces, when available, to expose the
minimum interrogation scope by default.

``` python
from __future__ import annotations

from dataclasses import dataclass, field
import os
from typing import Iterable, Mapping


DEFAULT_MCP_SCOPE = frozenset(
    {
        "mlflow",
        "observability",
        "aws_cost_visibility",
        "lambda_ai_usage_visibility",
        "infrastructure_visibility",
        "docs_and_decisions",
    }
)

REQUIRED_INFRASTRUCTURE_INTERROGATION_ASPECTS = frozenset(
    {
        "iac_plans_and_state",
        "kubernetes_runtime_state",
        "lambda_ai_slurm_runtime_state",
        "cloud_resource_inventory",
        "cost_and_usage_signals",
    }
)

KNOWN_INFRASTRUCTURE_MCP_SERVERS = REQUIRED_INFRASTRUCTURE_INTERROGATION_ASPECTS
MCP_INVENTORY_ENV_VAR = "MCP_INFRASTRUCTURE_SERVERS"


def _normalize_server_names(server_names: Iterable[str]) -> tuple[str, ...]:
    normalized = tuple(name.strip() for name in server_names if name.strip())
    unknown = sorted(set(normalized) - KNOWN_INFRASTRUCTURE_MCP_SERVERS)
    if unknown:
        raise ValueError(
            "unknown infrastructure MCP server names: " + ", ".join(unknown)
        )
    return normalized


def parse_infrastructure_mcp_inventory(raw_inventory: str | None) -> tuple[str, ...]:
    if raw_inventory is None or not raw_inventory.strip():
        return ()
    return _normalize_server_names(raw_inventory.split(","))


@dataclass(frozen=True)
class InfrastructureMcpInventory:
    """Normalized list of infrastructure MCP server names."""

    server_names: tuple[str, ...] = field(default_factory=tuple)

    @classmethod
    def from_env(
        cls, env: Mapping[str, str] | None = None
    ) -> "InfrastructureMcpInventory":
        values = env or os.environ
        return cls(
            server_names=parse_infrastructure_mcp_inventory(
                values.get(MCP_INVENTORY_ENV_VAR)
            )
        )

    def normalized(self) -> tuple[str, ...]:
        return _normalize_server_names(self.server_names)

    def is_available(self) -> bool:
        return bool(self.normalized())


@dataclass(frozen=True)
class InfrastructureMcpInterrogationProfile:
    """Default MCP scope plus the realized infrastructure interrogation aspects."""

    mcp_servers_available: bool
    available_servers: frozenset[str]
    default_mcp_scope: frozenset[str] = DEFAULT_MCP_SCOPE
    required_infrastructure_interrogation_aspects: frozenset[str] = (
        REQUIRED_INFRASTRUCTURE_INTERROGATION_ASPECTS
    )
    infrastructure_interrogation_aspects: frozenset[str] = field(
        default_factory=frozenset
    )


def assess_infrastructure_mcp_availability(
    inventory: InfrastructureMcpInventory,
) -> bool:
    return inventory.is_available()


def build_infrastructure_mcp_interrogation_profile(
    inventory: InfrastructureMcpInventory,
) -> InfrastructureMcpInterrogationProfile:
    normalized_servers = frozenset(inventory.normalized())
    servers_available = bool(normalized_servers)
    return InfrastructureMcpInterrogationProfile(
        mcp_servers_available=servers_available,
        available_servers=normalized_servers,
        infrastructure_interrogation_aspects=(
            REQUIRED_INFRASTRUCTURE_INTERROGATION_ASPECTS
            if servers_available
            else frozenset()
        ),
    )
```

## Usage

- Pass an explicit inventory object from assistant-facing orchestration
  code.
- If the inventory is non-empty, the helper returns the required
  infrastructure interrogation aspect set.
- If no infrastructure MCP servers are available, the realized aspect
  set stays empty.

This page summarizes the dual-profile infrastructure posture.

## Profiles

- **local_emulation**: Floci + K3s + Slurm-Docker paired with
  MLflow/PostgreSQL.
- **cloud**: AWS-backed infrastructure with Kubernetes control plane and
  Lambda.ai integration surfaces.

## Generation model

- Terranix modules under `nix/modules/` provide shared plus
  profile-specific definitions.
- Profile entrypoints under `nix/profiles/` compose modules into
  OpenTofu-compatible JSON.
- Apply flow is profile-scoped and local-emulation validation should
  precede cloud rollout.

## Key outputs

- Deployment profile identification.
- MLflow tracking URI per profile.
- Storage and scheduler endpoint references required by orchestration
  layers.

## Copy-pasteable Terranix entrypoints

The notebook pages document the same source that lives under `nix/` so
the infrastructure story can be read without directory spelunking.

``` nix
# nix/modules/local.nix
{ config, lib, ... }:

with lib;

{
  imports = [ ./shared.nix ];

  config.mlDeploy = {
    profile           = "local_emulation";
    mlflowTrackingUri = "http://localhost:5001";
    awsEndpointUrl    = "http://localhost:4566";
    postgresHost      = "localhost";
  };

  config.provider.aws = {
    region                      = config.mlDeploy.awsRegion;
    access_key                  = "test";
    secret_key                  = "test";
    skip_credentials_validation = true;
    skip_metadata_api_check     = true;
    skip_requesting_account_id  = true;
    endpoints = {
      s3             = config.mlDeploy.awsEndpointUrl;
      iam            = config.mlDeploy.awsEndpointUrl;
      sts            = config.mlDeploy.awsEndpointUrl;
      ec2            = config.mlDeploy.awsEndpointUrl;
      secretsmanager = config.mlDeploy.awsEndpointUrl;
      cloudwatch     = config.mlDeploy.awsEndpointUrl;
      logs           = config.mlDeploy.awsEndpointUrl;
    };
  };
}
```

``` nix
# nix/modules/cloud.nix
{ config, lib, ... }:

with lib;

{
  imports = [ ./shared.nix ];

  config.mlDeploy = {
    profile           = "cloud";
    mlflowTrackingUri = "\${var.mlflow_tracking_uri}";
    awsEndpointUrl    = null;
    postgresHost      = "\${var.postgres_host}";
  };

  config.provider.aws = {
    region = config.mlDeploy.awsRegion;
  };
}
```

``` nix
# nix/modules/shared.nix
{ config, lib, ... }:

with lib;

let
  cfg = config.mlDeploy;
in {
  options.mlDeploy = {
    profile = mkOption {
      type = types.enum [ "local_emulation" "cloud" ];
    };
    projectName = mkOption {
      type = types.str;
      default = "ml-deploy";
    };
    mlflowTrackingUri = mkOption {
      type = types.str;
    };
    s3BucketArtifacts = mkOption {
      type = types.str;
      default = "mlflow-artifacts";
    };
    s3BucketModelRegistry = mkOption {
      type = types.str;
      default = "model-registry";
    };
    awsRegion = mkOption {
      type = types.str;
      default = "us-east-1";
    };
    awsEndpointUrl = mkOption {
      type = types.nullOr types.str;
      default = null;
    };
    postgresHost = mkOption {
      type = types.str;
    };
    postgresPort = mkOption {
      type = types.int;
      default = 5432;
    };
    postgresDb = mkOption {
      type = types.str;
      default = "mlflow";
    };
  };

  config = {
    resource.aws_s3_bucket."${cfg.projectName}-artifacts" = {
      bucket = cfg.s3BucketArtifacts;
    };

    resource.aws_s3_bucket."${cfg.projectName}-model-registry" = {
      bucket = cfg.s3BucketModelRegistry;
    };

    output.mlflow_tracking_uri = {
      value = cfg.mlflowTrackingUri;
    };
  };
}
```
