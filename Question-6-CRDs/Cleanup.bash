#!/bin/bash
# Cleanup.bash for Question 6

Q_NUM="q6"
Q_NS="${Q_NUM}-cert-manager"

echo "🔹 Cleaning up $Q_NUM..."
kubectl delete ns "$Q_NS" --ignore-not-found
# Note: we don't delete cert-manager CRDs as they are shared.
echo "✅ Cleanup complete."
