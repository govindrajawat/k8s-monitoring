#!/bin/bash

# Backup Grafana dashboards
NAMESPACE=monitoring

# Fetch admin password from secret if not set
if [ -z "$GF_SECURITY_ADMIN_PASSWORD" ]; then
  GF_SECURITY_ADMIN_PASSWORD=$(kubectl get secret grafana-auth -n $NAMESPACE -o jsonpath="{.data.admin-password}" | base64 --decode)
fi

if [ -z "$GF_SECURITY_ADMIN_PASSWORD" ]; then
  echo "Error: GF_SECURITY_ADMIN_PASSWORD is not set and could not be fetched from secret."
  exit 1
fi

GRAFANA_POD=$(kubectl get pods -n $NAMESPACE -l app=grafana -o jsonpath="{.items[0].metadata.name}")

# Check if jq is installed in the Grafana pod
kubectl exec -n $NAMESPACE $GRAFANA_POD -- which jq > /dev/null 2>&1
if [ $? -ne 0 ]; then
  echo "Warning: jq is not installed in the Grafana pod. Please install jq to use this script."
  exit 1
fi

# Create backup directory
BACKUP_DIR="grafana-backup-$(date +%Y%m%d-%H%M%S)"
mkdir -p "$BACKUP_DIR"

# Backup all dashboards
kubectl exec -n $NAMESPACE $GRAFANA_POD -- \
  curl -s http://admin:$GF_SECURITY_ADMIN_PASSWORD@localhost:3000/api/search | \
  jq -r '.[] | select(.type == "dash-db") | .uid' | \
  while read uid; do
    kubectl exec -n $NAMESPACE $GRAFANA_POD -- \
      curl -s http://admin:$GF_SECURITY_ADMIN_PASSWORD@localhost:3000/api/dashboards/uid/$uid > "$BACKUP_DIR/${uid}.json"
  done

echo "Backup completed in $BACKUP_DIR/"