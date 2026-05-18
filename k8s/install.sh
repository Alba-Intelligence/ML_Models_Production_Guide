#!/usr/bin/env bash
# Install MLFlow in Minikube

set -e

echo "🚀 Installing MLFlow in Minikube..."

# Start Minikube if not running
if ! minikube status &>/dev/null; then
	echo "Starting Minikube..."
	minikube start --driver=docker
fi

# Apply all manifests
echo "Applying Kubernetes manifests..."
kubectl apply -f namespace.yaml
kubectl apply -f postgres-deployment.yaml
kubectl apply -f floci-deployment.yaml
kubectl apply -f floci-init-job.yaml
kubectl apply -f mlflow-deployment.yaml

# Wait for services to be ready
echo "Waiting for services to be ready..."
kubectl wait --for=condition=ready pod -l app=mlflow-postgres -n mlflow --timeout=60s
kubectl wait --for=condition=ready pod -l app=mlflow-floci -n mlflow --timeout=60s
kubectl wait --for=condition=ready pod -l app=mlflow -n mlflow --timeout=60s

echo ""
echo "✅ MLFlow installed successfully!"
echo ""
echo "MLFlow UI: http://$(minikube ip):30000"
echo "Floci S3: http://$(minikube ip):30001"
echo ""
echo "Commands:"
echo "  kubectl get pods -n mlflow"
echo "  kubectl get svc -n mlflow"
echo "  minikube service mlflow-service -n mlflow"
