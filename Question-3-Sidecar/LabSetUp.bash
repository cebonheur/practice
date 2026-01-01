#!/bin/bash
set -e

Q_NUM="q3"
Q_NS="${Q_NUM}-default"

echo "🚀 Setting up WordPress deployment for sidecar lab in namespace: $Q_NS"

kubectl create ns "$Q_NS" --dry-run=client -o yaml | kubectl apply -f -

# 1. Create WordPress deployment without log volume
cat <<EOF | kubectl apply -n "$Q_NS" -f -
apiVersion: apps/v1
kind: Deployment
metadata:
  name: wordpress
  labels:
    app: wordpress
spec:
  replicas: 1
  selector:
    matchLabels:
      app: wordpress
  template:
    metadata:
      labels:
        app: wordpress
    spec:
      containers:
      - name: wordpress
        image: wordpress:php8.2-apache
        command: ["/bin/sh", "-c", "while true; do echo 'WordPress is running...' >> /var/log/wordpress.log; sleep 5; done"]
        ports:
        - containerPort: 80
EOF

# 2. Create a service to expose the deployment
cat <<EOF | kubectl apply -n "$Q_NS" -f -
apiVersion: v1
kind: Service
metadata:
  name: wordpress
spec:
  selector:
    app: wordpress
  ports:
  - port: 80
    targetPort: 80
EOF

echo
echo "✅ Lab setup complete!"
echo
echo "WordPress deployment created in namespace: $Q_NS"
echo "You can now edit the deployment to add the sidecar container and shared volume."
