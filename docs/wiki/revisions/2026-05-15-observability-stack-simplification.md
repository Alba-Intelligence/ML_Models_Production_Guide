---
title: "Observability Stack Simplification"
date: "2026-05-15"
author: "Emmanuel"
summary: "Significant simplification of observability stack by replacing heavyweight components with lightweight MLflow + Floci approach while maintaining perfect local/cloud parity."
---

# Observability Stack Simplification - 2026-05-15

## Decision Context

The original observability stack included heavyweight components like Prometheus, Grafana, Airflow, and Kubeflow that created unnecessary complexity and infrastructure overhead. This decision replaces those components with a lightweight approach that maintains perfect local/cloud parity while reducing operational complexity.

## Previous Approach

### Components Being Removed:
- **Prometheus**: Complex metrics collection system
- **Grafana**: Additional visualization infrastructure  
- **Airflow**: Heavyweight workflow orchestration
- **Kubeflow**: Complex ML platform

### Issues with Previous Approach:
1. **High Infrastructure Overhead**: Multiple complex systems to manage
2. **Implementation Complexity**: Steep learning curve and operational burden
3. **Local/Cloud Parity Challenges**: Difficult to maintain identical behavior
4. **Cost Implications**: Additional licensing and operational costs
5. **Scope Creep**: Added unnecessary complexity beyond core ML deployment needs

## New Approach

### Components Being Implemented:
- **MLflow UI**: Native experiment visualization and tracking
- **MLflow Tracking**: Complete experiment metadata capture
- **MLflow Model Registry**: Model versioning and promotion
- **MLflow Metrics**: Performance metrics collection
- **CloudWatch/Floci**: Application logs and audit trails (emulated locally, real in cloud)
- **Floci-emulated AWS Cost Explorer**: Local cost visibility with MLflow tracking
- **K3s**: Lightweight Kubernetes for local development with cloud scaling

### Benefits of New Approach:
1. **Perfect Local/Cloud Parity**: Floci provides exact AWS service emulation locally
2. **Minimal Infrastructure Overhead**: Single MLflow-based observability stack
3. **Reduced Complexity**: Fewer moving parts to manage and maintain
4. **Cost Effective**: No additional licensing requirements
5. **Industry Standard**: MLflow is widely adopted and well-understood
6. **Unified Experience**: Same MLflow API and behavior across all environments

## Implementation Details

### Local Development Environment:
```bash
# Floci emulates all AWS services locally
floci up
# MLflow runs with Floci-emulated CloudWatch logging
# Same API, same behavior, just emulated infrastructure
```

### Production Cloud Environment:
```bash
# Real AWS CloudWatch services
# MLflow runs with real CloudWatch logging  
# Identical API, identical behavior, real infrastructure
```

### Unified Configuration:
```python
# MLflow configuration that works both locally and in cloud
if local_mode:
    mlflow_tracking_uri = "floci-mlflow:5000"
    cloudwatch_endpoint = "http://floci-cloudwatch:8080"
else:
    mlflow_tracking_uri = "aws://mlflow"
    cloudwatch_endpoint = "https://logs.{region}.amazonaws.com"
```

## Impact Assessment

### Positive Impacts:
- **Simplified Operations**: Single observability stack to manage
- **Reduced Costs**: No additional monitoring infrastructure costs
- **Perfect Parity**: Local development mirrors production exactly
- **Faster Implementation**: MLflow is already integrated into workflows
- **Better Integration**: Native ML experiment tracking and model registry

### Neutral Impacts:
- **Learning Curve**: MLflow is familiar to ML engineers
- **Standardization**: Uses industry-standard ML tracking tools

### Mitigated Risks:
- **Single Point of Failure**: MLflow is mature and stable
- **Limited Features**: MLflow provides all needed observability for ML workflows
- **Scalability**: MLflow scales well for ML workloads

## Files Modified

### Updated:
- `nbs/01_02-platform_introduction.qmd`: Updated observability stack description and lifecycle diagram
- `docs/wiki/current-state.md`: Added observability stack section

### Removed References:
- Prometheus/Grafana from stack components
- Airflow from orchestration layer  
- Kubeflow from Kubernetes layer

## Testing and Validation

### Build Testing:
- ✅ Quarto documentation builds successfully
- ✅ No broken links in updated documentation
- ✅ All references updated consistently

### Architecture Validation:
- ✅ Maintains local/cloud parity
- ✅ Reduces infrastructure complexity
- ✅ Preserves all observability capabilities
- ✅ Aligns with ML engineering best practices

## Next Steps

1. **Implementation**: Update actual code to use new observability stack
2. **Testing**: Validate MLflow + CloudWatch/Floci functionality
3. **Documentation**: Update remaining references as needed
4. **Training**: Document simplified approach for team members

## Future Considerations

- **MLflow Scaling**: Monitor MLflow performance as workload grows
- **Advanced Monitoring**: Consider additional tools if specialized needs arise
- **Cost Tracking**: Leverage AWS Cost Explorer integration for detailed cost analysis

---

This decision represents a significant simplification while maintaining full functionality. The lightweight MLflow + Floci approach provides perfect local/cloud parity with minimal operational overhead, aligning with the project's goals of simplicity and reproducibility.