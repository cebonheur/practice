# CKA Practice (Simple Edition)

Straightforward CKA practice labs derived from the CKA-PREP playlist. Every question lives in its own folder with three bash files:

- `LabSetUp.bash` � copy/paste into Killercoda (or any Kubernetes cluster) to prep the environment.
- `Questions.bash` � the scenario text plus the YouTube link for the walkthrough.
- `SolutionNotes.bash` � a step-by-step solution when you need a hint.

## How to Use
1. Launch the CKA Killercoda playground or your own cluster.
2. Clone this repo inside the environment.
3. Pick a folder under `Question-*`.
4. Run `./scripts/run-question.sh Question-01` or cd ~/CKA-PREP-2025-v2
bash scripts/run-question.sh "Question-9 Network-Policy" to apply the setup and print the question text, or run `bash Question-01/LabSetUp.bash` manually.
5. Work through the task, then consult `SolutionNotes.bash` if you need help.

## Available Questions
| Question | Topic | Video |
|----------|-------|-------|
| Question-01 | Install Argo CD using Helm without CRDs | https://youtu.be/8GzJ-x9ffE0 |

More questions can be added by copying the template folder and dropping in the three bash files from the original collection.

## Project Evolution (Gemini Assisted)

### Phase 2: Environment Isolation Overhaul
- **Infrastructure Isolation**: All labs moved to isolated directories (`~/questions/qX/`) to prevent home directory clutter.
- **Namespace Prefixing**: Implemented `qX-` prefixes for all Kubernetes resources, allowing multiple labs to run concurrently in a single cluster.
- **Master Scripts**: Created `SetupAll.bash` and `CleanupAll.bash` for automated bulk management.
- **High-Impact Protection**: Isolated labs that could affect cluster stability (Q8 CNI, Q9 CRI, Q17 Etcd) from bulk automation.

### Phase 3: Robustness & Logging (Current)
- **Enhanced Safety**: Explicit exclusion logic and proactive warnings for high-impact labs in master scripts.
- **Professional Documentation**: Added detailed header comments and console feedback listing all omitted questions.
- **Advanced Logging**:
    - **Dynamic History**: Unique log filenames with timestamps (e.g., `setup_all_YYYYMMDD_HHMMSS.log`) to preserve execution history.
    - **Internal Traceability**: Every log line is prefixed with execution timestamps via a new `log_msg` system.

---

## Best Practice: Lab Cleanup and Restart.
For the most realistic CKA practice session, it is highly recommended to **re-initialize your environment** (e.g., spin up a new Killercoda instance or reset your VMs) between major laboratory sessions. While the `Cleanup.bash` scripts are useful for quick pivots, a full cluster reset is the only way to ensure 100% thoroughness, especially for cluster-scoped resources. In the words of the Mandalorian, "This is the way."
