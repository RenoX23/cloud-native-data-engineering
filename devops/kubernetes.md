# Kubernetes for DevOps & Data Engineering

> Docker solved containerization.
> Kubernetes solved container orchestration at scale.

Modern systems do not run:

* one container
* on one server
* manually

They run:

* hundreds of containers
* across clusters
* with auto-scaling
* self-healing
* rolling deployments
* fault tolerance

Kubernetes exists to manage this complexity.

---

# 1. What is Kubernetes?

Kubernetes (K8s) is an open-source **container orchestration platform** originally developed by Google.

It automates:

* deployment
* scaling
* networking
* recovery
* management

of containerized applications.

---

# 2. Why Kubernetes Exists

Docker alone becomes difficult at scale.

Problems with plain Docker:

* container crashes
* scaling manually
* networking complexity
* load balancing
* rolling updates
* failover management
* resource allocation

Kubernetes solves:

* orchestration
* automation
* resilience
* scalability

---

# 3. Why Kubernetes Matters in Data Engineering

Modern data systems are distributed.

Examples:

* Spark clusters
* Airflow
* Kafka
* Flink
* dbt services
* ML APIs
* monitoring systems

Kubernetes provides:

* scalable infrastructure
* fault tolerance
* distributed scheduling
* efficient resource utilization
* cloud-native deployments

---

# 4. Kubernetes Architecture

```text id="6q0jlwm"
                Control Plane
         ┌─────────────────────┐
         │ API Server          │
         │ Scheduler           │
         │ Controller Manager  │
         │ ETCD                │
         └─────────────────────┘
                    ↓
          Worker Nodes (Machines)
         ┌─────────────────────┐
         │ Kubelet             │
         │ Container Runtime   │
         │ Pods                │
         └─────────────────────┘
```

---

# 5. Core Kubernetes Concepts

| Concept    | Meaning                       |
| ---------- | ----------------------------- |
| Cluster    | Entire Kubernetes environment |
| Node       | Machine in cluster            |
| Pod        | Smallest deployable unit      |
| Deployment | Pod management                |
| Service    | Networking abstraction        |
| Namespace  | Logical isolation             |
| ConfigMap  | Configuration storage         |
| Secret     | Sensitive data                |
| Ingress    | External access               |
| Volume     | Persistent storage            |

---

# 6. Cluster

A cluster consists of:

* control plane
* worker nodes

```text id="ylgqf9"
Cluster
 ├── Master/Control Plane
 └── Worker Nodes
```

---

# 7. Control Plane

Brain of Kubernetes.

Components:

| Component          | Purpose                  |
| ------------------ | ------------------------ |
| API Server         | Main communication layer |
| Scheduler          | Assigns pods to nodes    |
| ETCD               | Cluster database         |
| Controller Manager | Maintains desired state  |

---

# 8. Worker Nodes

Nodes run workloads.

Components:

* kubelet
* container runtime
* kube-proxy
* pods

---

# 9. Pods 🔥

Smallest deployable unit.

A pod contains:

* one or more containers
* shared networking
* shared storage

Example:

```yaml id="mjlwm8"
apiVersion: v1
kind: Pod
metadata:
  name: nginx-pod

spec:
  containers:
    - name: nginx
      image: nginx
```

---

# 10. Why Pods Exist

Containers need:

* networking
* storage
* lifecycle management

Kubernetes manages containers through pods.

---

# 11. Deployments 🔥

Pods are temporary.

Deployments manage:

* scaling
* updates
* replicas
* recovery

Example:

```yaml id="h9aq1u"
apiVersion: apps/v1
kind: Deployment

metadata:
  name: web-app

spec:
  replicas: 3

  selector:
    matchLabels:
      app: web

  template:
    metadata:
      labels:
        app: web

    spec:
      containers:
        - name: nginx
          image: nginx
```

---

# 12. ReplicaSets

Ensure desired number of pods remain running.

Example:

```text id="31u73d"
Desired Pods = 3
Actual Pods = 2
↓
Kubernetes creates 1 more pod
```

Self-healing is core Kubernetes behavior.

---

# 13. Services 🌐

