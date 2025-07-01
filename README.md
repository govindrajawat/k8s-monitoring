# Kubernetes Monitoring Stack with Prometheus and Grafana

> **⚠️ Security & Setup Warnings:**
> - This repository contains placeholder secrets and example credentials (e.g., Grafana admin password, Alertmanager SMTP/PagerDuty keys). **You must replace all placeholder values with secure, production-ready credentials before deploying to any real or public cluster.**
> - The Alertmanager configuration uses example SMTP and PagerDuty settings. Update these in `kustomize/base/alertmanager/alertmanager-configmap.yaml` for real alerting.
> - The Grafana admin credentials are set in `kustomize/base/grafana/grafana-auth-secret.yaml` as `admin:changeme`. **Change this before production use.**
> - The `scripts/backup-grafana.sh` script requires `jq` to be installed in the Grafana container. You may need to extend the Grafana image or use a sidecar for this functionality.

This project provides a complete monitoring solution for Kubernetes clusters using Prometheus, Grafana, and related components.

## Architecture

![Architecture Diagram](docs/architecture.md)

The monitoring stack consists of:
- **Prometheus**: Time-series database for metrics collection
- **Grafana**: Visualization platform for metrics
- **Alertmanager**: Handles alerts from Prometheus
- **Node Exporter**: Collects node-level metrics
- **Kube State Metrics**: Collects Kubernetes cluster state metrics

## Deployment

### Prerequisites
- Kubernetes cluster (Minikube, KIND, GKE, EKS, AKS)
- kubectl configured to access your cluster
- Kustomize (included with kubectl >= 1.14)

### Quick Start (Minikube)

1. Start Minikube:
   ```bash
   minikube start
2. Deploy the monitoring stack:
    ```bash
    kubectl apply -k kustomize/overlays/dev
3. Access the services:
    ```bash
    make port-forward

Then open:
    Grafana: http://localhost:3000 (admin/admin)
    Prometheus: http://localhost:9090
    Alertmanager: http://localhost:9093

> **Note:** The default Grafana login is `admin:changeme` (see `kustomize/base/grafana/grafana-auth-secret.yaml`). Change this secret for production.

## Production Deployment

For production, use the production overlay which includes persistent storage:
    ```bash
    kubectl apply -k kustomize/overlays/prod

## Accessing Services Externally

Sample Ingress manifests are provided for Grafana and Prometheus in the base manifests:
- `kustomize/base/grafana/grafana-ingress.yaml`
- `kustomize/base/prometheus/prometheus-ingress.yaml`

> **Security Warning:** Do NOT use these Ingress resources in production without proper authentication (e.g., OAuth2 proxy, ingress auth, etc.). They are for demonstration purposes only.

## Dashboards

Pre-configured dashboards include:
    - Kubernetes Cluster Overview
    - Node Metrics (see `node-metrics.json` in the dashboards configmap)
    - Pod Resources

## Screenshots

https://docs/screenshots/grafana-dashboard.png

## Production Considerations

For production deployments:
    1. Configure persistent storage for Prometheus and Grafana
    2. Set up proper ingress with authentication
    3. Configure long-term storage for Prometheus (e.g., Thanos or Cortex)
    4. Set up proper alerting rules in Alertmanager (update SMTP/PagerDuty in `kustomize/base/alertmanager/alertmanager-configmap.yaml`)
    5. Configure Grafana to use an external database
    6. **Change all placeholder secrets and credentials before deploying!**

## Cleanup

To remove all resources:
    ```bash
    kubectl delete -k kustomize/overlays/dev
    # or for production
    kubectl delete -k kustomize/overlays/prod

## Documentation

`docs/architecture.md`:
```markdown
# Architecture Overview

```mermaid
graph TD
    A[Prometheus] -->|Scrape Metrics| B(Node Exporter)
    A -->|Scrape Metrics| C(Kube State Metrics)
    A -->|Send Alerts| D(Alertmanager)
    E[Grafana] -->|Query Data| A
    E -->|Query Data| C
    B -->|Node Metrics| A
    C -->|Cluster State Metrics| A
    D -->|Send Notifications| F[Email/Slack/etc.]

## Components

1. Prometheus
    Primary metrics collection and storage
    Scrapes metrics from exporters and services
    Evaluates alerting rules

2. Grafana
    Visualization platform
    Pre-configured dashboards for Kubernetes monitoring
    Connects to Prometheus as data source

3. Alertmanager
    Handles alerts from Prometheus
    Deduplicates and routes alerts to receivers
    Supports silencing and inhibition

4. Node Exporter
    Exports hardware and OS metrics
    Runs as DaemonSet on each node
    Provides CPU, memory, disk, network metrics

5. Kube State Metrics
    Exposes Kubernetes cluster state metrics
    Tracks resources like pods, deployments, nodes
    Provides metrics about resource requests/limits

## Complete Deployment Instructions

1. Clone the repository:
   ```bash
   git clone https://github.com/your-repo/kubernetes-monitoring-stack.git
   cd kubernetes-monitoring-stack
2. Deploy the stack:
    For development:
        ```bash
        kubectl apply -k kustomize/overlays/dev
    For production:
        ```bash
        kubectl apply -k kustomize/overlays/prod
3. Verify all components are running:
    ```bash
    kubectl get pods -n monitoring
4. Access the services:
    ```bash
    make port-forward
