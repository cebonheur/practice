#!/bin/bash
# Master Lab Cleanup Script (Questions 1-16, excluding 8, 9, 17)
# This script tears down all stable lab environments.
# Questions 8 (CNI), 9 (CRI), and 17 (Etcd-Fix) are EXCLUDED from bulk cleanup.

set -e

BASE_DIR=$(pwd)
TIMESTAMP=$(date +%Y%m%d_%H%M%S)
LOG_FILE="$BASE_DIR/cleanup_all_$TIMESTAMP.log"

# Function to log messages with internal timestamps
log_msg() {
    echo "[$(date +'%Y-%m-%d %H:%M:%S')] $1" | tee -a "$LOG_FILE"
}

log_msg "🧹 Starting consolidated CKA lab cleanup (Excluding Q8, Q9, Q17)..."
log_msg "📂 Project Root: $BASE_DIR"
log_msg "---------------------------------------------------"

# Find and sort question folders numerically
# We explicitly exclude high-impact labs to prevent accidental cleanup of complex environments
EXCLUDED_LABS=("Question-8-CNI-&-Network-Policy" "Question-9-Cri-Dockerd" "Question-17-Etcd-Fix")
EXCLUDE_ARGS=""
for lab in "${EXCLUDED_LABS[@]}"; do
    EXCLUDE_ARGS+="! -name $lab "
done

QUESTIONS=$(find . -maxdepth 1 -type d -name "Question-*" $EXCLUDE_ARGS | sort -V)

while read -r Q_FOLDER; do
    [ -z "$Q_FOLDER" ] && continue
    Q_NAME="${Q_FOLDER#./}"
    if [ -f "$Q_NAME/Cleanup.bash" ]; then
        log_msg "🔹 Cleaning up $Q_NAME..."
        (cd "$Q_NAME" && bash Cleanup.bash >> "$LOG_FILE" 2>&1)
        log_msg "   ✅ $Q_NAME cleaned."
    fi
done <<< "$QUESTIONS"

log_msg "---------------------------------------------------"
log_msg "⚠️  HIGH-IMPACT LABS SKIPPED"
log_msg "The following labs were skipped and must be cleaned manually if needed:"
for lab in "${EXCLUDED_LABS[@]}"; do
    log_msg "   - $lab"
done
log_msg "---------------------------------------------------"
log_msg "✅ Consolidated cleanup finished!"
log_msg "📝 Logs available at: $LOG_FILE"