Pods are ephemeral.

Services provide stable networking.

Types:

* ClusterIP
* NodePort
* LoadBalancer

Example:

```yaml id="0bjlwm"
apiVersion: v1
kind: Service

metadata:
  name: web-service

spec:
  selector:
    app: web

  ports:
    - port: 80
      targetPort: 80
```

---

# 14. Namespaces

Logical isolation inside clusters.

Example:

```text id="3g31di"
default
dev
staging
production
monitoring
```

Create namespace:

```bash id="yn8k87"
kubectl create namespace dev
```

---

# 15. ConfigMaps

Store non-sensitive configuration.

Example:

```yaml id="3jlwm1"
apiVersion: v1
kind: ConfigMap

metadata:
  name: app-config

data:
  ENV: production
```

---

# 16. Secrets 🔐

Store sensitive data:

* passwords
* tokens
* API keys

Example:

```yaml id="0cjlwm"
apiVersion: v1
kind: Secret

metadata:
  name: db-secret

type: Opaque

data:
  password: YWRtaW4=
```

(Base64 encoded)

---

# 17. Volumes 📦

Pods are ephemeral.

Volumes provide persistence.

Used for:

* databases
* logs
* stateful systems

---

# 18. Persistent Volumes

Persistent storage abstraction.

```text id="txjlwm"
Pod
 ↓
PersistentVolumeClaim
 ↓
PersistentVolume
```

---

# 19. Ingress 🌍

Manages external HTTP/HTTPS access.

Example:

```yaml id="pvjlwm"
apiVersion: networking.k8s.io/v1
kind: Ingress
```

Used with:

* domains
* SSL
* routing

---

# 20. kubectl CLI

Main Kubernetes command-line tool.

Verify:

```bash id="gwjlwm"
kubectl version
```

---

# 21. Essential kubectl Commands

## View Pods

```bash id="pjlwm0"
kubectl get pods
```

---

## View Deployments

```bash id="jlwm2p"
kubectl get deployments
```

---

## View Services

```bash id="jlwm3p"
kubectl get services
```

---

## Describe Resource

```bash id="jlwm4p"
kubectl describe pod pod-name
```

---

## View Logs

```bash id="jlwm5p"
kubectl logs pod-name
```

---

## Execute Into Pod

```bash id="jlwm6p"
kubectl exec -it pod-name -- bash
```

---

# 22. Apply Configurations

Deploy resources:

```bash id="jlwm7p"
kubectl apply -f deployment.yaml
```

Delete:

```bash id="jlwm8p"
kubectl delete -f deployment.yaml
```

---

# 23. Scaling Deployments

Scale manually:

```bash id="jlwm9p"
kubectl scale deployment web-app --replicas=5
```

---

# 24. Rolling Updates 🔥

Kubernetes updates applications gradually.

Benefits:

* zero downtime
* safer deployments
* rollback capability

Update image:

```bash id="jlwmap"
kubectl set image deployment/web-app nginx=nginx:latest
```

---

# 25. Rollbacks

Rollback failed deployment:

```bash id="jlwmbp"
kubectl rollout undo deployment/web-app
```

---

# 26. Kubernetes Scheduling

Scheduler decides:

* where pods run
* based on resources and policies

Factors:

* CPU
* memory
* affinity
* taints/tolerations

---

# 27. Resource Management

Define limits:

```yaml id="jlwmcp"
resources:
  requests:
    memory: "256Mi"
    cpu: "250m"

  limits:
    memory: "512Mi"
    cpu: "500m"
```

Critical in production.

---

# 28. Health Checks

## Liveness Probe

Checks if container is alive.

## Readiness Probe

Checks if container can serve traffic.

Example:

```yaml id="j3jjlwm"
livenessProbe:
  httpGet:
    path: /
    port: 80
```

---

# 29. Kubernetes Networking

Every pod gets:

* unique IP
* internal communication capability

Kubernetes networking model:

* flat networking
* pod-to-pod communication

---

# 30. Helm 🔥

Helm = package manager for Kubernetes.

Instead of writing massive YAML manually.

Install chart:

