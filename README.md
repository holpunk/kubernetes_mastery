# Kubernetes Mastery

This project is a boilerplate for developing and deploying a Python Flask application on Kubernetes using Docker and Helm.

## Project Structure

- `application/`: Python Flask source code and dependencies.
- `dockerfiles/`: Dockerfile for containerizing the application.
- `infrastructure/helm_charts/nginx/`: Helm chart for Kubernetes deployment.

## Getting Started

### 1. Build the Docker Image

From the root project directory:

```bash
docker build -t python-app:latest -f dockerfiles/python.Dockerfile .
```

### 2. Deploy with Helm

Ensure you have a Kubernetes cluster running (e.g., Minikube or Docker Desktop K8s) and `kubectl` / `helm` configured.

```bash
helm install my-app infrastructure/helm_charts/nginx
```

### 3. Verify Deployment

```bash
kubectl get pods
kubectl get services
```

## Application Endpoints

- `GET /`: Returns a welcome message and hostname.
- `GET /health`: Health check endpoint.
