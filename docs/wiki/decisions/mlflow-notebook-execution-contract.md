---
updated: 2026-05-14
summary: Decision record for MLflow-first immutable notebook execution contract leveraging MLflow's existing model management capabilities.
read_when:
  - You are configuring notebook execution workflows
  - You need to understand MLflow integration for notebook management
  - You are evaluating whether to build separate notebook management vs leverage MLflow
sources:
  - ../../specs/ml-deploy-reference-repo.allium
  - ../queries/spec-quality-elicitation-session-01.md
  - ../architecture/reference-architecture-skeleton.md
  - ../decisions/mlflow-postgres-s3-contract.md
---

# Decision: MLflow-First Immutable Notebook Execution Contract

**What this page is for**: Decision record specifying the contracted behavior for immutable notebook execution using MLflow's existing model management capabilities as the foundation.

**When to read**: When configuring notebook execution workflows, evaluating MLflow integration, or determining whether to leverage existing MLflow capabilities vs building separate systems.

**Upstream spec**: `specs/ml-deploy-reference-repo.allium` — `MLflowIntegration`, `ModelManagement`

---

## Decision

### MLflow-First Approach: Leverage Existing Model Management

**RECOMMENDATION**: Use MLflow's existing model management capabilities as the foundation for immutable notebook execution rather than building a separate notebook management system. This approach leverages MLflow's proven infrastructure while meeting immutable execution requirements.

#### Core Principle: Notebooks as Models

Treat Jupyter notebooks as first-class model artifacts within MLflow's existing model management framework:

- **Notebook = Model**: Each notebook execution produces an MLflow model artifact
- **Git Commit = Model Version**: Each notebook git commit becomes a model version
- **Parameters = Model Metadata**: Notebook parameters stored as model parameters
- **Outputs = Model Artifacts**: Notebook outputs (plots, datasets, models) stored as model artifacts
- **Execution = Model Training**: Notebook execution is equivalent to model training

#### MLflow Model Management Integration

**1. Notebook Versioning via MLflow Model Registry**

```python
# notebook_execution.py
import mlflow
import git
from pathlib import Path

def execute_notebook_immutable(notebook_path, params):
    """
    Execute notebook as immutable MLflow model version.
    """
    # Get git commit hash as immutable reference
    repo = git.Repo(search_parent_directories=True)
    git_commit = repo.head.commit.hexsha

    # Set MLflow tracking to use git commit as run name
    mlflow.set_tracking_uri("postgresql://mlflow:mlflow@postgres:5432/mlflow")
    mlflow.set_experiment("notebook-executions")

    with mlflow.start_run(
        run_name=f"notebook-{Path(notebook_path).stem}-{git_commit[:8]}",
        tags={
            "notebook.path": str(notebook_path),
            "git.commit": git_commit,
            "git.branch": repo.active_branch.name,
            "immutable.reference": git_commit,
            "notebook.version": git_commit
        }
    ) as run:
        # Log notebook parameters as model parameters
        mlflow.log_params(params)

        # Execute notebook logic (simplified example)
        result = execute_notebook_logic(notebook_path, params)

        # Log metrics
        mlflow.log_metrics(result["metrics"])

        # Log artifacts (plots, datasets, models)
        for artifact_path in result["artifacts"]:
            mlflow.log_artifact(artifact_path)

        # Register as immutable model
        model_uri = mlflow.register_model(
            model_uri=f"runs:/{run.info.run_id}/model",
            name=f"notebook-{Path(notebook_path).stem}"
        )

        return {
            "run_id": run.info.run_id,
            "model_uri": model_uri,
            "git_commit": git_commit,
            "status": "completed"
        }
```

**2. Immutable Reference Format**

```python
class ImmutableNotebookReference:
    """
    Immutable notebook reference using MLflow model registry.
    """
    def __init__(self, notebook_name, model_version):
        self.notebook_name = notebook_name
        self.model_version = model_version
        self.model_uri = f"models:/{notebook_name}/{model_version}"

    @classmethod
    def from_git_commit(cls, notebook_path, git_commit):
        """Create reference from git commit."""
        notebook_name = Path(notebook_path).stem
        # Use git commit hash as model version
        model_version = git_commit[:8]  # Short hash
        return cls(notebook_name, model_version)

    def get_model_info(self):
        """Get model info from MLflow registry."""
        client = mlflow.tracking.MlflowClient()
        model_info = client.get_model_info(name=self.notebook_name, version=self.model_version)
        return model_info

    def load_model(self):
        """Load notebook execution result as model."""
        return mlflow.pytorch.load_model(self.model_uri)
```

