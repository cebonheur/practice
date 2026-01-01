#!/bin/bash
# Cleanup.bash for Question 13

Q_NUM="q13"
Q_NS_FRONT="${Q_NUM}-frontend"
Q_NS_BACK="${Q_NUM}-backend"

echo "🔹 Cleaning up $Q_NUM..."
kubectl delete ns "$Q_NS_FRONT" --ignore-not-found
kubectl delete ns "$Q_NS_BACK" --ignore-not-found
rm -rf "$HOME/questions/$Q_NUM"
echo "✅ Cleanup complete."
