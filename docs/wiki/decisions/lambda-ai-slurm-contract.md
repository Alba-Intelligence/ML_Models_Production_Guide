---
updated: 2026-05-14
summary: Decision record for Lambda.ai Slurm contracts covering failure modes, retry policies, and required metadata flowback.
read_when:
  - You are implementing or reviewing Lambda.ai Slurm integration
  - You need the contracted behavior for Slurm workload orchestration
sources:
  - ../../specs/ml-deploy-reference-repo.allium
  - ../topologies/distributed-training-on-lambda-ai.md
  - ../queries/spec-quality-elicitation-session-01.md
  - ../architecture/reference-architecture-skeleton.md
---

# Decision: Lambda.ai Slurm Contract

**What this page is for**: Decision record specifying the contracted behavior for Lambda.ai Slurm workload orchestration, including failure modes, retry policies, and required metadata flowback.

**When to read**: When implementing or reviewing Lambda.ai Slurm integration, execution backends, or MLflow tracking for remote training workloads.

**Upstream spec**: `specs/ml-deploy-reference-repo.allium` — various rules around infrastructure interrogation and execution backends

---

## Decision

### Slurm Failure Modes to Represent Explicitly

The following Slurm failure modes must be represented explicitly in the spec and tracked in MLflow:

1. **PENDING timeout** - Job exceeded maximum pending time before allocation
2. **NODE_FAIL** - Compute node failed during job execution
3. **PREEMPTED** - Job was preempted by higher priority workload
4. **CANCELLED** - Job was cancelled by user or system
5. **FAILED** - Job failed due to application error or script exit code != 0
6. **TIMEOUT** - Job exceeded maximum runtime limit

### Required Retry/Escalation Policy per Failure Mode

| Failure Mode    | Retry Policy                                          | Escalation Policy                        | Max Retries                     |
| --------------- | ----------------------------------------------------- | ---------------------------------------- | ------------------------------- |
| PENDING timeout | Exponential backoff (5min → 15min → 30min → 1h)       | Alert on 3rd consecutive timeout         | 3                               |
| NODE_FAIL       | Immediate retry on different node pool                | Alert on 2nd consecutive node fail       | 5 (across different node types) |
| PREEMPTED       | Retry with lower priority or wait for capacity        | Notify on preemption, no automatic retry | N/A (manual retry)              |
| CANCELLED       | No automatic retry (user/system initiated)            | Log cancellation reason                  | 0                               |
| FAILED          | Retry with increased diagnostics/logging              | Alert on 2nd consecutive failure         | 2                               |
| TIMEOUT         | Retry with 25% increased time limit (max 2x original) | Alert on timeout occurrence              | 1                               |

### Required Slurm Metadata Flowback to MLflow/Web UI

The following Slurm metadata must always flow back into MLflow runs and be visible in Web UI:

1. **job_id** - Slurm job identifier
2. **partition** - Slurm partition/queue used
3. **node_list** - List of allocated compute nodes
4. **exit_code** - Job exit code from Slurm
5. **state** - Final job state (COMPLETED, FAILED, CANCELLED, etc.)
6. **submit_time** - Job submission timestamp
7. **start_time** - Job start timestamp
8. **end_time** - Job completion timestamp
9. **alloc_cpus** - Total allocated CPU cores
10. **alloc_mem** - Total allocated memory (MB)
11. **alloc_gres** - Generic resources allocated (GPUs, etc.)
12. **timelimit** - Requested time limit
13. **elapsed** - Actual elapsed time
14. **ncpus** - Number of CPUs per task
15. **nnodes** - Number of nodes allocated

### MLflow Integration Requirements

All Slurm metadata must be stored as:

- **MLflow run tags** for categorical/identifying data (job_id, partition, node_list, state, exit_code)
- **MLflow metrics** for numeric data (elapsed time, CPU/memory usage, GPU utilization where available)
- **MLflow parameters** for job configuration (requested resources, time limits, etc.)

### Web UI Contract Requirements

The Web UI must display:

- Current Slurm job status in real-time when available
- Historical job metadata for completed runs
- Failure mode classification and retry count
- Resource utilization metrics (CPU, memory, GPU) when available
- Links to Slurm job logs and detailed diagnostics

### Acceptance Criteria

1. **Failure mode tracking**: All listed Slurm failure modes are correctly identified and tagged in MLflow
2. **Retry policy enforcement**: System follows the specified retry/escalation policies automatically
3. **Metadata completeness**: All required Slurm metadata fields are present in MLflow runs and Web UI
4. **Observability**: Web UI shows accurate, real-time Slurm job status and historical metadata
5. **Alerting**: System generates appropriate alerts per the escalation policies

### Implementation Guidance

- Use `scontrol show job <job_id>` to query detailed job information
- Parse `sacct` output for historical job data and accounting information
- Handle Slurm job state transitions via polling or event callbacks where available
- Store metadata immediately upon job state change to ensure visibility even for failed jobs
- Normalize node list format for consistent storage and querying
- Map Slurm exit codes to meaningful failure categories where possible

---

## Related Decisions

- [Project scope and constraints](../decisions/project-scope-and-constraints.md) - Lambda.ai as distributed compute platform
- [Infrastructure MCP server inventory](../decisions/infrastructure-mcp-server-inventory.md) - Lambda.ai/Slurm runtime state interrogation
- [Distributed training on Lambda.ai topology](../topologies/distributed-training-on-lambda-ai.md) - Reference topology
- [MLflow storage backends](../decisions/mlflow-storage-backends.md) - Tracking backend requirements

### Open Items

- Exact implementation of Slurm job submission client (to be addressed in execution_backends.py)
- Specific alerting channels and integrations for failure notifications
- Detailed mapping of Slurm metrics to MLflow metrics for GPU utilization tracking
