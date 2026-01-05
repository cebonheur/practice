#!/bin/bash
# Revert.bash for Q17 Etcd-Fix
# This script restores the kube-apiserver from backup.

BACKUP_DIR="$HOME/backup/ctrl-plane-comp"

if [ ! -f "$BACKUP_DIR/kube-apiserver.yaml.bak" ] || [ ! -f "$BACKUP_DIR/kube-scheduler.yaml.bak" ]; then
    echo "❌ Backup files not found in $BACKUP_DIR. Cannot revert automatically."
    exit 1
fi

echo "🔹 Restoring manifests from backup..."
sudo cp "$BACKUP_DIR/kube-apiserver.yaml.bak" /etc/kubernetes/manifests/kube-apiserver.yaml
sudo cp "$BACKUP_DIR/kube-scheduler.yaml.bak" /etc/kubernetes/manifests/kube-scheduler.yaml

echo "🔹 Waiting for API server to come back up..."
until kubectl get nodes &> /dev/null; do
    echo "   ... waiting for API server ..."
    sleep 5
done

echo "✅ API server is back up and running!"
