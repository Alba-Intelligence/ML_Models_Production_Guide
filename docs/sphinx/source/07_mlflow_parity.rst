MLflow Parity Helpers
====================

nbdev source for local MLflow parity stack helpers (PostgreSQL + Floci-backed S3-compatible artifacts).

.. code-block:: python

   #| eval: false
   #| default_exp: mlflow_parity
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
   # ... (truncated for brevity)
