#!/bin/bash
# Cleanup.bash for Question 15

Q_NUM="q15"
Q_NS="${Q_NUM}-nginx-static"

echo "🔹 Cleaning up $Q_NUM..."
kubectl delete ns "$Q_NS" --ignore-not-found
echo "✅ Cleanup complete."