**3. Runtime Parameter Management**

```python
class NotebookParameterManager:
    """
    Manage runtime parameters for immutable notebook execution.
    """

    # Parameters LOCKED by notebook revision (immutable)
    LOCKED_PARAMETERS = {
        "python_version",  # Python version used
        "dependencies",    # Package versions
        "notebook_path",  # Notebook file path
        "git_commit",      # Git commit hash
        "execution_env",   # Environment metadata
    }

    # Parameters ALLOWED to vary at runtime (configurable)
    VARIABLE_PARAMETERS = {
        "learning_rate",   # Model hyperparameters
        "batch_size",      # Training parameters
        "epochs",          # Training duration
        "data_path",       # Input data paths
        "output_dir",      # Output directories
    }

    # Parameters FULLY dynamic (user preferences)
    DYNAMIC_PARAMETERS = {
        "seed",            # Random seeds
        "verbose",         # Logging levels
        "debug_mode",      # Debug flags
        "visualization",  # Output preferences
    }

    @classmethod
    def validate_parameters(cls, params, notebook_metadata):
        """Validate parameter combinations."""
        # Check locked parameters match notebook metadata
        for param in cls.LOCKED_PARAMETERS:
            if param in params and params[param] != notebook_metadata.get(param):
                raise ValueError(f"Locked parameter {param} cannot be modified")

        # Validate variable parameters are within allowed ranges
        cls._validate_variable_parameters(params)

        return True

    @classmethod
    def _validate_variable_parameters(cls, params):
        """Validate variable parameter constraints."""
        if "learning_rate" in params:
            if not (0.0001 <= params["learning_rate"] <= 1.0):
                raise ValueError("Learning rate must be between 0.0001 and 1.0")

        if "batch_size" in params:
            if params["batch_size"] <= 0 or params["batch_size"] > 1024:
                raise ValueError("Batch size must be between 1 and 1024")
```

**4. Execution Status Timeline Integration**

```python
class NotebookExecutionStatus:
    """
    Notebook execution status using MLflow run lifecycle.
    """

    # Status mapping between MLflow runs and notebook execution
    STATUS_MAPPING = {
        "running": "EXECUTING",
        "finished": "COMPLETED",
        "failed": "FAILED",
        "scheduled": "PENDING",
        "cancelled": "CANCELLED"
    }

    @classmethod
    def get_execution_status(cls, run_id):
        """Get notebook execution status from MLflow run."""
        client = mlflow.tracking.MlflowClient()
        run = client.get_run(run_id)

        mlflow_status = run.info.status
        return cls.STATUS_MAPPING.get(mlflow_status, mlflow_status.upper())

    @classmethod
    def get_execution_timeline(cls, run_id):
        """Get complete execution timeline from MLflow run."""
        client = mlflow.tracking.MlflowClient()
        run = client.get_run(run_id)

        return {
            "run_id": run_id,
            "status": cls.get_execution_status(run_id),
            "start_time": run.info.start_time,
            "end_time": run.info.end_time,
            "duration": run.info.end_time - run.info.start_time if run.info.end_time else None,
            "parameters": run.data.params,
            "metrics": run.data.metrics,
            "tags": run.data.tags,
            "artifacts": client.list_artifacts(run_id)
        }
```

#### Web UI Integration with MLflow

**1. MLflow Web UI as Primary Interface**

