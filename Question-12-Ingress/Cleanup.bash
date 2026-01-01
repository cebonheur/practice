#!/bin/bash
# Cleanup.bash for Question 12

Q_NUM="q12"
Q_NS="${Q_NUM}-echo-sound"

echo "🔹 Cleaning up $Q_NUM..."
kubectl delete ns "$Q_NS" --ignore-not-found
echo "✅ Cleanup complete."
