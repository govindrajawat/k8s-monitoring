#!/bin/bash

# Port forward Prometheus, Grafana and Alertmanager
kubectl port-forward -n monitoring svc/prometheus 9090:9090 &
kubectl port-forward -n monitoring svc/grafana 3000:3000 &
kubectl port-forward -n monitoring svc/alertmanager 9093:9093 &

echo "Prometheus: http://localhost:9090"
echo "Grafana: http://localhost:3000 (admin/admin)"
echo "Alertmanager: http://localhost:9093"

wait