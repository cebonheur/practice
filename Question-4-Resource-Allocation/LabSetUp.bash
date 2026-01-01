#!/bin/bash
set -e

Q_NUM="q4"
Q_NS="${Q_NUM}-default"

echo "🚀 Setting up WordPress deployment in namespace: $Q_NS"

kubectl create ns "$Q_NS" --dry-run=client -o yaml | kubectl apply -f -

cat <<EOF | kubectl apply -n "$Q_NS" -f -
apiVersion: apps/v1
kind: Deployment
metadata:
  name: wordpress
spec:
  replicas: 3
  selector:
    matchLabels:
      app: wordpress
  template:
    metadata:
      labels:
        app: wordpress
    spec:
      initContainers:
      - name: init-setup
        image: busybox
        command: ["sh", "-c", "echo 'Preparing environment...' && sleep 5"]
      containers:
      - name: wordpress
        image: wordpress:6.2-apache
        ports:
        - containerPort: 80
EOF

echo "✅ Question 4 setup complete in namespace: $Q_NS"
