#!/bin/bash
# Cleanup.bash for Question 7

Q_NUM="q7"
Q_NS="${Q_NUM}-priority"
Q_PC="${Q_NUM}-user-critical"

echo "🔹 Cleaning up $Q_NUM..."
kubectl delete ns "$Q_NS" --ignore-not-found
kubectl delete priorityclass "$Q_PC" --ignore-not-found
echo "✅ Cleanup complete."
