#!/bin/bash
# Cleanup.bash for Question 5

Q_NUM="q5"
Q_NS="${Q_NUM}-autoscale"

echo "🔹 Cleaning up $Q_NUM..."
kubectl delete ns "$Q_NS" --ignore-not-found
# Note: we don't delete metrics-server as it's shared.
echo "✅ Cleanup complete."
