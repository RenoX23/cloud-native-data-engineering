# Git for DevOps & Data Engineering

> Git is not just a version control tool.
> In modern engineering, Git is the operational backbone of software delivery, infrastructure management, analytics engineering, ML experimentation, and collaborative development.

---

# 1. What is Git?

Git is a **distributed version control system (DVCS)** created by Linus Torvalds in 2005.

It tracks:

* Source code
* Configuration files
* Infrastructure definitions
* SQL transformations
* Pipelines
* Documentation
* ML experiments

Git enables:

* Collaboration 👥
* History tracking 🕒
* Rollbacks ⏪
* Branching 🌳
* CI/CD automation ⚙️
* Safe experimentation 🧪

---

# 2. Why Git Matters in Data Engineering

A weak Git workflow = broken pipelines, overwritten SQL, production failures.

Data engineering teams use Git for:

| Area                  | Usage                      |
| --------------------- | -------------------------- |
| ETL Pipelines         | Versioning Airflow DAGs    |
| Analytics Engineering | dbt models + SQL           |
| Infrastructure        | Terraform IaC              |
| Data Quality          | Great Expectations configs |
| Streaming             | Kafka configs              |
| CI/CD                 | Automated deployments      |
| Collaboration         | PR reviews + approvals     |
| Experimentation       | Safe branching             |

---

# 3. Core Git Architecture

## Working Directory

Files currently being edited.

## Staging Area (Index)

Intermediate area before commit.

## Local Repository

Local Git history stored in `.git`.

## Remote Repository

Central repo hosted on:

