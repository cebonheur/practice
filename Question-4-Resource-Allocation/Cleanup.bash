#!/bin/bash
# Cleanup.bash for Question 4

Q_NUM="q4"
Q_NS="${Q_NUM}-default"

echo "🔹 Cleaning up $Q_NUM..."
kubectl delete ns "$Q_NS" --ignore-not-found
echo "✅ Cleanup complete."
