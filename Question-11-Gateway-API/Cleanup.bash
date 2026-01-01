#!/bin/bash
# Cleanup.bash for Question 11

Q_NUM="q11"
Q_NS="${Q_NUM}-default"
Q_GC="${Q_NUM}-nginx-class"

echo "🔹 Cleaning up $Q_NUM..."
kubectl delete ns "$Q_NS" --ignore-not-found
kubectl delete gatewayclass "$Q_GC" --ignore-not-found
echo "✅ Cleanup complete."
