# Terraform for DevOps & Data Engineering

> Terraform is not “cloud automation.”
> Terraform is infrastructure engineering.

Modern systems are too large to manage manually:

* VMs
* networks
* databases
* IAM
* Kubernetes clusters
* cloud storage
* monitoring
* data infrastructure

Terraform solves this using **Infrastructure as Code (IaC)**.

---

# 1. What is Terraform?

Terraform is an open-source **Infrastructure as Code (IaC)** tool developed by HashiCorp.

It allows engineers to:

* define infrastructure in code
* provision cloud resources automatically
* version infrastructure
* automate deployments
* maintain reproducibility

Terraform supports:

* AWS
* Azure
* GCP
* Kubernetes
* Databricks
* Snowflake
* Docker
* GitHub
* hundreds of providers

---

# 2. Why Terraform Exists

Before IaC:

```text id="z0f0m2"
Engineer clicks manually in cloud console
        ↓
Nobody remembers configuration
        ↓
Environment drift occurs
        ↓
Production breaks
```

Problems:

* inconsistent environments
* human error
* undocumented infrastructure
* impossible scaling
* poor reproducibility

Terraform fixes this by making infrastructure:

* declarative
* version-controlled
* reproducible
* automated

---

# 3. Why Terraform Matters in Data Engineering

Modern data platforms require infrastructure:

* data warehouses
* object storage
* Kubernetes clusters
* Airflow environments
* Spark clusters
* networking
* IAM roles
* monitoring systems

Terraform enables:

* automated infrastructure provisioning
* reproducible environments
* scalable deployments
* cloud cost management
* GitOps workflows

---

# 4. Infrastructure as Code (IaC)

IaC means infrastructure is defined using code.

Instead of:

* clicking in UI

You write:

```hcl id="lwb0bg"
resource "aws_s3_bucket" "data_lake" {
  bucket = "company-data-lake"
}
```

Benefits:

* version control
* automation
* reproducibility
* collaboration
* rollback capability

---

# 5. Terraform Architecture

```text id="3b5f6q"
Terraform Code
      ↓
Terraform CLI
      ↓
Provider APIs
      ↓
Cloud Infrastructure
```

---

# 6. Core Terraform Concepts

| Concept  | Meaning                  |
| -------- | ------------------------ |
| Provider | Cloud/service plugin     |
| Resource | Infrastructure component |
| State    | Infrastructure tracking  |
| Module   | Reusable Terraform code  |
| Variable | Dynamic inputs           |
| Output   | Exported values          |
| Plan     | Proposed changes         |
| Apply    | Execute changes          |

---

# 7. Installing Terraform

## Linux

```bash id="a4ezd8"
sudo apt update
sudo apt install terraform
```

Verify:

```bash id="9hm4qk"
terraform version
```

Official docs:

