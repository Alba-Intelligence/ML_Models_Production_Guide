---
updated: 2026-05-14
summary: Decision record for AWS Kubernetes contract specifying workloads, deployment states, and observability requirements for non-Lambda.ai services.
read_when:
  - You are configuring AWS Kubernetes infrastructure
  - You need to understand which services should be Kubernetes-managed
  - You are designing deployment state models and observability payloads
sources:
  - ../../specs/ml-deploy-reference-repo.allium
  - ../queries/spec-quality-elicitation-session-01.md
  - ../decisions/lambda-ai-slurm-contract.md
  - ../architecture/reference-architecture-skeleton.md
---

# Decision: AWS Kubernetes Contract (Non-Lambda Services)

**What this page is for**: Decision record specifying the contracted behavior for AWS Kubernetes deployment states, workload classifications, and observability requirements for services that are not managed by Lambda.ai.

**When to read**: When designing AWS Kubernetes infrastructure, implementing deployment controllers, or configuring observability for non-Lambda services.

**Upstream spec**: `specs/ml-deploy-reference-repo.allium` — `WorkloadScheduler.kubernetes`, InfrastructureInterrogationAspect requirements

---

## Decision

### Workload Classification: Kubernetes vs Non-Kubernetes

#### Mandatory Kubernetes-Managed Workloads

The following workloads MUST be deployed on AWS Kubernetes:

1. **Online Inference Services**
   - REST/gRPC model serving endpoints
   - Real-time prediction APIs
   - Health check and monitoring endpoints
   - Auto-scaling and rolling update patterns

2. **Batch Processing Orchestrators**
   - Airflow workers (if using Kubernetes-based Airflow)
   - Scheduled batch job controllers
   - Event-driven processing pipelines
   - Data processing workflows

3. **Observability and Monitoring Services**
   - Prometheus/Grafana stack
   - Evidently service monitoring
   - Log aggregation services (Fluentd/Logstash)
   - Metrics collection and alerting services

4. **Core Platform Services**
   - MLflow tracking server
   - Model registry services
   - Notebook serving interfaces
   - API gateways and reverse proxies

5. **Supporting Infrastructure Services**
   - Redis caches
   - Message queues (Kafka, RabbitMQ)
   - Database connection pooling services
   - Service mesh components

#### Explicitly Non-Kubernetes Workloads

The following workloads MUST NOT be deployed on Kubernetes:

1. **Lambda.ai Training Jobs**
   - Distributed training on Lambda.ai Slurm
   - Large-scale GPU training workloads
   - Training jobs with GPU-specific requirements

2. **Infrastructure Provisioning**
   - Terraform/OpenTofu state management
   - Infrastructure-as-code execution
   - Resource provisioning workflows

3. **Local Development Workloads**
   - Developer laptops and workstations
   - Local testing and validation
   - Single-node experiments

4. **Batch Processing Compute**
   - Heavy computation batch jobs (these go to Lambda.ai)
   - Multi-hour batch processing (handled by Lambda.ai Slurm)

### Deployment States and Lifecycle

#### Batch Flow States (for scheduled batch processing)

- **SUBMITTED**: Job received, queued for execution
- **SCHEDULED**: Resources allocated, preparing execution
- **RUNNING**: Actively executing
- **COMPLETED**: Successfully finished
- **FAILED**: Execution failed with non-retryable error
- **RETRYING**: Failed but eligible for retry
- **CANCELLED**: Explicitly cancelled by user/system
- **TIMED_OUT**: Exceeded time limits

#### Online Flow States (for real-time serving)

- **DEPLOYING**: Model being deployed to serving cluster
- **HEALTH_CHECK**: Service performing health checks
- **ACTIVE**: Ready to serve requests
- **DRAINING**: Gradually removing traffic
- **ROLLED_BACK**: Deployment reverted to previous version
- **FAILED**: Deployment failed

#### Kubernetes-Specific States

- **PENDING**: Pod created, container starting
- **RUNNING**: Pod is running and ready
- **SUCCEEDED**: Container(s) completed successfully
- **FAILED**: Container(s) failed
- **UNKNOWN**: State cannot be determined

