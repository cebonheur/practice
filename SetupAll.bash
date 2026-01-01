#!/bin/bash
# Master Lab Setup Script (Questions 1-16, excluding 8, 9, 17)
# This script applies the environment setup for all stable labs.
# Questions 8 (CNI), 9 (CRI), and 17 (Etcd-Fix) are EXCLUDED to maintain cluster stability.

set -e

BASE_DIR=$(pwd)
TIMESTAMP=$(date +%Y%m%d_%H%M%S)
LOG_FILE="$BASE_DIR/setup_all_$TIMESTAMP.log"

# Function to log messages with internal timestamps
log_msg() {
    echo "[$(date +'%Y-%m-%d %H:%M:%S')] $1" | tee -a "$LOG_FILE"
}

log_msg "🚀 Starting consolidated CKA lab setup (Excluding Q8, Q9, Q17)..."
log_msg "📂 Project Root: $BASE_DIR"
log_msg "---------------------------------------------------"

# Find and sort question folders numerically
# We explicitly exclude high-impact labs to prevent cluster instability
EXCLUDED_LABS=("Question-8-CNI-&-Network-Policy" "Question-9-Cri-Dockerd" "Question-17-Etcd-Fix")
EXCLUDE_ARGS=""
for lab in "${EXCLUDED_LABS[@]}"; do
    EXCLUDE_ARGS+="! -name $lab "
done

QUESTIONS=$(find . -maxdepth 1 -type d -name "Question-*" $EXCLUDE_ARGS | sort -V)

while read -r Q_FOLDER; do
    [ -z "$Q_FOLDER" ] && continue
    # Remove leading ./ from find results
    Q_NAME="${Q_FOLDER#./}"
    
    log_msg "🔹 Setting up $Q_NAME..."
    
    # Enter the folder and run LabSetUp.bash
    if [ -f "$Q_NAME/LabSetUp.bash" ]; then
        (cd "$Q_NAME" && bash LabSetUp.bash >> "$LOG_FILE" 2>&1)
        if [ $? -eq 0 ]; then
            log_msg "   ✅ $Q_NAME complete."
        else
            log_msg "   ❌ $Q_NAME failed! Check $LOG_FILE for details."
        fi
    else
        log_msg "   ⚠️ $Q_NAME/LabSetUp.bash not found. Skipping."
    fi
done <<< "$QUESTIONS"

log_msg "---------------------------------------------------"
log_msg "⚠️  HIGH-IMPACT LABS SKIPPED"
log_msg "The following labs were skipped to maintain cluster stability:"
for lab in "${EXCLUDED_LABS[@]}"; do
    log_msg "   - $lab"
done
log_msg ""
log_msg "💡 To run these individually:"
log_msg "   cd <folder> && bash LabSetUp.bash"
log_msg "---------------------------------------------------"
log_msg "✅ Consolidated setup finished!"
log_msg "📝 Logs available at: $LOG_FILE"
echo "💡 Note: You can now practice labs 1-16 (prefix: qX-) in this cluster."
