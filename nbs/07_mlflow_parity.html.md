---
title: "MLflow Parity Helpers"
---

# MLflow Parity Helpers

> nbdev source for local MLflow parity stack helpers (PostgreSQL + Floci-backed S3-compatible artifacts).

::: {#7bbd5a99 .cell export='null'}
``` {.python .cell-code}
from __future__ import annotations

from dataclasses import dataclass
import json
import os
from pathlib import Path
from typing import Any, Literal, Mapping


@dataclass(frozen=True)
class LocalMlflowParityConfig:
    """Configuration for local MLflow parity stack."""

    postgres_user: str = "mlflow"
    postgres_password: str = "mlflow"
    postgres_db: str = "mlflow"
    postgres_port: int = 5432
    aws_access_key_id: str = "test"
    aws_secret_access_key: str = "test"
    s3_bucket: str = "mlflow"
    mlflow_port: int = 5000
    mlflow_host: str = "0.0.0.0"
    compose_project_name: str = "mlflow-parity"

    @property
    def backend_store_uri(self) -> str:
        return (
            f"postgresql://{self.postgres_user}:{self.postgres_password}"
            f"@localhost:{self.postgres_port}/{self.postgres_db}"
        )

    @property
    def artifacts_destination(self) -> str:
        return f"s3://{self.s3_bucket}"

    @property
    def mlflow_tracking_uri(self) -> str:
        return f"http://localhost:{self.mlflow_port}"

    @property
    def s3_endpoint_url(self) -> str:
        return "http://floci:4566"


@dataclass(frozen=True)
class MlflowStorageConfig:
    """Runtime MLflow storage configuration aligned to PostgreSQL + S3."""

    backend_store_uri: str
    artifacts_destination: str
    tracking_uri: str
    aws_access_key_id: str
    aws_secret_access_key: str
    s3_endpoint_url: str | None = None
    model_version_source_validation_regex: str | None = None


@dataclass(frozen=True)
class MlflowTrackingServer:
    """MLflow tracking server configuration per spec requirements.
    
    Implements entity from spec (line 157-165):
    - backend_store: enum {sqlite, postgresql}
    - artifact_store: enum {filesystem, floci, s3}
    - has_reverse_proxy: Boolean (spec requirement: must be true)
    - reverse_proxy_tool: enum {traefik} (new field w007)
    - model_version_source_validation_enabled: Boolean
    - profile_switchable: Boolean
    - deployment_profile: enum {local_emulation, cloud}
    """
    backend_store: Literal["sqlite", "postgresql"]
    artifact_store: Literal["filesystem", "floci", "s3"]
    has_reverse_proxy: bool
    reverse_proxy_tool: Literal["traefik"]
    model_version_source_validation_enabled: bool
    profile_switchable: bool
    deployment_profile: Literal["local_emulation", "cloud"]


@dataclass(frozen=True)
class LocalInfrastructureParityConfig:
    """Configuration for local compute-plane parity services."""

    aws_region: str = "us-east-1"
    k3s_api_port: int = 6443
    slurmctld_port: int = 6817
    network_name: str = "ml_local"


@dataclass(frozen=True)
class CloudMlflowParityConfig:
    """Configuration for cloud profile with Traefik reverse proxy."""

    postgres_user: str = "mlflow"
    postgres_password: str = "mlflow"
    postgres_db: str = "mlflow"
    postgres_host: str = "postgres"
    postgres_port: int = 5432
    mlflow_port: int = 5000
    traefik_http_port: int = 80
    traefik_https_port: int = 443
    network_name: str = "ml_cloud"
    mlflow_host_rule: str = "mlflow.internal"
    artifact_bucket: str = "mlflow-artifacts"
    model_version_source_validation_regex: str = r"^s3://mlflow-artifacts/.*"


def render_local_compose_config(config: LocalMlflowParityConfig) -> dict[str, Any]:
    """Render a Docker Compose config for local PostgreSQL + Floci-backed MLflow."""
    postgres_image = "postgres:16-alpine"
    mlflow_image = "ghcr.io/mlflow/mlflow:v2.14.2"
    return {
        "name": config.compose_project_name,
        "services": {
            "postgres": {
                "image": postgres_image,
                "environment": {
                    "POSTGRES_USER": config.postgres_user,
                    "POSTGRES_PASSWORD": config.postgres_password,
                    "POSTGRES_DB": config.postgres_db,
                },
                "ports": [f"{config.postgres_port}:5432"],
                "healthcheck": {
                    "test": ["CMD-SHELL", "pg_isready -U $${POSTGRES_USER}"],
                    "interval": "5s",
                    "timeout": "3s",
                    "retries": 20,
                },
            },
            "mlflow": {
                "image": mlflow_image,
                "depends_on": {"postgres": {"condition": "service_healthy"}},
                "command": [
                    "mlflow",
                    "server",
                    "--host",
                    config.mlflow_host,
                    "--port",
                    str(config.mlflow_port),
                    "--backend-store-uri",
                    (
                        f"postgresql://{config.postgres_user}:{config.postgres_password}"
                        f"@postgres:5432/{config.postgres_db}"
                    ),
                    "--artifacts-destination",
                    f"s3://{config.s3_bucket}",
                ],
                "environment": {
                    "AWS_ACCESS_KEY_ID": config.aws_access_key_id,
                    "AWS_SECRET_ACCESS_KEY": config.aws_secret_access_key,
                    "AWS_DEFAULT_REGION": "us-east-1",
                    "MLFLOW_S3_ENDPOINT_URL": config.s3_endpoint_url,
                },
                "ports": [f"{config.mlflow_port}:{config.mlflow_port}"],
            },
        },
    }


def render_local_infra_compose_config(
    config: LocalInfrastructureParityConfig | None = None,
) -> dict[str, Any]:
    """Render local emulation compute-plane config (Kubernetes, Slurm)."""
    runtime = config or LocalInfrastructureParityConfig()
    return {
        "services": {
            "k3s": {
                "image": "rancher/k3s:v1.29.4-k3s1",
                "privileged": True,
                "command": "server --disable traefik --disable metrics-server",
                "ports": [f"{runtime.k3s_api_port}:6443"],
                "networks": [runtime.network_name],
            },
            "slurmctld": {
                "image": "nathanhess/slurm:latest",
                "command": ["slurm_controller"],
                "ports": [f"{runtime.slurmctld_port}:6817"],
                "networks": [runtime.network_name],
            },
            "slurmd": {
                "image": "nathanhess/slurm:latest",
                "command": ["slurm_worker"],
                "depends_on": {"slurmctld": {"condition": "service_started"}},
                "networks": [runtime.network_name],
            },
        },
        "networks": {runtime.network_name: {"driver": "bridge"}},
    }


def render_local_aws_emulator_compose_config(
    config: LocalInfrastructureParityConfig | None = None,
) -> dict[str, Any]:
    """Render the shared Floci-backed AWS emulator compose config."""
    runtime = config or LocalInfrastructureParityConfig()
    return {
        "services": {
            "floci": {
                "image": "floci/floci:latest",
                "user": "root",
                "ports": [f"{4566}:4566"],
                "environment": {
                    "FLOCI_HOSTNAME": "floci",
                    "FLOCI_STORAGE_MODE": "persistent",
                    "AWS_DEFAULT_REGION": runtime.aws_region,
                },
                "volumes": [
                    "/var/run/docker.sock:/var/run/docker.sock",
                    "floci_data:/var/lib/floci",
                ],
                "networks": [runtime.network_name],
                "healthcheck": {
                    "test": ["CMD", "curl", "-f", "http://localhost:4566/_localstack/health"],
                    "interval": "15s",
                    "timeout": "10s",
                    "retries": 5,
                    "start_period": "20s",
                },
            },
            "floci_bootstrap": {
                "image": "amazon/aws-cli:2.15.56",
                "depends_on": {"floci": {"condition": "service_healthy"}},
                "environment": {
                    "AWS_ACCESS_KEY_ID": "test",
                    "AWS_SECRET_ACCESS_KEY": "test",
                    "AWS_DEFAULT_REGION": runtime.aws_region,
                    "AWS_ENDPOINT_URL": "http://floci:4566",
                },
                "entrypoint": ["/bin/sh", "-c"],
                "command": [
                    """
echo "Initialising Floci buckets and roles..."
aws s3 mb s3://mlflow-artifacts --endpoint-url=http://floci:4566 || true
aws s3 mb s3://model-registry --endpoint-url=http://floci:4566 || true
aws iam create-role \
  --role-name ml-deploy-local \
  --assume-role-policy-document '{"Version":"2012-10-17","Statement":[{"Effect":"Allow","Principal":{"Service":"ec2.amazonaws.com"},"Action":"sts:AssumeRole"}]}' \
  --endpoint-url=http://floci:4566 || true
echo "Floci init complete."
""".strip()
                ],
                "networks": [runtime.network_name],
            },
        },
        "volumes": {"floci_data": {}},
        "networks": {runtime.network_name: {"driver": "bridge"}},
    }


def render_cloud_compose_config(config: CloudMlflowParityConfig | None = None) -> dict[str, Any]:
    """Render cloud profile compose config with Traefik in front of MLflow."""
    runtime = config or CloudMlflowParityConfig()
    return {
        "services": {
            "traefik": {
                "image": "traefik:v3.1.1",
                "ports": [
                    f"{runtime.traefik_http_port}:80",
                    f"{runtime.traefik_https_port}:443",
                ],
                "volumes": ["/var/run/docker.sock:/var/run/docker.sock"],
                "networks": [runtime.network_name],
                "command": [
                    "--entrypoints.web.address=:80",
                    "--entrypoints.websecure.address=:443",
                    "--providers.docker=true",
                    "--providers.docker.exposedbydefault=false",
                    f"--providers.docker.network={runtime.network_name}",
                ],
            },
            "postgres": {
                "image": "postgres:16-alpine",
                "environment": {
                    "POSTGRES_USER": runtime.postgres_user,
                    "POSTGRES_PASSWORD": runtime.postgres_password,
                    "POSTGRES_DB": runtime.postgres_db,
                },
                "ports": [f"{runtime.postgres_port}:5432"],
                "networks": [runtime.network_name],
            },
            "mlflow": {
                "image": "ghcr.io/mlflow/mlflow:v2.14.2",
                "depends_on": {"postgres": {"condition": "service_started"}},
                "command": [
                    "mlflow",
                    "server",
                    "--host",
                    "0.0.0.0",
                    "--port",
                    str(runtime.mlflow_port),
                    "--backend-store-uri",
                    (
                        f"postgresql://{runtime.postgres_user}:{runtime.postgres_password}"
                        f"@{runtime.postgres_host}:5432/{runtime.postgres_db}"
                    ),
                    "--artifacts-destination",
                    f"s3://{runtime.artifact_bucket}",
                ],
                "environment": {
                    "MLFLOW_CREATE_MODEL_VERSION_SOURCE_VALIDATION_REGEX": runtime.model_version_source_validation_regex,
                },
                "networks": [runtime.network_name],
                "labels": {
                    "traefik.enable": "true",
                    "traefik.http.routers.mlflow.rule": f"Host(`{runtime.mlflow_host_rule}`)",
                    "traefik.http.routers.mlflow.entrypoints": "websecure",
                    "traefik.http.services.mlflow.loadbalancer.server.port": str(runtime.mlflow_port),
                },
            },
        },
        "networks": {runtime.network_name: {"driver": "bridge"}},
    }


def render_full_local_emulation_compose_config(
    data_plane: LocalMlflowParityConfig | None = None,
    infra_plane: LocalInfrastructureParityConfig | None = None,
) -> dict[str, Any]:
    """Combine data-plane, compute-plane, and AWS emulator services for full local parity."""
    data = render_local_compose_config(data_plane or LocalMlflowParityConfig())
    infra = render_local_infra_compose_config(infra_plane)
    aws = render_local_aws_emulator_compose_config(infra_plane)
    return {
        "name": (data_plane or LocalMlflowParityConfig()).compose_project_name,
        "services": {**data["services"], **infra["services"], **aws["services"]},
        "networks": infra["networks"],
        "volumes": aws["volumes"],
    }


def write_local_compose_file(path: Path, config: LocalMlflowParityConfig) -> Path:
    """Write compose configuration as JSON-compatible YAML subset."""
    path.parent.mkdir(parents=True, exist_ok=True)
    compose_dict = render_local_compose_config(config)
    path.write_text(json.dumps(compose_dict, indent=2) + "\n", encoding="utf-8")
    return path


def build_mlflow_server_command(config: LocalMlflowParityConfig) -> list[str]:
    """Build an MLflow server command matching the parity posture."""
    return [
        "mlflow",
        "server",
        "--host",
        config.mlflow_host,
        "--port",
        str(config.mlflow_port),
        "--backend-store-uri",
        config.backend_store_uri,
        "--artifacts-destination",
        config.artifacts_destination,
    ]


def build_mlflow_runtime_env(config: LocalMlflowParityConfig) -> dict[str, str]:
    """Build environment variables for Floci-backed MLflow artifact storage."""
    return {
        "MLFLOW_TRACKING_URI": config.mlflow_tracking_uri,
        "AWS_ACCESS_KEY_ID": config.aws_access_key_id,
        "AWS_SECRET_ACCESS_KEY": config.aws_secret_access_key,
        "MLFLOW_S3_ENDPOINT_URL": config.s3_endpoint_url,
    }


def resolve_mlflow_storage_config(
    env: Mapping[str, str] | None = None,
) -> MlflowStorageConfig:
    """Resolve MLflow runtime settings with PostgreSQL + S3 parity defaults."""
    values = env or os.environ
    return MlflowStorageConfig(
        backend_store_uri=values.get(
            "MLFLOW_BACKEND_STORE_URI",
            "postgresql://mlflow:mlflow@localhost:5432/mlflow",
        ),
        artifacts_destination=values.get("MLFLOW_ARTIFACTS_DESTINATION", "s3://mlflow"),
        tracking_uri=values.get("MLFLOW_TRACKING_URI", "http://localhost:5000"),
        aws_access_key_id=values.get("AWS_ACCESS_KEY_ID", "test"),
        aws_secret_access_key=values.get("AWS_SECRET_ACCESS_KEY", "test"),
        s3_endpoint_url=values.get("MLFLOW_S3_ENDPOINT_URL"),
        model_version_source_validation_regex=values.get(
            "MLFLOW_CREATE_MODEL_VERSION_SOURCE_VALIDATION_REGEX"
        ),
    )


def build_mlflow_runtime_env_from_storage(config: MlflowStorageConfig) -> dict[str, str]:
    """Build process env vars from resolved PostgreSQL + S3 MLflow settings."""
    env = {
        "MLFLOW_TRACKING_URI": config.tracking_uri,
        "MLFLOW_BACKEND_STORE_URI": config.backend_store_uri,
        "MLFLOW_ARTIFACTS_DESTINATION": config.artifacts_destination,
        "AWS_ACCESS_KEY_ID": config.aws_access_key_id,
        "AWS_SECRET_ACCESS_KEY": config.aws_secret_access_key,
    }
    if config.s3_endpoint_url:
        env["MLFLOW_S3_ENDPOINT_URL"] = config.s3_endpoint_url
    if config.model_version_source_validation_regex:
        env["MLFLOW_CREATE_MODEL_VERSION_SOURCE_VALIDATION_REGEX"] = (
            config.model_version_source_validation_regex
        )
    return env


def build_cloud_mlflow_runtime_env(config: MlflowStorageConfig) -> dict[str, str]:
    """Build cloud-profile env vars and enforce source validation policy."""
    if not config.model_version_source_validation_regex:
        raise ValueError(
            "MLFLOW_CREATE_MODEL_VERSION_SOURCE_VALIDATION_REGEX is required for cloud profile"
        )
    return build_mlflow_runtime_env_from_storage(config)
```
:::