* [GitHub](https://github.com?utm_source=chatgpt.com)
* [GitLab](https://gitlab.com?utm_source=chatgpt.com)
* [Bitbucket](https://bitbucket.org?utm_source=chatgpt.com)

---

# 4. Git Lifecycle

```text
Working Directory
       ↓
git add
       ↓
Staging Area
       ↓
git commit
       ↓
Local Repository
       ↓
git push
       ↓
Remote Repository
```

---

# 5. Installing Git

## Linux

```bash
sudo apt update
sudo apt install git
```

## Mac

```bash
brew install git
```

## Windows

Download:
[Git Official Website](https://git-scm.com/downloads?utm_source=chatgpt.com)

---

# 6. Initial Git Configuration

```bash
git config --global user.name "Renold"
git config --global user.email "you@example.com"
```

Check config:

```bash
git config --list
```

---

# 7. Creating a Repository

## Initialize Local Repo

```bash
git init
```

## Clone Existing Repo

```bash
git clone <repo-url>
```

Example:

```bash
git clone https://github.com/user/project.git
```

---

# 8. Git File States

| State     | Meaning               |
| --------- | --------------------- |
| Untracked | Git not tracking file |
| Modified  | File changed          |
| Staged    | Ready for commit      |
| Committed | Saved in history      |

Check status:

```bash
git status
```

---

# 9. Basic Git Workflow

## Add File

```bash
git add file.txt
```

Add everything:

```bash
git add .
```

---

## Commit Changes

```bash
git commit -m "Added ETL validation logic"
```

---

## Push to Remote

```bash
git push origin main
```

---

## Pull Latest Changes

```bash
git pull origin main
```

---

# 10. Understanding Commits

A commit is a snapshot of the project.

Good commit messages:

```text
feat: add kafka ingestion pipeline
fix: resolve dbt incremental bug
refactor: optimize airflow DAG structure
docs: update terraform setup guide
```

Bad:

```text
update
changes
finalfinal2
```

---

# 11. Branching 🔥

Branches isolate work safely.

## Create Branch

```bash
git branch feature/data-pipeline
```

## Switch Branch

```bash
git checkout feature/data-pipeline
```

Modern method:

```bash
git switch feature/data-pipeline
```

---

## Create + Switch

```bash
git checkout -b feature/data-pipeline
```

or

```bash
git switch -c feature/data-pipeline
```

---

## List Branches

```bash
git branch
```

---

# 12. Merge Branches

```bash
git checkout main
git merge feature/data-pipeline
```

---

# 13. Merge Conflicts ⚠️

Occurs when two branches modify same lines.

Conflict markers:

```text
<<<<<<< HEAD
current code
=======
incoming code
>>>>>>> feature-branch
```

Fix manually → then:

```bash
git add .
git commit
```

---

# 14. Git Rebase

Rewrites history for cleaner commits.

```bash
git rebase main
```

Interactive rebase:

```bash
git rebase -i HEAD~5
```

Used to:

* squash commits
* edit messages
* clean history

⚠️ Avoid rebasing shared branches.

---

# 15. Git Reset

## Soft Reset

Keeps changes staged.

```bash
git reset --soft HEAD~1
```

## Mixed Reset

Unstages changes.

```bash
git reset HEAD~1
```

## Hard Reset ⚠️

Deletes changes completely.

```bash
git reset --hard HEAD~1
```

---

# 16. Git Restore

Restore file:

```bash
git restore file.txt
```

Restore staged file:

```bash
git restore --staged file.txt
```

---

# 17. Git Stash

Temporarily save work.

```bash
git stash
```

View stash:

```bash
git stash list
```

Restore:

```bash
git stash pop
```

---

# 18. Viewing History

## Commit Log

```bash
git log
```

Compact:

```bash
git log --oneline
```

Graph View:

```bash
git log --oneline --graph --all
```

---

# 19. Git Diff

View changes:

```bash
git diff
```

Staged changes:

```bash
git diff --staged
```

---

# 20. Remote Repositories

## Add Remote

```bash
git remote add origin <repo-url>
```

## View Remote

```bash
git remote -v
```

---

# 21. SSH Authentication 🔐

Generate SSH Key:

```bash
ssh-keygen -t ed25519 -C "you@example.com"
```

Start SSH agent:

```bash
eval "$(ssh-agent -s)"
```

Add key:

```bash
ssh-add ~/.ssh/id_ed25519
```

Copy public key:

```bash
cat ~/.ssh/id_ed25519.pub
```

Add to GitHub SSH settings.

Test:

```bash
ssh -T git@github.com
```

---

# 22. .gitignore

Prevents unnecessary files from being tracked.

Example:

```gitignore
__pycache__/
.env
venv/
*.log
*.csv
*.parquet
node_modules/
.idea/
```

---

# 23. Git Tags

Used for releases.

Create tag:

```bash
git tag v1.0
```

Push tags:

```bash
git push origin --tags
```

---

# 24. Pull Requests (PRs)

Core collaboration mechanism.

Workflow:

```text
Create Branch
    ↓
Push Branch
    ↓
Open PR
    ↓
Code Review
    ↓
CI Validation
    ↓
Merge
```

PRs should contain:

* clear description
* screenshots/logs if needed
* testing evidence
* rollback considerations

---

# 25. Git Best Practices

## DO ✅

* Commit frequently
* Use meaningful commit messages
* Pull before push
* Use feature branches
* Review PRs carefully
* Keep branches small
* Use `.gitignore`

---

## DON'T ❌

* Push secrets/API keys
* Commit huge datasets
* Work directly on `main`
* Force push shared branches
* Use vague commit messages

---

# 26. Git in Data Engineering Projects

## Example Repo Structure

```text
data-platform/
│
├── airflow/
├── dbt/
├── terraform/
├── kafka/
├── spark/
├── great_expectations/
├── docker/
├── scripts/
└── docs/
```

---

# 27. Git + CI/CD

Git triggers automation.

Example pipeline:

```text
Git Push
   ↓
GitHub Actions
   ↓
Run Tests
   ↓
Validate SQL
   ↓
Terraform Plan
   ↓
Docker Build
   ↓
Deploy
```

Tools:

* [GitHub Actions](https://github.com/features/actions?utm_source=chatgpt.com)
* [Jenkins](https://www.jenkins.io?utm_source=chatgpt.com)
* [GitLab CI/CD](https://about.gitlab.com/stages-devops-lifecycle/continuous-integration/?utm_source=chatgpt.com)

---

# 28. GitHub Flow vs Git Flow

## GitHub Flow (Recommended)

Simple.

```text
main
 └── feature branch
```

Best for:

* startups
* agile teams
* data engineering teams

---

## Git Flow

Complex enterprise workflow.

```text
main
develop
feature/*
release/*
hotfix/*
```

Used in:

* large enterprises
* strict release cycles

---

# 29. Git Aliases ⚡

Useful shortcuts.

```bash
git config --global alias.st status
git config --global alias.co checkout
git config --global alias.br branch
git config --global alias.cm commit
git config --global alias.lg "log --oneline --graph --all"
```

Usage:

```bash
git st
git lg
```

---

# 30. Essential Commands Cheat Sheet

## Setup

```bash
git init
git clone <url>
git config --global user.name
git config --global user.email
```

---

## Daily Workflow

```bash
git status
git add .
git commit -m "message"
git pull
git push
```

---

## Branching

```bash
git branch
git checkout -b branch-name
git switch branch-name
git merge branch-name
```

---

## Undoing

```bash
git restore file
git reset HEAD~1
git stash
```

---

## History

```bash
git log --oneline
git diff
```

---

# 31. What Actually Matters for Data Engineering Interviews

Most candidates memorize commands. Strong candidates understand workflow.

Focus on:

## Mandatory

* Branching
* Merge conflicts
* PR workflow
* Rebase basics
* CI/CD integration
* `.gitignore`
* GitHub collaboration

---

## High Value

* Monorepo structure
* Infrastructure-as-Code versioning
* GitOps concepts
* Semantic commits
* Release tagging

---

# 32. Real Industry Expectations

A data engineer is expected to:

* work through PRs daily
* review SQL/model changes
* debug pipeline regressions through Git history
* rollback deployments
* collaborate across teams
* maintain infra configs safely

If Git skills are weak, productivity collapses fast.

---

# 33. Final Reality Check

Git is not optional tooling.
It is engineering literacy.

Most students:

* know `git add`
* know `git push`
* panic during conflicts
* destroy branches with bad rebases

Industry expects operational confidence, not tutorial familiarity.

Master:

* branching
* history manipulation
* conflict resolution
* PR workflows
* CI integration

That is the difference between:

* "student who used Git"
  vs
* "engineer who ships systems" 🚀
