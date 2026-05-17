---
title: "Web UI Backend Contracts"
---
# Web UI Backend Contracts

> nbdev source for immutable notebook execution requests and MLflow-first run visibility helpers.

```{code-block} python
#| default_exp: webui_contracts
```

```{code-block} python
#| export:
from __future__ import annotations

from dataclasses import asdict, dataclass, field
from datetime import datetime, timezone
from typing import Any, Literal


ExecutionTarget = Literal["local-replica", "lambda-slurm", "aws-kubernetes"]
RevisionKind = Literal["commit", "tag", "approved-ref"]
RunStatus = Literal["queued", "running", "finished", "failed", "canceled", "unknown"]


def _utc_now() -> str:
    return datetime.now(timezone.utc).isoformat()


def _normalize_base_url(base_url: str) -> str:
    return base_url.strip().rstrip("/")


def build_mlflow_run_url(mlflow_base_url: str, run_id: str) -> str:
    """Build a stable deep link to the MLflow run detail page."""
    normalized = _normalize_base_url(mlflow_base_url)
    if not normalized:
        raise ValueError("mlflow_base_url must be non-empty")
    if not run_id.strip():
        raise ValueError("run_id must be non-empty")
    return f"{normalized}/#/experiments/0/runs/{run_id.strip()}"


def _normalize_status(raw_status: Any) -> RunStatus:
    status = str(raw_status).strip().lower()
    if status == "queued":
        return "queued"
    if status == "running":
        return "running"
    if status == "finished":
        return "finished"
    if status == "failed":
        return "failed"
    if status == "canceled":
        return "canceled"
    return "unknown"


@dataclass(frozen=True)
class NotebookRevision:
    """Immutable notebook reference used as execution source-of-truth."""

    repository: str
    notebook_path: str
    revision: str
    revision_kind: RevisionKind = "commit"

    def as_dict(self) -> dict[str, Any]:
        return asdict(self)

    def validate(self) -> None:
        if not self.repository.strip():
            raise ValueError("repository must be non-empty")
        if not self.notebook_path.strip():
            raise ValueError("notebook_path must be non-empty")
        if not self.revision.strip():
            raise ValueError("revision must be non-empty")
        if self.revision_kind == "commit":
            cleaned = self.revision.strip().lower()
            if len(cleaned) < 7 or any(c not in "0123456789abcdef" for c in cleaned):
                raise ValueError("commit revisions must be a git SHA (>=7 hex chars)")


@dataclass(frozen=True)
class NotebookExecutionRequest:
    """Web UI request payload for environment-specific execution."""

    notebook: NotebookRevision
    target: ExecutionTarget
    requested_by: str
    config_profile: str = "default"
    parameters: dict[str, Any] = field(default_factory=dict)
    request_id: str = ""
    requested_at: str = ""

    def with_defaults(self, *, request_id: str) -> "NotebookExecutionRequest":
        if not request_id.strip():
            raise ValueError("request_id must be non-empty")
        return NotebookExecutionRequest(
            notebook=self.notebook,
            target=self.target,
            requested_by=self.requested_by,
            config_profile=self.config_profile,
            parameters=self.parameters,
            request_id=request_id,
            requested_at=self.requested_at or _utc_now(),
        )

    def validate(self) -> None:
        self.notebook.validate()
        if not self.requested_by.strip():
            raise ValueError("requested_by must be non-empty")
        if not self.config_profile.strip():
            raise ValueError("config_profile must be non-empty")
        if self.request_id and not self.request_id.strip():
            raise ValueError("request_id must be non-empty when provided")

    def as_job_spec(self) -> dict[str, Any]:
        self.validate()
        if not self.request_id:
            raise ValueError("request_id must be set before producing a job spec")
        if not self.requested_at:
            raise ValueError("requested_at must be set before producing a job spec")
        return {
            "request_id": self.request_id,
            "requested_at": self.requested_at,
            "requested_by": self.requested_by,
            "target": self.target,
            "config_profile": self.config_profile,
            "notebook": self.notebook.as_dict(),
            "parameters": self.parameters,
        }


@dataclass(frozen=True)
class RunVisibility:
    """Web UI summary model with MLflow-first observability linkage."""

    run_id: str
    status: RunStatus
    started_at: str
    finished_at: str | None
    model_version: str | None
    mlflow_run_url: str

    def as_dict(self) -> dict[str, Any]:
        return asdict(self)


def summarize_run_for_webui(
    run_metadata: dict[str, Any], *, mlflow_base_url: str
) -> RunVisibility:
    """Map backend run metadata to an MLflow-linked Web UI summary."""
    run_id = str(run_metadata.get("run_id", "")).strip()
    if not run_id:
        raise ValueError("run_metadata.run_id is required")

    normalized_status = _normalize_status(run_metadata.get("status", "unknown"))
    started_at = str(run_metadata.get("started_at", "")).strip() or _utc_now()
    finished_at_raw = run_metadata.get("finished_at")
    finished_at = str(finished_at_raw).strip() if finished_at_raw is not None else None
    model_version_raw = run_metadata.get("model_version")
    model_version = (
        str(model_version_raw).strip() if model_version_raw is not None else None
    )

    return RunVisibility(
        run_id=run_id,
        status=normalized_status,
        started_at=started_at,
        finished_at=finished_at or None,
        model_version=model_version or None,
        mlflow_run_url=build_mlflow_run_url(mlflow_base_url, run_id),
    )
```
