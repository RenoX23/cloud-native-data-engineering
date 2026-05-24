# git.md

# Git — Version Control for Modern Engineering

---

# What is Git?

Git is a **distributed version control system (VCS)** used to track changes in code, collaborate with teams, and maintain project history safely and efficiently.

Created by Linus Torvalds in 2005.

Git is now the industry standard for:

* Software Engineering
* DevOps
* Data Engineering
* MLOps
* Cloud Infrastructure
* Open Source Development

---

# Why Git Exists

Before Git:

* Teams overwrote each other’s code
* No reliable rollback system
* Collaboration was messy
* Production bugs were difficult to trace
* Deployment history was unclear

Git solved this by introducing:

* Version tracking
* Branching
* Safe collaboration
* Change history
* Rollbacks
* Distributed workflows

---

# Why Git Matters in Data Engineering

A weak Data Engineer treats Git like file backup.

A real Data Engineer treats Git as:

* Infrastructure history
* Pipeline versioning
* Deployment control
* Collaboration backbone
* Production safety mechanism

Git is heavily used for:

| Area                  | Usage                      |
| --------------------- | -------------------------- |
| ETL Pipelines         | Track transformations      |
| Airflow DAGs          | Version workflows          |
| dbt Models            | Manage SQL transformations |
| Terraform             | Infrastructure as Code     |
| CI/CD                 | Automated deployments      |
| DataOps               | Controlled releases        |
| Analytics Engineering | Collaboration              |

If you cannot use Git properly, you are not production-ready.

---

# Core Git Concepts

## Repository (Repo)

A project tracked by Git.

```bash
git init
```

---

## Commit

A snapshot of changes.

```bash
git commit -m "Added Kafka ingestion pipeline"
```

Think of commits as:

> Save points with history.

---

## Branch

An isolated line of development.

```bash
git checkout -b feature/data-validation
```

Used for:

* Features
* Bug fixes
* Experiments
* Parallel development

---

## Remote Repository

Cloud-hosted repository.

Examples:

* GitHub
* GitLab
* Bitbucket

---

# Git Architecture

```text
Working Directory
       ↓
Staging Area
       ↓
Local Repository
       ↓
Remote Repository
```

---

# Basic Git Workflow

```text
Modify Files
    ↓
git add
    ↓
git commit
    ↓
git push
```

This is the foundation of all modern engineering workflows.

---

# Essential Git Commands

# Initialize Repository

```bash
git init
```

---

# Clone Repository

```bash
git clone <repository-url>
```

---

# Check Status

```bash
git status
```

Shows:

* Modified files
* Untracked files
* Staged changes

---

# Stage Files

## Single File

```bash
git add file.py
```

## All Files

```bash
git add .
```

---

# Commit Changes

```bash
git commit -m "Added Airflow DAG for ingestion"
```

Good commit messages matter.

Bad:

```text
fixed stuff
```

Good:

```text
Added incremental ETL logic for customer pipeline
```

---

# Push Changes

```bash
git push origin main
```

Uploads local commits to remote repository.

---

# Pull Latest Changes

```bash
git pull origin main
```

Downloads and merges latest updates.

---

# Branching Strategy

# Create Branch

```bash
git branch feature-kafka
```

---

# Switch Branch

```bash
git checkout feature-kafka
```

---

# Create + Switch

```bash
git checkout -b feature-kafka
```

---

# Merge Branch

```bash
git checkout main
git merge feature-kafka
```

---

# Why Branching Matters

Without branching:

* Teams collide constantly
* Production becomes unstable
* Testing becomes dangerous

Branching enables:

* Safe development
* Isolation
* Team collaboration
* Controlled releases

---

# Merge vs Rebase

| Merge                 | Rebase           |
| --------------------- | ---------------- |
| Preserves history     | Rewrites history |
| Safer for teams       | Cleaner history  |
| Creates merge commits | Linear commits   |

---

# Git Stash

Temporarily saves uncommitted work.

```bash
git stash
git stash pop
```

Useful when switching tasks quickly.

---

# Git Reset

# Soft Reset

Keeps changes locally.

```bash
git reset --soft HEAD~1
```

---

# Hard Reset

Deletes changes permanently.

```bash
git reset --hard HEAD~1
```

Dangerous command.

Use carefully.

---

# .gitignore

Prevents unnecessary files from entering repository.

## Example

```text
.env
venv/
__pycache__/
node_modules/
*.log
```

Critical for:

* Security
* Clean repositories
* Preventing secrets leakage

---

# Git in Data Engineering

# Common Real Workflow

```text
Develop Pipeline
      ↓
Commit Changes
      ↓
Push to GitHub
      ↓
CI/CD Triggered
      ↓
Tests Run
      ↓
Deploy to Production
```

Git is deeply integrated with:

* Airflow
* dbt
* Spark
* Terraform
* Kubernetes
* Jenkins
* GitHub Actions

---

# GitOps

Git becomes the single source of truth.

Infrastructure and deployments are controlled through Git repositories.

Common tools:

* Argo CD
* Flux

Benefits:

* Auditing
* Rollbacks
* Automation
* Deployment consistency

---

# Git Best Practices

## Commit Frequently

Small commits are easier to debug.

---

## Write Meaningful Commit Messages

Your commit history should explain project evolution.

---

## Never Push Secrets

Never commit:

* API keys
* Passwords
* Tokens
* Credentials

Use:

* `.env`
* Secret managers
* Vault systems

---

## Use Feature Branches

Never develop directly on `main`.

---

## Pull Before Push

Avoid conflicts.

```bash
git pull origin main
```

---

# Common Git Mistakes

| Mistake                | Consequence          |
| ---------------------- | -------------------- |
| Pushing secrets        | Security breach      |
| Giant commits          | Difficult debugging  |
| Working on main branch | Unstable production  |
| Ignoring pull requests | Poor collaboration   |
| No .gitignore          | Repository pollution |

---

# Interview Questions

## What is Git?

Distributed version control system.

---

## Difference between Git and GitHub?

| Git                    | GitHub           |
| ---------------------- | ---------------- |
| Version control system | Hosting platform |
| Local tool             | Cloud platform   |

---

## What is HEAD?

Pointer to current commit.

---

## Difference between pull and fetch?

| Fetch             | Pull               |
| ----------------- | ------------------ |
| Downloads changes | Downloads + merges |

---

## What is merge conflict?

Occurs when Git cannot automatically combine changes.

---

# What Actually Matters for Data Engineering

Do not waste time memorizing obscure Git internals.

What matters:

✅ Clean branching
✅ Commit discipline
✅ Collaboration workflow
✅ CI/CD integration
✅ GitHub workflow
✅ Conflict resolution
✅ GitOps fundamentals
✅ Infrastructure versioning

That is what production engineering teams care about.

---

