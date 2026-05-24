# Docker for DevOps & Data Engineering

> Docker solved one of the biggest problems in software engineering:
>
> “It works on my machine.”

Docker standardizes environments using containers, making applications portable, reproducible, scalable, and deployment-ready.

In modern data engineering, Docker is foundational infrastructure.

---

# 1. What is Docker?

Docker is a **containerization platform** that packages:

* application code
* runtime
* dependencies
* libraries
* configurations

into isolated units called **containers**.

A container runs consistently across:

* laptops 💻
* servers 🖥️
* cloud ☁️
* Kubernetes clusters ⚙️

---

# 2. Why Docker Exists

Before Docker:

```text id="f6m0ai"
Developer Machine
    ≠
Testing Server
    ≠
Production Server
```

Result:

* dependency conflicts
* version mismatches
* broken deployments
* environment inconsistency

Docker fixes this through:

* isolated environments
* immutable deployments
* reproducibility
* portability

---

# 3. Why Docker Matters in Data Engineering

Modern data platforms are distributed systems.

A data engineer works with:

* Spark
* Airflow
* Kafka
* dbt
* PostgreSQL
* Redis
* APIs
* ML services

Managing all locally without containers becomes chaos.

Docker allows:

* local reproducible environments
* isolated dependencies
* microservice deployment
* scalable orchestration
* CI/CD consistency

---

# 4. Core Docker Architecture

```text id="o9zd8h"
Docker Client
      ↓
Docker Daemon
      ↓
Images → Containers
```

---

# 5. Core Concepts

| Concept       | Meaning                     |
| ------------- | --------------------------- |
| Image         | Blueprint/template          |
| Container     | Running instance of image   |
| Dockerfile    | Instructions to build image |
| Volume        | Persistent storage          |
| Network       | Communication layer         |
| Registry      | Image repository            |
| Docker Engine | Runtime system              |

---

# 6. Containers vs Virtual Machines

| Containers          | Virtual Machines    |
| ------------------- | ------------------- |
| Lightweight         | Heavy               |
| Share host kernel   | Full OS             |
| Faster startup      | Slower              |
| Less resource usage | More resource usage |
| Portable            | Less portable       |

---

# 7. Installing Docker

## Linux

```bash id="kzh29x"
sudo apt update
sudo apt install docker.io
```

Start Docker:

```bash id="lz1yyx"
sudo systemctl start docker
sudo systemctl enable docker
```

---

## Verify Installation

```bash id="c9h6u2"
docker --version
```

Test:

```bash id="d8on10"
docker run hello-world
```

---

# 8. Docker Workflow

```text id="0d88i8"
Write Dockerfile
       ↓
Build Image
       ↓
Run Container
       ↓
Push to Registry
       ↓
Deploy Anywhere
```

---

# 9. Docker Images

An image is a read-only template.

Example:

* Ubuntu image
* Python image
* PostgreSQL image

View images:

```bash id="5g9x5m"
docker images
```

Pull image:

```bash id="v4e3xq"
docker pull python:3.11
```

---

# 10. Docker Containers

Containers are running instances of images.

Run container:

```bash id="4dx0m2"
docker run ubuntu
```

Run interactively:

```bash id="5ry7r4"
docker run -it ubuntu bash
```

List running containers:

```bash id="itdj6d"
docker ps
```

List all containers:

```bash id="wzh7v8"
docker ps -a
```

Stop container:

```bash id="1e6sv7"
docker stop <container-id>
```

Remove container:

```bash id="3n0kzq"
docker rm <container-id>
```

---

# 11. Understanding Dockerfile 🔥

Dockerfile defines how images are built.

Example:

```dockerfile id="b6xjlwm"
FROM python:3.11

WORKDIR /app

COPY requirements.txt .

RUN pip install -r requirements.txt

COPY . .

CMD ["python", "app.py"]
```

---

# 12. Important Dockerfile Instructions

