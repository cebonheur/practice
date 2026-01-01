#!/bin/bash
set -e

Q_NUM="q6"
Q_NS="${Q_NUM}-cert-manager"

echo "🔹 Creating namespace: $Q_NS"
kubectl create ns "$Q_NS" --dry-run=client -o yaml | kubectl apply -f -

echo "🔹 Applying cert-manager CRDs (Shared Cluster Resource)..."
kubectl apply -f https://github.com/cert-manager/cert-manager/releases/download/v1.14.0/cert-manager.crds.yaml

echo "🔹 Creating minimal cert-manager Deployment in $Q_NS..."
cat <<EOF | kubectl apply -n "$Q_NS" -f -
apiVersion: apps/v1
kind: Deployment
metadata:
  name: cert-manager
spec:
  replicas: 1
  selector:
    matchLabels:
      app: cert-manager
  template:
    metadata:
      labels:
        app: cert-manager
    spec:
      containers:
      - name: cert-manager
        image: quay.io/jetstack/cert-manager-controller:v1.14.0
        args: ["--v=2"]
EOF

echo "✅ Cert-Manager setup complete in namespace: $Q_NS"
