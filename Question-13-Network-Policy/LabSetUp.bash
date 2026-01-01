#!/bin/bash
set -e

Q_NUM="q13"
Q_NS_FRONT="${Q_NUM}-frontend"
Q_NS_BACK="${Q_NUM}-backend"
Q_DIR="$HOME/questions/${Q_NUM}"

mkdir -p "$Q_DIR"

echo "🔹 Creating namespaces..."
kubectl create namespace "$Q_NS_FRONT" --dry-run=client -o yaml | kubectl apply -f -
kubectl create namespace "$Q_NS_BACK" --dry-run=client -o yaml | kubectl apply -f -

# Add labels to namespaces for NetworkPolicy selector
kubectl label namespace "$Q_NS_FRONT" name="$Q_NS_FRONT" --overwrite
kubectl label namespace "$Q_NS_BACK" name="$Q_NS_BACK" --overwrite

echo "🔹 Deploying backend app..."
kubectl apply -n "$Q_NS_BACK" -f - <<EOF
apiVersion: apps/v1
kind: Deployment
metadata:
  name: backend-deployment
spec:
  replicas: 1
  selector:
    matchLabels:
      app: backend
  template:
    metadata:
      labels:
        app: backend
    spec:
      containers:
      - name: backend
        image: nginx
        ports:
        - containerPort: 80
EOF

echo "🔹 Exposing backend as ClusterIP service..."
kubectl expose deployment backend-deployment -n "$Q_NS_BACK" --port=80 --target-port=80 --name=backend-service

echo "🔹 Deploying frontend app..."
kubectl apply -n "$Q_NS_FRONT" -f - <<EOF
apiVersion: apps/v1
kind: Deployment
metadata:
  name: frontend-deployment
spec:
  replicas: 1
  selector:
    matchLabels:
      app: frontend
  template:
    metadata:
      labels:
        app: frontend
    spec:
      containers:
      - name: frontend
        image: curlimages/curl
        command: ["sleep", "3600"]
EOF

echo "🔹 Creating NetworkPolicy files in $Q_DIR..."

cat <<EOF > "$Q_DIR/network-policy-1.yaml"
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: policy-x
  namespace: $Q_NS_BACK
spec:
  podSelector: {}
  ingress:
  - {}
  policyTypes:
  - Ingress
EOF

cat <<EOF > "$Q_DIR/network-policy-2.yaml"
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: policy-y
  namespace: $Q_NS_BACK
spec:
  podSelector:
    matchLabels:
      app: backend
  ingress:
  - from:
    - namespaceSelector:
        matchLabels:
          name: $Q_NS_FRONT
    - ipBlock:
        cidr: 172.16.0.0/16
    ports:
    - protocol: TCP
      port: 80
  policyTypes:
  - Ingress
EOF

cat <<EOF > "$Q_DIR/network-policy-3.yaml"
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: policy-z
  namespace: $Q_NS_BACK
spec:
  podSelector:
    matchLabels:
      app: backend
  ingress:
  - from:
    - namespaceSelector:
        matchLabels:
          name: $Q_NS_FRONT
    - podSelector:
        matchLabels:
          app: frontend
    ports:
    - protocol: TCP
      port: 80
  policyTypes:
  - Ingress
EOF

echo "✅ Lab setup complete. Three network policy files created in $Q_DIR."