| Instruction | Purpose               |
| ----------- | --------------------- |
| FROM        | Base image            |
| WORKDIR     | Working directory     |
| COPY        | Copy files            |
| RUN         | Execute commands      |
| CMD         | Default command       |
| ENTRYPOINT  | Main executable       |
| ENV         | Environment variables |
| EXPOSE      | Expose ports          |

---

# 13. Building Docker Images

```bash id="i9ew6x"
docker build -t myapp .
```

Tag explanation:

```text id="eqqbh0"
myapp:latest
```

Format:

```text id="gv6g58"
image-name:tag
```

---

# 14. Running Containers

Basic:

```bash id="x16ksf"
docker run myapp
```

Detached mode:

```bash id="8v7w9m"
docker run -d myapp
```

Port mapping:

```bash id="nzk7xv"
docker run -p 8080:80 myapp
```

Named container:

```bash id="4d7u83"
docker run --name airflow airflow-image
```

---

# 15. Docker Volumes 📦

Containers are ephemeral.

Volumes provide persistent storage.

Create volume:

```bash id="fd7jqt"
docker volume create postgres-data
```

Use volume:

```bash id="g88m0t"
docker run -v postgres-data:/var/lib/postgresql/data postgres
```

---

# 16. Bind Mounts

Mount local directory:

```bash id="b0x7xu"
docker run -v $(pwd):/app myapp
```

Useful for:

* local development
* live code updates

---

# 17. Docker Networking 🌐

List networks:

```bash id="pyhy6k"
docker network ls
```

Create network:

```bash id="es1w7f"
docker network create data-network
```

Run containers on same network:

```bash id="28es0v"
docker run --network data-network postgres
```

Used heavily in:

* Airflow
* Kafka
* Spark clusters
* Microservices

---

# 18. Docker Logs

View logs:

```bash id="azlq9e"
docker logs <container-id>
```

Follow logs:

```bash id="yy0p38"
docker logs -f <container-id>
```

---

# 19. Execute Commands Inside Containers

```bash id="5cf4hk"
docker exec -it <container-id> bash
```

---

# 20. Docker Compose 🔥

Managing multiple containers manually is painful.

Docker Compose defines multi-container applications.

Example:

```yaml id="qst1ps"
version: '3'

services:
  postgres:
    image: postgres
    environment:
      POSTGRES_USER: admin
      POSTGRES_PASSWORD: password

  airflow:
    image: apache/airflow
    ports:
      - "8080:8080"
```

---

# 21. Docker Compose Commands

Start services:

```bash id="l0nqig"
docker compose up
```

Detached:

```bash id="t9pp90"
docker compose up -d
```

Stop:

```bash id="t9v72d"
docker compose down
```

Rebuild:

```bash id="3okjgc"
docker compose up --build
```

---

# 22. Docker Registries

Registries store Docker images.

Examples:

