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


# This part below just ensure that all pods from this deployment land on the same node.
      affinity:
        podAffinity:
          requiredDuringSchedulingIgnoredDuringExecution:
          - labelSelector:
              matchLabels:
                app: wordpress    # matches the deployment's pod labels
            topologyKey: kubernetes.io/hostname

#      nodeName: k8s-master-10 #another way to ensure all pods from the deployment lands on the same node in line with intent of this question. But this requires changing the nodeName value to match the environment where you want to deploy. For now, I am using a more environment agnostic method i.e. podAffinity
EOF

echo "✅ Question 4 setup complete in namespace: $Q_NS"
