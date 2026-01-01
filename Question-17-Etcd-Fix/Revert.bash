#!/bin/bash
# Revert.bash for Q17 Etcd-Fix
# This script restores the kube-apiserver from backup.

if [ ! -f /root/kube-apiserver.yaml.bak ]; then
    echo "❌ Backup file /root/kube-apiserver.yaml.bak not found. Cannot revert automatically."
    exit 1
fi

echo "🔹 Restoring kube-apiserver manifest from backup..."
sudo cp /root/kube-apiserver.yaml.bak /etc/kubernetes/manifests/kube-apiserver.yaml

echo "🔹 Waiting for API server to come back up..."
until kubectl get nodes &> /dev/null; do
    echo "   ... waiting for API server ..."
    sleep 5
done

echo "✅ API server is back up and running!"
