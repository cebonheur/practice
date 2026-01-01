#!/bin/bash
# Cleanup.bash for Question 16

Q_NUM="q16"
Q_NS="${Q_NUM}-relative"

echo "🔹 Cleaning up $Q_NUM..."
kubectl delete ns "$Q_NS" --ignore-not-found
echo "✅ Cleanup complete."
