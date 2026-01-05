#!/bin/bash
set -e

Q_NUM="q17"
echo "⚠️ WARNING: This lab will deliberately break the Kubernetes API server."
echo "⚠️ After completing this lab, you MUST run 'bash ./Revert.bash' to restore the cluster."
echo

# Step 1: Create backup directory and backup manifests
BACKUP_DIR="$HOME/backup/ctrl-plane-comp"
mkdir -p "$BACKUP_DIR"

sudo cp /etc/kubernetes/manifests/kube-apiserver.yaml "$BACKUP_DIR/kube-apiserver.yaml.bak"
sudo cp /etc/kubernetes/manifests/kube-scheduler.yaml "$BACKUP_DIR/kube-scheduler.yaml.bak"

# Step 2: Simulate migration issue — change etcd client port to peer port 2380 in kube-apiserver
sudo sed -i 's/:2379/:2380/g' /etc/kubernetes/manifests/kube-apiserver.yaml

# Step 3: Misconfigure kube-scheduler — set excessive CPU requests
# We target the cpu request specifically in the requests: block
sudo sed -i '/requests:/!b;n;s/cpu: .*/cpu: 4/' /etc/kubernetes/manifests/kube-scheduler.yaml

# Step 4: Show kube-apiserver pod status/logs
echo "Checking kube-apiserver container..."
KAPISERVER_ID=$(sudo crictl ps -a | grep kube-apiserver | awk '{print $1}' | head -n 1)
if [ -n "$KAPISERVER_ID" ]; then
    sudo crictl logs "$KAPISERVER_ID" | tail -n 10 || true
else
    echo "kube-apiserver pod not found yet"
fi

# Step 5: Verify that kubectl fails as API server is down
kubectl get nodes || echo "As expected, API server is down due to misconfigured etcd client port."