```python
class NotebookWebUI:
    """
    Web UI for notebook execution using MLflow UI.
    """

    def __init__(self, mlflow_tracking_uri):
        self.mlflow_tracking_uri = mlflow_tracking_uri
        self.client = mlflow.tracking.MlflowClient()

    def list_notebook_executions(self, notebook_name=None):
        """List all notebook executions as model versions."""
        if notebook_name:
            # Get all versions of a specific notebook
            model_versions = self.client.search_model_versions(f"name='{notebook_name}'")
        else:
            # Get all notebook models
            model_versions = self.client.search_model_versions("name LIKE 'notebook-%'")

        return [self._format_execution_info(mv) for mv in model_versions]

    def _format_execution_info(self, model_version):
        """Format model version as notebook execution info."""
        return {
            "execution_id": model_version.run_id,
            "notebook_name": model_version.name,
            "version": model_version.version,
            "git_commit": model_version.tags.get("git_commit", "unknown"),
            "status": model_version.current_stage,
            "creation_time": model_version.creation_timestamp,
            "run_url": f"{self.mlflow_tracking_uri}/#/experiments/0/runs/{model_version.run_id}"
        }
```

**2. Notebook Execution Dashboard**

```python
# dashboard.py
import mlflow
import plotly.graph_objects as go
from datetime import datetime, timedelta

class NotebookExecutionDashboard:
    """
    Dashboard for notebook execution monitoring.
    """

    def __init__(self, mlflow_tracking_uri):
        self.mlflow_tracking_uri = mlflow_tracking_uri

    def get_execution_timeline(self, days=7):
        """Get execution timeline for the last N days."""
        client = mlflow.tracking.MlflowClient()

        # Get runs from the last N days
        end_time = datetime.now()
        start_time = end_time - timedelta(days=days)

        runs = client.search_runs(
            experiment_ids=[0],
            filter_string=f"start_time >= {int(start_time.timestamp())}",
            order_by=["start_time DESC"]
        )

        timeline_data = []
        for run in runs:
            if "notebook" in run.data.tags.get("notebook.path", ""):
                timeline_data.append({
                    "timestamp": run.info.start_time,
                    "notebook": Path(run.data.tags.get("notebook.path", "")).stem,
                    "status": run.info.status,
                    "duration": run.info.end_time - run.info.start_time if run.info.end_time else None,
                    "git_commit": run.data.tags.get("git.commit", "unknown")
                })

        return timeline_data

    def create_execution_chart(self, timeline_data):
        """Create execution status timeline chart."""
        fig = go.Figure()

        # Group by notebook
        notebook_groups = {}
        for item in timeline_data:
            notebook = item["notebook"]
            if notebook not in notebook_groups:
                notebook_groups[notebook] = []
            notebook_groups[notebook].append(item)

        # Add traces for each notebook
        colors = plotly.colors.qualitative.Set1
        for i, (notebook, items) in enumerate(notebook_groups.items()):
            timestamps = [item["timestamp"] for item in items]
            statuses = [item["status"] for item in items]

            fig.add_trace(go.Scatter(
                x=timestamps,
                y=statuses,
                mode='markers+lines',
                name=notebook,
                marker=dict(color=colors[i % len(colors)]),
                line=dict(color=colors[i % len(colors)])
            ))

        fig.update_layout(
            title="Notebook Execution Timeline",
            xaxis_title="Time",
            yaxis_title="Status",
            height=600
        )

        return fig
```

#### Implementation Examples

**1. Complete Notebook Execution Workflow**

```python
# complete_workflow.py
import mlflow
import git
from pathlib import Path
from decisions.mlflow_notebook_execution import (
    execute_notebook_immutable,
    ImmutableNotebookReference,
    NotebookParameterManager,
    NotebookExecutionStatus
)

def execute_notebook_workflow(notebook_path, params):
    """
    Complete immutable notebook execution workflow.
    """
    # Get git commit hash
    repo = git.Repo(search_parent_directories=True)
    git_commit = repo.head.commit.hexsha

    # Validate parameters
    notebook_metadata = {
        "git_commit": git_commit,
        "python_version": "3.11",
        "dependencies": ["torch", "mlflow", "pandas"]
    }

    NotebookParameterManager.validate_parameters(params, notebook_metadata)

    # Execute notebook
    result = execute_notebook_immutable(notebook_path, params)

    # Create immutable reference
    ref = ImmutableNotebookReference.from_git_commit(notebook_path, git_commit)

    # Monitor execution
    status = NotebookExecutionStatus.get_execution_status(result["run_id"])

    return {
        "immutable_reference": ref,
        "execution_result": result,
        "status": status
    }
```

**2. Web UI Integration Example**