```bash id="jlwmdp"
helm install airflow apache-airflow/airflow
```

---

# 31. Kubernetes + Docker

Relationship:

```text id="jlwmep"
Docker → Builds containers
Kubernetes → Orchestrates containers
```

Critical distinction.

---

# 32. Kubernetes + Terraform

Terraform provisions:

* EKS
* AKS
* GKE

Kubernetes runs workloads.

---

# 33. Kubernetes + Data Engineering

Real-world usage:

| System     | Usage                    |
| ---------- | ------------------------ |
| Airflow    | Workflow orchestration   |
| Spark      | Distributed compute      |
| Kafka      | Streaming                |
| Flink      | Real-time processing     |
| dbt        | Transformation workloads |
| ML APIs    | Model serving            |
| Monitoring | Grafana/Prometheus       |

---

# 34. Example Data Platform Architecture

```text id="jlwmfp"
Kubernetes Cluster
│
├── Airflow
├── Spark
├── Kafka
├── PostgreSQL
├── Redis
├── dbt
├── ML APIs
└── Monitoring Stack
```

---

# 35. Kubernetes Deployment Workflow

```text id="jlwmgp"
Docker Build
     ↓
Push Image
     ↓
Kubernetes Deployment
     ↓
Pods Created
     ↓
Traffic Routed
```

---

# 36. Kubernetes Best Practices ✅

## Use Namespaces

Separate environments.

---

## Define Resource Limits

Prevent noisy-neighbor problems.

---

## Use Health Checks

Mandatory in production.

---

## Avoid Latest Tags

Bad:

```yaml id="jlwmhp"
image: nginx:latest
```

Good:

```yaml id="jlwmip"
image: nginx:1.25
```

---

## Use Secrets Properly

Never hardcode credentials.

---

# 37. Common Beginner Mistakes ❌

* learning YAML without understanding architecture
* using latest image tags
* no resource limits
* ignoring namespaces
* poor logging setup
* no health checks
* deploying everything into default namespace

---

# 38. Kubernetes vs Docker

| Docker            | Kubernetes             |
| ----------------- | ---------------------- |
| Containerization  | Orchestration          |
| Single host focus | Cluster focus          |
| Packaging         | Scaling & management   |
| Runtime           | Distributed operations |

---

# 39. Managed Kubernetes Services

Cloud providers offer managed K8s.

Examples:

* [Amazon EKS](https://aws.amazon.com/eks/?utm_source=chatgpt.com)
* [Azure AKS](https://azure.microsoft.com/en-us/products/kubernetes-service/?utm_source=chatgpt.com)
* [Google GKE](https://cloud.google.com/kubernetes-engine?utm_source=chatgpt.com)

---

# 40. Kubernetes + CI/CD

Typical workflow:

```text id="jlwmjp"
Git Push
    ↓
CI Pipeline
    ↓
Docker Build
    ↓
Push Image
    ↓
Kubernetes Deployment
```

Tools:

* [Argo CD](https://argo-cd.readthedocs.io/en/stable/?utm_source=chatgpt.com)
* [Flux CD](https://fluxcd.io?utm_source=chatgpt.com)
* [Jenkins](https://www.jenkins.io?utm_source=chatgpt.com)

---

# 41. What Actually Matters for Data Engineering Interviews

Interviewers usually care about:

* architecture understanding
* pods/services/deployments
* scaling concepts
* container orchestration basics
* troubleshooting capability

High-value knowledge:

* Helm
* ingress
* monitoring
* autoscaling
* distributed systems concepts

---

# 42. Real Industry Expectations

A strong engineer should:

* deploy applications on Kubernetes
* debug pods
* understand scaling
* manage deployments
* configure networking
* monitor workloads
* work with Helm
* integrate CI/CD pipelines

---

# 43. Final Reality Check

Most students:

* memorize kubectl commands
* copy YAML blindly
* never understand orchestration

Industry reality:

* distributed systems fail constantly
* containers crash
* traffic spikes happen
* infrastructure scales dynamically

Kubernetes exists to operationalize distributed systems reliably.

That is why it dominates modern cloud-native engineering 🚀
