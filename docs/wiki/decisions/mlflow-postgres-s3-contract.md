---
updated: 2026-05-14
summary: Decision record for MLflow PostgreSQL backend and S3 artifact store contracts covering schema, security, and operational requirements.
read_when:
  - You are configuring MLflow tracking server or artifact storage
  - You need to understand PostgreSQL schema expectations and S3 integration requirements
sources:
  - ../../specs/ml-deploy-reference-repo.allium
  - ../queries/spec-quality-elicitation-session-01.md
  - ../decisions/mlflow-storage-backends.md
  - ../architecture/reference-architecture-skeleton.md
---

# Decision: MLflow PostgreSQL + S3 Contract

**What this page is for**: Decision record specifying the contracted behavior for MLflow PostgreSQL backend store and S3 artifact store, including schema requirements, security considerations, and operational handling.

**When to read**: When setting up MLflow infrastructure, designing data lineage contracts, or implementing MLflow tracking/artifact storage integrations.

**Upstream spec**: `specs/ml-deploy-reference-repo.allium` — `RequireMlflowProductionStorageBackends`, `RequireMlflowReverseProxyInProduction`, `RequireMlflowSourceValidationInProduction`

---

## Decision

### MLflow Backend Store: PostgreSQL Requirements

PostgreSQL is required as the MLflow backend store in cloud deployments and preferred for team-local setups. The following requirements apply:

#### Schema Management

- **MLflow manages schema automatically**: MLflow will create and upgrade the required schema on startup using `mlflow db upgrade`
- **No manual schema definition required**: Users should not pre-create tables or manage schema migrations manually
- **Required database**: A database named `mlflow` must exist prior to MLflow startup
- **Required user**: A database user with sufficient privileges to create/modify tables in the `mlflow` database

#### Connection Parameters

MLflow expects the following connection details via `MLFLOW_BACKEND_STORE_URI`:

```
postgresql://username:password@host:port/database
```

Example:

```
postgresql://mlflow:secure_password@mlflow-postgres:5432/mlflow
```

### MLflow Artifact Store: S3 Requirements

S3 is required as the MLflow artifact store in cloud deployments, with S3-compatible storage acceptable for local emulation.

#### Bucket Requirements

- **Explicit bucket creation**: The S3 bucket must be created prior to MLflow startup
- **Bucket naming convention**: Recommended format `mlflow-artifacts-{environment}` (e.g., `mlflow-artifacts-dev`, `mlflow-artifacts-prod`)
- **Region consistency**: Bucket should be in the same region as other workloads to minimize latency and data transfer costs

#### Connection Parameters

MLflow expects the following via `MLFLOW_DEFAULT_ARTIFACT_ROOT`:

```
s3://bucket-name/[path-prefix]
```

Examples:

- `s3://mlflow-artifacts` (root level)
- `s3://mlflow-artifacts/mlflow` (with prefix)
- `s3://mlflow-artifacts-dev/experiments` (environment-specific)

For local emulation with Floci:

```
s3://mlflow-artifacts
MLFLOW_S3_ENDPOINT_URL=http://floci:4566
```

### Security: Authentication and Authorization

#### MLflow's Native Security Limitations

As correctly noted by the user, **MLflow does not manage security/user roles aspects natively**. MLflow's built-in authentication is basic and not suitable for production use without additional layers.

#### Required Security Approach

Authentication and authorization must be handled externally:

1. **Reverse Proxy Authentication** (Required):
   - All MLflow traffic must route through a reverse proxy (Traefik)
   - The reverse proxy handles authentication (OAuth/OIDC, LDAP, etc.)
   - Authenticated user information is passed via headers to MLflow

2. **MLflow Permission System** (Limited Use):
   - MLflow has basic permission concepts (admin vs user) via environment variables
   - Not suitable for fine-grained role-based access control
   - Primary authentication should happen at the reverse proxy level

3. **Network-Level Security**:
   - PostgreSQL and S3 should be deployed in private subnets
   - Access should be restricted to trusted networks/VPCs
   - Database credentials should be managed via secrets managers

#### MLflow User Tracking

Despite MLflow not managing authentication, it does track user information:

- **MLFLOW_TRACKING_USERNAME** environment variable can be set per session
- This value is stored in the `user_name` column of MLflow tables
- Reverse proxy should set this variable based on authenticated user
- If not set, defaults to the system user or "unknown"

### Artifact Storage Organization

#### Standardized S3 Path Layout

To ensure consistency and traceability, the following path layout is recommended:

