# Kubernetes Monitoring Stack with Prometheus and Grafana

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

## Production Deployment

For production, use the production overlay which includes persistent storage:
    ```bash
    kubectl apply -k kustomize/overlays/prod

## Dashboards

Pre-configured dashboards include:
    Kubernetes Cluster Overview
    Node Metrics
    Pod Resources

## Screenshots

https://docs/screenshots/grafana-dashboard.png

## Production Considerations

For production deployments:
    1. Configure persistent storage for Prometheus and Grafana
    2. Set up proper ingress with authentication
    3. Configure long-term storage for Prometheus (e.g., Thanos or Cortex)
    4. Set up proper alerting rules in Alertmanager
    5. Configure Grafana to use an external database

## Cleanup

To remove all resources:
    ```bash
    kubectl delete -k kustomize/overlays/dev
    # or for production
    kubectl delete -k kustomize/overlays/prod
text

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
