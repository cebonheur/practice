● Now I have all the data from the live cluster. Let me compile the complete grading report.

● ---
  CKA Practice Lab Grading Report (Live Cluster)

  ---
  Question 1: MariaDB Persistent Volume

  - Task: PVC named mariadb with ReadWriteOnce, 250Mi: PASSED [0.33/0.33] - PVC exists, bound to q1-mariadb-pv
  - Task: Deployment uses the PVC: PASSED [0.33/0.33] - Volume mounted at /var/lib/mysql
  - Task: Deployment running and stable: PASSED [0.34/0.34] - Pod mariadb-6c7866db97-pf8km is Running

  Question Total: 1.0 / 1.0 ✅
  Overall Feedback: Excellent work!

  ---
  Question 2: ArgoCD Helm Template

  - Task: Helm repo argocd added: PASSED [0.25/0.25] - Repo exists pointing to argoproj.github.io
  - Task: Namespace q2-argocd created: PASSED [0.25/0.25] - Namespace is Active
  - Task: Helm template generated for chart 7.7.3: PASSED [0.25/0.25] - File exists with correct chart version
  - Task: CRDs not installed: PASSED [0.25/0.25] - Template generated (not applied), no CRD resources in output

  Question Total: 1.0 / 1.0 ✅
  Overall Feedback: Excellent work!

  ---
  Question 3: Sidecar Container

  - Task: Sidecar container named sidecar: PASSED [0.25/0.25] - Present in deployment
  - Task: Using busybox:stable image: PASSED [0.25/0.25] - Correct image
  - Task: Running tail -f /var/log/wordpress.log: PASSED [0.25/0.25] - Command correct
  - Task: Shared volume at /var/log: PASSED [0.25/0.25] - Volume mounts configured

  Question Total: 1.0 / 1.0 ✅
  Overall Feedback: Excellent! Correctly used Kubernetes 1.28+ native sidecar pattern.

  ---
  Question 4: Resource Allocation

  - Task: Deployment scaled to 3 replicas: PASSED [0.25/0.25] - 3 pods running
  - Task: Resources set on main container: PASSED [0.25/0.25] - cpu: 262m-280m, memory: 738Mi-750Mi
  - Task: Resources set on init container: PASSED [0.25/0.25] - Same values as main container
  - Task: Deployment stable: PASSED [0.25/0.25] - All 3 replicas Ready

  Question Total: 1.0 / 1.0 ✅
  Overall Feedback: Resources properly allocated to prevent node instability.

  ---
  Question 5: HPA (Horizontal Pod Autoscaler)

  - Task: HPA named apache-server: FAILED [0/0.25] - Named apache-deployment instead
  - Task: Targets apache-deployment: PASSED [0.25/0.25] - Correct target
  - Task: 50% CPU, min 1, max 4: PASSED [0.25/0.25] - Metrics correct
  - Task: Stabilization window 30s: FAILED [0/0.25] - Set to 300s instead of 30s

  Question Total: 0.5 / 1.0 ⚠️
  Overall Feedback: Two errors: HPA name should be apache-server, stabilization should be 30 not 300.

  ---
  Question 6: CRDs

  - Task: List cert-manager CRDs saved to ~/questions/q6/resources.yaml: PASSED [0.5/0.5] - File contains all 6 cert-manager CRDs
  - Task: Subject field documentation saved to ~/questions/q6/subject.yaml: PASSED [0.5/0.5] - Contains Certificate subject spec

  Question Total: 1.0 / 1.0 ✅
  Overall Feedback: Excellent work!

  ---
  Question 7: PriorityClass

  - Task: PriorityClass high-priority with value one less than q7-user-critical: PASSED [0.5/0.5] - Value is 999 (q7-user-critical is 1000)
  - Task: Deployment busybox-logger uses high-priority: PASSED [0.5/0.5] - priorityClassName set

  Question Total: 1.0 / 1.0 ✅
  Overall Feedback: Excellent work!

  ---
  Question 8: CNI & Network Policy

  - Task: CNI installed from manifest: PASSED [0.33/0.33] - Calico running in kube-system
  - Task: Pods can communicate: PASSED [0.33/0.33] - Calico provides pod networking
  - Task: Supports network policy: PASSED [0.34/0.34] - Calico supports NetworkPolicy

  Question Total: 1.0 / 1.0 ✅
  Overall Feedback: Calico correctly installed and operational.

  ---
  Question 9: Cri-Dockerd

  - Task: cri-docker service enabled and running: FAILED [0/0.4] - Service is inactive
  - Task: net.bridge.bridge-nf-call-iptables = 1: PASSED [0.15/0.15] - Correct
  - Task: net.ipv6.conf.all.forwarding = 1: FAILED [0/0.15] - Value is 0
  - Task: net.ipv4.ip_forward = 1: PASSED [0.15/0.15] - Correct
  - Task: net.netfilter.nf_conntrack_max = 131072: PASSED [0.15/0.15] - Correct

  Question Total: 0.45 / 1.0 ⚠️
  Overall Feedback: Service not running and IPv6 forwarding not enabled.

  ---
  Question 10: Taints & Tolerations

  - Task: Taint on k8s-master-10 (PERMISSION=granted:NoSchedule): PASSED [0.5/0.5] - Taint correctly applied
  - Task: Pod with toleration scheduled on k8s-master-10: PASSED [0.5/0.5] - Pod mypod running on k8s-master-10 with correct toleration

  Question Total: 1.0 / 1.0 ✅
  Overall Feedback: Excellent work!

  ---
  Question 11: Gateway API Migration

  - Task: Gateway web-gateway with hostname: PASSED [0.25/0.25] - Exists with gateway.web.k8s.local
  - Task: TLS configuration maintained: PASSED [0.25/0.25] - HTTPS listener on 443 with TLS termination
  - Task: HTTPRoute web-route created: PASSED [0.25/0.25] - Exists with correct hostname
  - Task: Routing rules maintained: PASSED [0.25/0.25] - Path prefix / to web-service:80

  Question Total: 1.0 / 1.0 ✅
  Overall Feedback: Excellent work!

  ---
  Question 12: Ingress

  - Task: Service echo-service (NodePort, port 8080): PASSED [0.5/0.5] - Service exists with correct config
  - Task: Ingress echo for example.org/echo: PARTIAL [0.25/0.5] - Ingress exists but has YAML structure error:
  # Current (incorrect - two separate rules):
  rules:
  - host: "example.org"
  - http:
      paths: ...

  # Should be (single rule):
  rules:
  - host: "example.org"
    http:
      paths: ...

  Question Total: 0.75 / 1.0 ⚠️
  Overall Feedback: Service is correct. Ingress has structural issue - host and http should be in same rule object.

  ---
  Question 13: Network Policy

  - Task: Deploy least permissive policy: PASSED [1.0/1.0] - policy-z deployed (restricts to namespace + pod selector, no external IPs)

  Question Total: 1.0 / 1.0 ✅
  Overall Feedback: Correct choice - policy-z is most restrictive among the options.

  ---
  Question 14: Storage Class

  - Task: StorageClass local-storage with correct provisioner: PASSED [0.25/0.25] - rancher.io/local-path
  - Task: VolumeBindingMode WaitForFirstConsumer: PASSED [0.25/0.25] - Correct
  - Task: Patched to make default: PASSED [0.25/0.25] - is-default-class: "true"
  - Task: Only default class: PASSED [0.25/0.25] - Only local-storage is default

  Question Total: 1.0 / 1.0 ✅
  Overall Feedback: Excellent work!

  ---
  Question 15: TLS Config

  - Task: ConfigMap only supports TLSv1.3: PASSED [0.5/0.5] - ssl_protocols TLSv1.3 only
  - Task: /etc/hosts entry for ckaquestion.k8s.local: PASSED [0.5/0.5] - Entry exists with service IP

  Question Total: 1.0 / 1.0 ✅
  Overall Feedback: Excellent work!

  ---
  Question 16: NodePort

  - Task: Deployment containerPort 80 with name=http: PASSED [0.33/0.33] - Port configured correctly
  - Task: Service nodeport-service with port 80, nodePort 30080: PASSED [0.33/0.33] - Service configured correctly
  - Task: Service type NodePort: PASSED [0.34/0.34] - Type is NodePort

  Question Total: 1.0 / 1.0 ✅
  Overall Feedback: Excellent work! (Note: Your local yaml was missing namespace, but the live cluster shows it's correctly deployed)

  ---
  Question 17: Etcd Fix

  - Task: kube-apiserver running: PASSED [0.5/0.5] - Running
  - Task: kube-scheduler running: PASSED [0.5/0.5] - Running with correct CPU

  Question Total: 1.0 / 1.0 ✅
  Overall Feedback: Cluster control plane is healthy.

  ---
  Final Tally

  | Question | Topic               | Score    | Status     |
  |----------|---------------------|----------|------------|
  | Q1       | MariaDB PV          | 1.0/1.0  | ✅ PASSED  |
  | Q2       | ArgoCD              | 1.0/1.0  | ✅ PASSED  |
  | Q3       | Sidecar             | 1.0/1.0  | ✅ PASSED  |
  | Q4       | Resource Allocation | 1.0/1.0  | ✅ PASSED  |
  | Q5       | HPA                 | 0.5/1.0  | ⚠️ PARTIAL |
  | Q6       | CRDs                | 1.0/1.0  | ✅ PASSED  |
  | Q7       | PriorityClass       | 1.0/1.0  | ✅ PASSED  |
  | Q8       | CNI                 | 1.0/1.0  | ✅ PASSED  |
  | Q9       | Cri-Dockerd         | 0.45/1.0 | ⚠️ PARTIAL |
  | Q10      | Taints              | 1.0/1.0  | ✅ PASSED  |
  | Q11      | Gateway API         | 1.0/1.0  | ✅ PASSED  |
  | Q12      | Ingress             | 0.75/1.0 | ⚠️ PARTIAL |
  | Q13      | Network Policy      | 1.0/1.0  | ✅ PASSED  |
  | Q14      | StorageClass        | 1.0/1.0  | ✅ PASSED  |
  | Q15      | TLS Config          | 1.0/1.0  | ✅ PASSED  |
  | Q16      | NodePort            | 1.0/1.0  | ✅ PASSED  |
  | Q17      | Etcd Fix            | 1.0/1.0  | ✅ PASSED  |

  ---
  FINAL SCORE: 15.7 / 17.0 (92.4%)

  Summary:
  - 14 questions PASSED
  - 3 questions PARTIAL (Q5, Q9, Q12)

  Issues to fix:
  1. Q5: Rename HPA to apache-server, change stabilization to 30
  2. Q9: Start cri-docker service, set net.ipv6.conf.all.forwarding=1
  3. Q12: Fix Ingress YAML structure (host and http must be in same rule)