### Minimum Observability Payload Requirements

#### Kubernetes Job/Pod Observability

Every Kubernetes-managed workload must provide the following observability data:

**Required Fields for All Workloads:**

- `pod_id`: Kubernetes pod identifier
- `namespace`: Kubernetes namespace
- `pod_name`: Kubernetes pod name
- `container_id`: Container identifier
- `image_digest`: Container image digest (immutable reference)
- `pod_status`: Current pod status (pending/running/succeeded/failed/unknown)
- `pod_phase`: Pod phase (pending/running/failed/succeeded)
- `node_name`: Node where pod is scheduled
- `restart_count`: Container restart count

**Resource Allocation Metrics:**

- `cpu_request_millicpu`: CPU request in millicores
- `cpu_limit_millicpu`: CPU limit in millicores
- `memory_request_bytes`: Memory request in bytes
- `memory_limit_bytes`: Memory limit in bytes

**Timing Information:**

- `created_timestamp`: Pod creation time (ISO 8601)
- `started_timestamp`: Pod start time (ISO 8601)
- `completed_timestamp`: Pod completion time (ISO 8601)
- `running_duration_seconds`: Total running time in seconds

**Optional Enhancement Fields:**

- `pod_labels`: Kubernetes labels for filtering/selection
- `pod_annotations`: Kubernetes annotations for metadata
- `node_labels`: Node labels for topology awareness
- `qos_class`: Quality of service class (burstable/guaranteed/besteffort)
- `pod_ip`: Pod IP address
- `host_ip`: Node IP address

#### AWS CloudWatch Integration

- **Metrics**: Container CPU/memory usage, pod status, restart counts
- **Logs**: Application logs, container logs, Kubernetes audit logs
- **Tags**: Environment, workload type, cost center, owner

#### MLflow Integration

- **Experiment tracking**: If workload is part of MLflow experiment
- **Model deployment tracking**: For online inference services
- **Resource metrics**: CPU, memory, latency, error rates

#### Cost Attribution

- **Resource tags**: AWS tags for cost attribution
- **Namespace labels**: Kubernetes namespace for cost allocation
- **Workload labels**: Workload type for cost categorization

### Implementation Guidance

#### Kubernetes Manifest Structure

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: mlflow-server
  namespace: mlflow
  labels:
    app: mlflow
    workload-type: core-platform
    cost-center: data-science
spec:
  replicas: 3
  selector:
    matchLabels:
      app: mlflow
  template:
    metadata:
      labels:
        app: mlflow
    spec:
      containers:
        - name: mlflow
          image: mlflow-go:latest
          imagePullPolicy: IfNotPresent
          resources:
            requests:
              cpu: "500m"
              memory: "1Gi"
            limits:
              cpu: "1000m"
              memory: "2Gi"
          env:
            - name: MLFLOW_BACKEND_STORE_URI
              valueFrom:
                secretKeyRef:
                  name: mlflow-db-credentials
                  key: uri
          livenessProbe:
            httpGet:
              path: /
              port: 5000
            initialDelaySeconds: 30
            periodSeconds: 10
          readinessProbe:
            httpGet:
              path: /
              port: 5000
            initialDelaySeconds: 5
            periodSeconds: 5
```

#### Pod Disruption Budgets

```yaml
apiVersion: policy/v1
kind: PodDisruptionBudget
metadata:
  name: mlflow-server-pdb
  namespace: mlflow
spec:
  minAvailable: 2
  selector:
    matchLabels:
      app: mlflow
```

#### Horizontal Pod Autoscaler

```yaml
apiVersion: autoscaling/v2
kind: HorizontalPodAutoscaler
metadata:
  name: mlflow-server-hpa
  namespace: mlflow
spec:
  scaleTargetRef:
    apiVersion: apps/v1
    kind: Deployment
    name: mlflow-server
  minReplicas: 3
  maxReplicas: 10
  metrics:
    - type: Resource
      resource:
        name: cpu
        target:
          type: Utilization
          averageUtilization: 70
    - type: Resource
      resource:
        name: memory
        target:
          type: Utilization
          averageUtilization: 80