```python
# web_ui_example.py
from decisions.mlflow_notebook_execution import NotebookWebUI, NotebookExecutionDashboard

# Initialize MLflow connection
mlflow_tracking_uri = "http://localhost:5000"
ui = NotebookWebUI(mlflow_tracking_uri)
dashboard = NotebookExecutionDashboard(mlflow_tracking_uri)

# List all notebook executions
executions = ui.list_notebook_executions()
print(f"Found {len(executions)} notebook executions")

# Get execution timeline
timeline = dashboard.get_execution_timeline(days=7)
print(f"Timeline data for last 7 days: {len(timeline)} executions")

# Create dashboard chart
chart = dashboard.create_execution_chart(timeline)
chart.show()
```

#### Acceptance Criteria

1. **MLflow Integration**: All notebook executions tracked as MLflow runs with proper tagging
2. **Immutable References**: Git commit hashes used as immutable notebook references
3. **Parameter Management**: Locked, variable, and dynamic parameters properly separated and validated
4. **Status Tracking**: Complete execution timeline visible in MLflow UI
5. **Artifact Management**: Notebook outputs properly stored as MLflow artifacts
6. **Model Registry Integration**: Notebook executions registered as MLflow models
7. **Web UI Compatibility**: Standard MLflow UI usable for notebook execution monitoring

### Related Decisions

- [MLflow PostgreSQL+S3 Contract](../decisions/mlflow-postgres-s3-contract.md) - MLflow storage and integration requirements
- [Lambda.ai Slurm Contract](../decisions/lambda-ai-slurm-contract.md) - Distributed training execution
- [AWS Kubernetes Contract](../decisions/aws-kubernetes-contract.md) - Online inference execution
- [Project Scope and Constraints](../decisions/project-scope-and-constraints.md) - Overall architectural direction

### Open Items

- Integration with existing MLflow UI for notebook-specific views
- Custom notebook execution dashboards beyond standard MLflow UI
- Notebook execution cost tracking and attribution
- Notebook execution performance monitoring and optimization
- Integration with external CI/CD pipelines for notebook execution

---

## Rationale

### Why MLflow-First Approach?

1. **Leverage Existing Infrastructure**: MLflow provides proven model management, tracking, and UI
2. **Reduced Complexity**: No need to build separate notebook management system
3. **Ecosystem Integration**: Seamless integration with existing MLflow tools and plugins
4. **Industry Standard**: MLflow is widely adopted and well-documented
5. **Cost Efficiency**: Reuse existing infrastructure rather than building duplicate systems
6. **Maintenance**: Reduced maintenance burden by leveraging MLflow's active development

### Why Treat Notebooks as Models?

1. **Consistency**: Notebooks follow the same lifecycle as models
2. **Reusability**: Notebook executions can be versioned and reused like models
3. **Traceability**: Complete lineage tracking through MLflow's proven system
4. **Monitoring**: Existing MLflow monitoring and alerting capabilities
5. **Governance**: MLflow's existing approval and promotion workflows

### Why Not Build Separate System?

1. **Duplication**: Would replicate MLflow's model management capabilities
2. **Integration Challenges**: Separate systems would need complex integration points
3. **Learning Curve**: Users would need to learn multiple systems
4. **Maintenance Overhead**: Additional system to maintain and update
5. **Consistency Issues**: Risk of inconsistent behavior between systems

---

## Implementation Notes

### Migration Strategy

1. **Phase 1**: Integrate notebook execution with existing MLflow
2. **Phase 2**: Enhance MLflow UI with notebook-specific views
3. **Phase 3**: Add custom notebook execution features
4. **Phase 4**: Full integration with existing MLflow workflows

### Training and Documentation

1. **User Training**: Train users on MLflow-based notebook execution
2. **Documentation**: Create documentation for notebook-as-model workflow
3. **Best Practices**: Develop best practices for notebook versioning and execution
4. **Examples**: Provide examples of notebook execution workflows

### Monitoring and Alerting

1. **MLflow Monitoring**: Use existing MLflow monitoring capabilities
2. **Custom Metrics**: Add notebook-specific metrics and alerts
3. **Performance Tracking**: Monitor notebook execution performance
4. **Cost Tracking**: Track notebook execution costs and resource usage