* [Docker Hub](https://hub.docker.com?utm_source=chatgpt.com)
* [Amazon ECR](https://aws.amazon.com/ecr/?utm_source=chatgpt.com)
* [Google Artifact Registry](https://cloud.google.com/artifact-registry?utm_source=chatgpt.com)

---

# 23. Pushing Images

Login:

```bash id="ofax1n"
docker login
```

Tag image:

```bash id="ps57wu"
docker tag myapp username/myapp:v1
```

Push image:

```bash id="s9y9r6"
docker push username/myapp:v1
```

---

# 24. Docker in Data Engineering

## Typical Stack

```text id="nzw2ec"
Docker Compose
    ↓
PostgreSQL
Kafka
Spark
Airflow
dbt
Redis
MinIO
```

---

# 25. Example: Airflow Setup

```yaml id="dnd3d0"
services:
  postgres:
    image: postgres:15

  airflow:
    image: apache/airflow:2.8
    depends_on:
      - postgres
```

---

# 26. Example: Spark Container

Run Spark:

```bash id="3zmq9x"
docker run -it bitnami/spark
```

---

# 27. Example: PostgreSQL Container

```bash id="lqmx7z"
docker run --name postgres \
-e POSTGRES_PASSWORD=password \
-p 5432:5432 \
-d postgres
```

---

# 28. Docker Best Practices ✅

## Use Small Base Images

Good:

```dockerfile id="5n54m6"
FROM python:3.11-slim
```

Bad:

```dockerfile id="n3rqkg"
FROM ubuntu
```

---

## Use .dockerignore

Example:

```text id="d70xgj"
__pycache__
.git
.env
node_modules
```

---

## Avoid Hardcoding Secrets

Bad:

```dockerfile id="9mquc4"
ENV PASSWORD=admin123
```

Use:

* environment variables
* secret managers

---

## Keep Containers Stateless

Persist data using:

* volumes
* databases
* object storage

---

# 29. Docker Resource Cleanup

Remove stopped containers:

```bash id="p36f9q"
docker container prune
```

Remove unused images:

```bash id="8os1w4"
docker image prune
```

Clean everything:

```bash id="ubk1i7"
docker system prune -a
```

---

# 30. Docker Security ⚠️

Key concerns:

* vulnerable base images
* exposed ports
* leaked secrets
* running as root

Best practices:

* minimal images
* image scanning
* non-root users
* updated dependencies

---

# 31. Docker + CI/CD

Typical pipeline:

```text id="j4ex0n"
Git Push
    ↓
CI Pipeline
    ↓
Run Tests
    ↓
Build Docker Image
    ↓
Push to Registry
    ↓
Deploy to Kubernetes
```

Tools:

* [GitHub Actions](https://github.com/features/actions?utm_source=chatgpt.com)
* [Jenkins](https://www.jenkins.io?utm_source=chatgpt.com)
* [Argo CD](https://argo-cd.readthedocs.io/en/stable/?utm_source=chatgpt.com)

---

# 32. Docker + Kubernetes

Docker creates containers.

Kubernetes orchestrates them.

```text id="jfx90r"
Docker → Packaging
Kubernetes → Scaling & Management
```

This distinction is critical.

---

# 33. Real Industry Usage

Docker is used for:

* Airflow deployments
* dbt environments
* Spark jobs
* ML inference APIs
* Streaming systems
* CI/CD pipelines
* Microservices
* Testing environments

---

# 34. Common Beginner Mistakes ❌

## Bad Practices

* gigantic images
* committing secrets
* no volume management
* containerizing everything blindly
* ignoring networking
* no health checks
* running everything as root

---

# 35. Essential Docker Commands Cheat Sheet

## Images

```bash id="qup8ik"
docker images
docker pull nginx
docker build -t myapp .
docker rmi image-id
```

---

## Containers

```bash id="g6ekq7"
docker run myapp
docker ps
docker stop container-id
docker rm container-id
docker logs container-id
docker exec -it container-id bash
```

---

## Compose

```bash id="l1qyr5"
docker compose up
docker compose down
docker compose ps
```

---

## Cleanup

```bash id="kgt1i6"
docker system prune -a
```

---

# 36. What Actually Matters for Data Engineering Interviews

Most interviewers do NOT care about obscure Docker internals.

They care whether you can:

* containerize applications
* build reproducible environments
* run services together
* debug container failures
* use Compose
* integrate Docker into pipelines

---

# 37. Real Industry Expectations

A serious data engineer should be able to:

* containerize Airflow/dbt apps
* run PostgreSQL locally
* orchestrate multi-service environments
* debug networking issues
* optimize Docker images
* integrate with CI/CD
* deploy containerized workloads

---

# 38. Final Reality Check

Most students:

* know `docker run`
* copy Dockerfiles blindly
* fail when services interact

Industry expects:

* operational understanding
* networking knowledge
* debugging capability
* deployment awareness
* reproducible engineering practices

Docker is no longer “DevOps tooling.”

It is baseline infrastructure literacy for modern engineering 🚀