```

#### Service and Ingress

```yaml
apiVersion: v1
kind: Service
metadata:
  name: mlflow-service
  namespace: mlflow
spec:
  selector:
    app: mlflow
  ports:
    - name: http
      port: 80
      targetPort: 5000
  type: ClusterIP

---
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: mlflow-ingress
  namespace: mlflow
  annotations:
    nginx.ingress.kubernetes.io/rewrite-target: /
    cert-manager.io/cluster-issuer: letsencrypt-prod
spec:
  tls:
    - hosts:
        - mlflow.example.com
      secretName: mlflow-tls
  rules:
    - host: mlflow.example.com
      http:
        paths:
          - path: /
            pathType: Prefix
            backend:
              service:
                name: mlflow-service
                port:
                  number: 80
```

#### Kubernetes Event Monitoring

All major Kubernetes events should be captured and forwarded to observability systems:

- Pod creation/deletion
- Container restarts
- Image pull failures
- Resource allocation events
- Service endpoint changes

### Acceptance Criteria

1. **Workload Classification**: All mandatory Kubernetes workloads are properly identified and documented
2. **State Tracking**: Both batch and online flows have appropriate state management
3. **Observability**: All Kubernetes workloads emit the required observability payload
4. **Integration**: Kubernetes events and metrics are properly integrated with monitoring systems
5. **Cost Attribution**: All workloads have proper cost tagging and attribution
6. **Documentation**: Deployment manifests and observability configuration are documented
7. **Testing**: Kubernetes deployment workflows are validated in both local emulation and cloud environments

### Related Decisions

- [Lambda.ai Slurm Contract](../decisions/lambda-ai-slurm-contract.md) - Distributed training infrastructure
- [MLflow PostgreSQL+S3 Contract](../decisions/mlflow-postgres-s3-contract.md) - MLflow storage contract
- [Project Scope and Constraints](../decisions/project-scope-and-constraints.md) - Overall architectural direction
- [Infrastructure MCP Server Inventory](../decisions/infrastructure-mcp-server-inventory.md) - Infrastructure interrogation requirements

### Open Items

- Specific Kubernetes distribution choice (EKS, EKS Anywhere, self-managed)
- Container registry strategy (ECR, private registry, pull-through cache)
- Ingress controller selection (NGINX, Traefik, ALB Ingress Controller)
- Service mesh requirements (Istio, Linkerd, none)
- Storage class configuration (EBS, EFS, FSx)
- Network policies and security group design
- Specific monitoring tools and alerting thresholds

---

## Rationale

### Why Kubernetes for Online Inference?

- **Scale**: Horizontal scaling for variable request loads
- **Health Management**: Built-in health checks and rolling updates
- **Observability**: Rich metrics and logging integration
- **Network**: Service discovery, load balancing, and ingress
- **Security**: Network policies, RBAC, and service mesh capabilities

### Why Not Kubernetes for Training Jobs?

- **GPU Requirements**: Lambda.ai provides specialized GPU infrastructure
- **Ephemeral Workloads**: Training jobs are typically short-lived, batch-oriented
- **Cost Optimization**: Lambda.ai's spot instances and batch scheduling are more cost-effective
- **Specialized Hardware**: Access to specific GPU types and interconnects

### Why Batch Processing on Kubernetes?

- **Orchestration**: Complex multi-step workflows benefit from Kubernetes scheduling
- **Resilience**: Restart failed tasks without losing entire jobs
- **Monitoring**: Rich observability for batch job execution
- **Integration**: Seamless integration with MLflow and other platform services

---

## Implementation Notes

### Local Emulation Considerations

- Use K3s for local Kubernetes emulation
- Configure resource limits and requests for local development
- Implement local storage class for persistent volumes
- Set up local ingress controller for development access

### Cloud Deployment Considerations

- Use EKS for managed Kubernetes service
- Configure node groups with appropriate instance types
- Implement auto-scaling policies for cost efficiency
- Set up VPC with private subnets for security

### Monitoring Integration

- Prometheus for metrics collection
- Grafana for visualization and alerting
- CloudWatch Logs for AWS integration
- Evidently for model monitoring (if applicable)