[Terraform Official Docs](https://developer.hashicorp.com/terraform/docs?utm_source=chatgpt.com)

---

# 8. Terraform Workflow

```text id="a9x0sj"
Write Configuration
        ↓
terraform init
        ↓
terraform plan
        ↓
terraform apply
        ↓
Infrastructure Created
```

---

# 9. Terraform Configuration Language

Terraform uses:

* HCL (HashiCorp Configuration Language)

Example:

```hcl id="dnaz8p"
resource "aws_instance" "web_server" {
  ami           = "ami-123456"
  instance_type = "t2.micro"
}
```

---

# 10. Providers

Providers connect Terraform to platforms.

Examples:

* AWS
* Azure
* Google Cloud
* Kubernetes
* Docker
* Snowflake

Example:

```hcl id="pljlwm"
provider "aws" {
  region = "ap-south-1"
}
```

---

# 11. Resources

Resources define infrastructure components.

Example:

```hcl id="9k1a8p"
resource "aws_s3_bucket" "data_bucket" {
  bucket = "etl-data-lake"
}
```

---

# 12. Terraform Init

Initializes project.

```bash id="2xos05"
terraform init
```

Downloads:

* providers
* plugins
* dependencies

---

# 13. Terraform Plan 🔥

Shows proposed changes.

```bash id="bjjwx5"
terraform plan
```

Critical concept:

* Terraform compares desired state vs actual infrastructure.

---

# 14. Terraform Apply

Creates/updates infrastructure.

```bash id="p68a8n"
terraform apply
```

Auto approve:

```bash id="42qzhz"
terraform apply -auto-approve
```

---

# 15. Terraform Destroy ⚠️

Deletes infrastructure.

```bash id="4o1v4j"
terraform destroy
```

Dangerous in production.

---

# 16. Terraform State

Terraform tracks infrastructure using state files.

File:

```text id="jlwm2f"
terraform.tfstate
```

State contains:

* resource mappings
* metadata
* infrastructure status

---

# 17. Why State Matters

Terraform must know:

* what exists
* what changed
* what should be updated

Without state:

* Terraform becomes blind.

---

# 18. Remote State 🔥

Never store production state locally.

Use remote backends:

* AWS S3
* Azure Blob Storage
* GCS
* Terraform Cloud

Example:

```hcl id="udx0hp"
terraform {
  backend "s3" {
    bucket = "terraform-state"
    key    = "prod/terraform.tfstate"
    region = "ap-south-1"
  }
}
```

---

# 19. Variables

Variables make configurations reusable.

Example:

```hcl id="i39g6e"
variable "region" {
  default = "ap-south-1"
}
```

Use:

```hcl id="20x8x3"
provider "aws" {
  region = var.region
}
```

---

# 20. Outputs

Export useful information.

Example:

```hcl id="r4umji"
output "bucket_name" {
  value = aws_s3_bucket.data_bucket.bucket
}
```

---

# 21. Terraform Modules 🔥

Modules = reusable Terraform components.

Example:

```text id="v5x4qk"
modules/
  ├── networking/
  ├── airflow/
  ├── spark/
  └── monitoring/
```

Use module:

```hcl id="kxxs5w"
module "networking" {
  source = "./modules/networking"
}
```

---

# 22. Dependency Graph

Terraform automatically builds resource dependencies.

Example:

```text id="k2d53m"
VPC
 ↓
Subnet
 ↓
EC2 Instance
```

---

# 23. Terraform Formatting

Format code:

```bash id="g8hm2o"
terraform fmt
```

Validate syntax:

```bash id="2sd9cq"
terraform validate
```

---

# 24. Terraform Lifecycle

```text id="2i5m3m"
Code
 ↓
Init
 ↓
Plan
 ↓
Apply
 ↓
Infrastructure
 ↓
Update/Destroy
```

---

# 25. Example: AWS S3 Bucket

```hcl id="7b54di"
provider "aws" {
  region = "ap-south-1"
}

resource "aws_s3_bucket" "data_lake" {
  bucket = "company-data-lake"
}
```

Apply:

```bash id="4grd4f"
terraform init
terraform plan
terraform apply
```

---

# 26. Example: EC2 Instance

```hcl id="u1n8vx"
resource "aws_instance" "server" {
  ami           = "ami-123456"
  instance_type = "t2.micro"
}
```

---

# 27. Example: Kubernetes Cluster

Terraform commonly provisions:

* EKS
* AKS
* GKE

Example:

```hcl id="s0x4cc"
resource "aws_eks_cluster" "main" {
  name = "data-platform"
}
```

---

# 28. Terraform + Docker

Provision Docker containers:

```hcl id="0n6i4o"
provider "docker" {}

resource "docker_container" "nginx" {
  image = "nginx"
  name  = "web-server"
}
```

---

# 29. Terraform + Kubernetes

Deploy infrastructure + workloads.

Example:

* provision EKS cluster
* deploy Airflow
* deploy monitoring stack

---

# 30. Terraform + Data Engineering

Real use cases:

| Infrastructure     | Usage                  |
| ------------------ | ---------------------- |
| S3/GCS             | Data lake              |
| Redshift/Snowflake | Warehousing            |
| EMR/Dataproc       | Spark clusters         |
| EKS/GKE            | Orchestration          |
| IAM                | Permissions            |
| VPC                | Networking             |
| Airflow Infra      | Workflow orchestration |
| Monitoring         | Grafana/Prometheus     |

---

# 31. Terraform Project Structure

```text id="2e8vdb"
terraform/
│
├── modules/
├── environments/
│   ├── dev/
│   ├── staging/
│   └── prod/
│
├── variables.tf
├── outputs.tf
├── main.tf
└── providers.tf
```

---

# 32. Environment Separation

Never mix environments.

Bad:

```text id="5vdvbx"
single infrastructure for everything
```

Good:

```text id="lv6t8z"
dev
staging
production
```

---

# 33. Terraform Workspaces

Used for multiple environments.

```bash id="5ikxhu"
terraform workspace new dev
```

List workspaces:

```bash id="7hnsct"
terraform workspace list
```

Switch:

```bash id="vfx8x0"
terraform workspace select prod
```

---

# 34. Terraform Best Practices ✅

## Use Remote State

Mandatory for teams.

---

## Modularize Infrastructure

Avoid giant monolithic configs.

---

## Never Hardcode Secrets

Use:

* secret managers
* environment variables

Bad:

```hcl id="k2gr9u"
password = "admin123"
```

---

## Use Version Constraints

```hcl id="30g4yw"
terraform {
  required_version = ">= 1.5.0"
}
```

---

## Keep Infrastructure DRY

Use:

* variables
* modules

---

# 35. Common Terraform Commands

## Initialization

```bash id="66vkj8"
terraform init
```

---

## Validation

```bash id="rj9v4x"
terraform validate
terraform fmt
```

---

## Planning

```bash id="o4x6u9"
terraform plan
```

---

## Apply

```bash id="ahpjzm"
terraform apply
```

---

## Destroy

```bash id="xjw8jz"
terraform destroy
```

---

# 36. Terraform + CI/CD

Typical workflow:

```text id="wjlwmw"
Git Push
    ↓
CI Pipeline
    ↓
terraform fmt
terraform validate
terraform plan
    ↓
Approval
    ↓
terraform apply
```

Tools:

* [GitHub Actions](https://github.com/features/actions?utm_source=chatgpt.com)
* [Terraform Cloud](https://developer.hashicorp.com/terraform/cloud-docs?utm_source=chatgpt.com)
* [Atlantis](https://www.runatlantis.io?utm_source=chatgpt.com)

---

# 37. Terraform vs Ansible

| Terraform                   | Ansible                  |
| --------------------------- | ------------------------ |
| Infrastructure provisioning | Configuration management |
| Declarative                 | Procedural               |
| Creates resources           | Configures resources     |
| Tracks state                | Agentless execution      |

Terraform:

* infrastructure

Ansible:

* server configuration

---

# 38. Terraform vs CloudFormation

| Terraform       | CloudFormation |
| --------------- | -------------- |
| Multi-cloud     | AWS only       |
| HCL             | JSON/YAML      |
| Wider ecosystem | AWS-native     |

---

# 39. Common Beginner Mistakes ❌

* storing state locally in teams
* committing secrets
* giant monolithic configs
* no modules
* skipping `terraform plan`
* manually changing cloud resources
* poor environment separation

---

# 40. Real Industry Expectations

A serious engineer should:

* understand IaC principles
* manage cloud infrastructure safely
* modularize infrastructure
* understand state management
* integrate Terraform into CI/CD
* debug infrastructure drift
* provision scalable systems

---

# 41. What Actually Matters for Data Engineering Interviews

Interviewers care about:

* infrastructure thinking
* automation mindset
* cloud provisioning basics
* state management understanding
* reproducibility

High-value knowledge:

* remote state
* modules
* IAM
* Kubernetes provisioning
* environment management

---

# 42. Real Industry Reality Check

Most students:

* memorize syntax
* deploy toy EC2 instances
* never understand state management

Industry problems are different:

* infrastructure drift
* broken deployments
* cloud cost explosions
* permission failures
* production instability

Terraform exists to solve operational scale problems.

---

# 43. Final Perspective

Terraform is not a “DevOps bonus skill.”

It is the operational language of cloud infrastructure.

Modern data engineering increasingly depends on:

* scalable infrastructure
* automation
* reproducibility
* GitOps workflows
* cloud-native systems

Without Infrastructure as Code, scaling engineering teams becomes chaos 🚀
