#!/bin/bash
# Cleanup.bash for Question 1

Q_NUM="q1"
Q_NS="${Q_NUM}-mariadb"
Q_PV="${Q_NUM}-mariadb-pv"

echo "🔹 Cleaning up $Q_NUM..."
kubectl delete ns "$Q_NS" --ignore-not-found
kubectl delete pv "$Q_PV" --ignore-not-found
rm -rf "$HOME/questions/$Q_NUM"

echo "✅ Cleanup complete."
