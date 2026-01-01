#!/bin/bash
set -e

Q_NUM="q16"
Q_NS="${Q_NUM}-relative"

# Step 1: Create namespace
kubectl create namespace "$Q_NS" || true

# Step 2: Create deployment
kubectl -n "$Q_NS" create deployment nodeport-deployment \
  --image=nginx --replicas=2

# Step 3: Expose deployment via NodePort
echo "Deployment 'nodeport-deployment' created in namespace '$Q_NS'."
echo "Task: expose it via NodePort using a Service."