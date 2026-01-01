#!/bin/bash
set -e

echo "🚀 Setting up Argo CD CRDs (Shared Cluster Resource)..."

sleep 2

# 1. Install Argo CD CRDs (official source)
# NOTE: These are cluster-wide and might be shared across other labs if they use ArgoCD.
kubectl apply -k https://github.com/argoproj/argo-cd/manifests/crds\?ref\=stable


echo "✅ Argo CD CRDs setup complete!"
echo
echo "Resources created:"
echo "  - Argo CD CRDs (Cluster-wide)"