```
s3://bucket-name/
├── mlflow/                     # MLflow-specific prefix (optional)
│   ├── {experiment_id}/
│   │   ├── {run_id}/
│   │   │   ├── artifacts/      # MLflow-managed subdirectory
│   │   │   │   ├── model/      # Model artifacts
│   │   │   │   ├── data/       # Datasets, features
│   │   │   │   ├── plots/      # Visualizations
│   │   │   │   └── ...         # Other artifacts
│   │   │   └── ...             # Run metadata (params, metrics, tags)
│   │   └── ...
│   └── ...
└── ...                         # Other non-MLflow data (if bucket shared)
```

#### Recommended Configuration

For clarity and isolation:

```
MLFLOW_DEFAULT_ARTIFACT_ROOT=s3://mlflow-artifacts/mlflow
```

This results in paths like:
`s3://mlflow-artifacts/mlflow/1/3f52804b021b49d8a0efd7432a9d0b7e/artifacts/model/`

### Operational Requirements

#### Fallback Behavior: PostgreSQL Reachable but S3 Upload Fails

If PostgreSQL is reachable but S3 artifact upload fails:

1. **MLflow marks the run as FAILED**
2. **Error is logged and visible in MLflow UI**
3. **No partial artifacts are left in S3** (MLflow attempts cleanup)
4. **Run metadata (params, metrics, tags) remains in PostgreSQL**
5. **User must investigate S3 connectivity/permissions and retry**

#### Health Checks and Monitoring

- **Backend store connectivity**: Monitor PostgreSQL connection pool and query performance
- **Artifact store connectivity**: Verify S3 bucket accessibility and write permissions
- **Recommended alerts**:
  - Failed MLflow DB connections
  - S3 upload/download failures exceeding threshold
  - Artifact store latency spikes

#### Backup and Disaster Recovery

- **PostgreSQL**: Use managed service backups (RDS/Aurora) or logical dumping
- **S3**: Enable versioning and cross-region replication for critical artifacts
- **Point-in-time recovery**: PostgreSQL PITR should be configured for production

### Acceptance Criteria

1. **Schema Automation**: MLflow successfully creates/upgrades PostgreSQL schema on startup without manual intervention
2. **Artifact Persistence**: All run artifacts (models, plots, datasets) are reliably stored in and retrievable from S3
3. **Security Separation**: Authentication is handled by reverse proxy; MLflow relies on `MLFLOW_TRACKING_USERNAME` for user tracking
4. **Failure Handling**: S3 upload failures properly mark runs as failed and are visible in MLflow UI
5. **Path Consistency**: Artifacts follow the standardized path layout enabling predictable access and lifecycle management
6. **Observability**: Backend and artifact store health are monitorable via standard database and cloud watch metrics

### Implementation Guidance

#### Docker-Compose Example (Local Emulation)

```yaml
services:
  mlflow:
    image: mlflow-go:latest
    environment:
      - MLFLOW_BACKEND_STORE_URI=postgresql://mlflow:mlflow@postgres:5432/mlflow
      - MLFLOW_DEFAULT_ARTIFACT_ROOT=s3://mlflow-artifacts/mlflow
      - MLFLOW_S3_ENDPOINT_URL=http://floci:4566
      - MLFLOW_TRACKING_USERNAME=${USERNAME} # Set by reverse proxy
    depends_on:
      - postgres
      - floci
```

#### Kubernetes Deployment Considerations

- Use secrets managers for database credentials
- Configure init containers to wait for PostgreSQL/S3 readiness
- Set appropriate resource limits and requests
- Configure liveness/readiness probes for MLflow service

### Related Information

Referenced blog posts provide additional context:

- [MLflow with Airflow guide](https://medium.com/thefork/a-guide-to-mlops-with-airflow-and-mlflow-e19a82901f88)
- [Kubernetes MLflow tutorial](https://mljourney.com/end-to-end-mlops-tutorial-with-kubernetes-and-mlflow/)
- [MLflow deployment best practices](https://createbytes.com/insights/mastering-ml-deployment-mlops-kubeflow-mlflow-cicd)

---

## Related Decisions

- [MLflow Storage Backends](../decisions/mlflow-storage-backends.md) - Backend/store selection rationale
- [Lambda.ai Slurm Contract](../decisions/lambda-ai-slurm-contract.md) - Distributed training infrastructure
- [Project Scope and Constraints](../decisions/project-scope-and-constraints.md) - Overall architectural direction
- [MLflow Security + Promotion Pipeline](../revisions/2026-05-11-mlflow-security-promotion-pipeline.md) - Initial MLflow security considerations

### Open Items

- Exact reverse proxy authentication implementation (OIDC/LDAP specifics)
- Detailed monitoring alert thresholds for backend/store connectivity
- Specific backup schedule and retention policies for PostgreSQL/S3
- Integration with centralized secrets management for database credentials
