#!/bin/bash
set -e

# Question specific variables
Q_NUM="q1"
Q_NS="${Q_NUM}-mariadb"
Q_PV="${Q_NUM}-mariadb-pv"
Q_DIR="$HOME/questions/${Q_NUM}"

mkdir -p "$Q_DIR"

echo "🔹 Creating namespace..."
kubectl create ns "$Q_NS" --dry-run=client -o yaml | kubectl apply -f -

echo "🔹 Creating PersistentVolume..."
kubectl apply -f - <<EOF
apiVersion: v1
kind: PersistentVolume
metadata:
  name: $Q_PV
  labels:
    app: mariadb
spec:
  capacity:
    storage: 250Mi
  accessModes:
    - ReadWriteOnce
  persistentVolumeReclaimPolicy: Retain
  storageClassName: standard
  hostPath:
    path: /mnt/data/mariadb
EOF

echo "🔹 Creating initial PVC..."
kubectl apply -f - <<EOF
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: mariadb
  namespace: $Q_NS
spec:
  accessModes:
    - ReadWriteOnce
  resources:
    requests:
      storage: 250Mi
EOF

echo "🔹 Creating initial MariaDB Deployment..."
cat <<EOF > "$Q_DIR/mariadb-deploy.yaml"
apiVersion: apps/v1
kind: Deployment
metadata:
  name: mariadb
  namespace: $Q_NS
spec:
  replicas: 1
  selector:
    matchLabels:
      app: mariadb
  template:
    metadata:
      labels:
        app: mariadb
    spec:
      containers:
      - name: mariadb
        image: mariadb:10.6
        env:
        - name: MYSQL_ROOT_PASSWORD
          value: rootpass
        volumeMounts:
        - name: mariadb-storage
          mountPath: /var/lib/mysql
      volumes:
      - name: mariadb-storage
        persistentVolumeClaim:
          claimName: mariadb
EOF

kubectl apply -f "$Q_DIR/mariadb-deploy.yaml"

echo "🔹 Waiting for MariaDB pod to start..."
kubectl wait --for=condition=Available deployment/mariadb -n "$Q_NS" --timeout=60s || true

echo "🔹 Simulating accidental deletion of Deployment and PVC..."
kubectl delete deployment mariadb -n "$Q_NS" --ignore-not-found
kubectl delete pvc mariadb -n "$Q_NS" --ignore-not-found

echo "🔹 Resetting PV for reuse (clearing any stale claimRef)..."
claim_ref=$(kubectl get pv "$Q_PV" -o jsonpath='{.spec.claimRef.name}' 2>/dev/null || true)
if [ -n "$claim_ref" ]; then
  kubectl patch pv "$Q_PV" --type=json -p '[{"op":"remove","path":"/spec/claimRef"}]'
fi

# Refresh the deployment manifest for practice: claimName intentionally left blank
cat <<EOF > "$Q_DIR/mariadb-deploy.yaml"
apiVersion: apps/v1
kind: Deployment
metadata:
  name: mariadb
  namespace: $Q_NS
spec:
  replicas: 1
  selector:
    matchLabels:
      app: mariadb
  template:
    metadata:
      labels:
        app: mariadb
    spec:
      containers:
      - name: mariadb
        image: mariadb:10.6
        env:
        - name: MYSQL_ROOT_PASSWORD
          value: rootpass
        volumeMounts:
        - name: mariadb-storage
          mountPath: /var/lib/mysql
      volumes:
      - name: mariadb-storage
        persistentVolumeClaim:
          claimName: ""
EOF

echo "✅ Lab setup complete!"
echo "   - PV retained and ready for reuse: $Q_PV"
echo "   - Namespace: $Q_NS"
echo "   - Task: recreate PVC and deployment reusing existing PV (fill claimName in $Q_DIR/mariadb-deploy.yaml)"
