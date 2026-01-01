#!/bin/bash
set -e

Q_NUM="q7"
Q_NS="${Q_NUM}-priority"
Q_PC="${Q_NUM}-user-critical"

echo "Creating namespace: $Q_NS"
kubectl create namespace "$Q_NS" --dry-run=client -o yaml | kubectl apply -f -

echo "Creating user-defined PriorityClass: $Q_PC"
cat <<EOF | kubectl apply -f -
apiVersion: scheduling.k8s.io/v1
kind: PriorityClass
metadata:
  name: $Q_PC
value: 1000
globalDefault: false
description: "Highest user-defined priority class for $Q_NUM"
EOF

echo "Creating deployment: busybox-logger in '$Q_NS' namespace"
cat <<EOF | kubectl apply -n "$Q_NS" -f -
apiVersion: apps/v1
kind: Deployment
metadata:
  name: busybox-logger
  namespace: $Q_NS
spec:
  replicas: 1
  selector:
    matchLabels:
      app: busybox-logger
  template:
    metadata:
      labels:
        app: busybox-logger
    spec:
      containers:
      - name: busybox
        image: busybox
        command: ["sh", "-c", "while true; do echo 'logging...'; sleep 5; done"]
EOF

echo "✅ Lab setup complete!"
echo "   - Namespace: $Q_NS"
echo "   - PriorityClass: $Q_PC"
