#!/bin/bash
set -e

Q_NUM="q5"
Q_NS="${Q_NUM}-autoscale"

echo "🔹 Creating namespace: $Q_NS"
kubectl create namespace "$Q_NS" --dry-run=client -o yaml | kubectl apply -f -

# echo "🔹 Deploying metrics-server (Shared Cluster Resource)..."
# kubectl apply -f https://github.com/kubernetes-sigs/metrics-server/releases/latest/download/components.yaml

# echo "🔹 Patching metrics-server to allow insecure TLS (Killercoda environment)..."
# kubectl patch deployment metrics-server -n kube-system \
#   --type='json' -p='[{"op": "add", "path": "/spec/template/spec/containers/0/args/-", "value": "--kubelet-insecure-tls"}]' || true

#echo "🔹 Waiting for metrics-server rollout..."
#kubectl rollout status deployment metrics-server -n kube-system

echo "🔹 Creating Apache deployment in $Q_NS..."
kubectl apply -n "$Q_NS" -f - <<EOF
apiVersion: apps/v1
kind: Deployment
metadata:
  name: apache-deployment
  namespace: $Q_NS
spec:
  replicas: 1
  selector:
    matchLabels:
      app: apache
  template:
    metadata:
      labels:
        app: apache
    spec:
      containers:
      - name: apache
        image: httpd
        ports:
        - containerPort: 80
        resources:
          requests:
            cpu: 100m
          limits:
            cpu: 200m
EOF

echo "🔹 Exposing Apache deployment internally..."
kubectl expose deployment apache-deployment -n "$Q_NS" --port=80 --target-port=80

echo "✅ HPA lab setup complete."
echo "   - Namespace: $Q_NS"
echo "   - Deployment: apache-deployment"
echo "   - Service: apache-deployment"
echo "You can now create your HPA resource."
