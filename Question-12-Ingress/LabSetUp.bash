#!/bin/bash
set -e

Q_NUM="q12"
Q_NS="${Q_NUM}-echo-sound"

echo "Creating namespace: $Q_NS"
kubectl create ns "$Q_NS" || true

echo "Deploying Echo Server in namespace: $Q_NS"
cat <<EOF | kubectl -n "$Q_NS" apply -f -
apiVersion: apps/v1
kind: Deployment
metadata:
  name: echo
spec:
  replicas: 1
  selector:
    matchLabels:
      app: echo
  template:
    metadata:
      labels:
        app: echo
    spec:
      containers:
      - name: echo
        image: gcr.io/google_containers/echoserver:1.10
        ports:
        - containerPort: 8080
EOF

echo "✅ Echo server deployment created successfully in $Q_NS!"
