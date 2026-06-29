# 🚀 FastAPI End-to-End DevOps Project

A **production-grade, full-stack web application** built with FastAPI and React, featuring a complete end-to-end DevOps pipeline. This project demonstrates modern cloud-native best practices including Infrastructure as Code (Terraform), containerized deployments on AWS EKS, CI/CD with GitHub Actions, GitOps with ArgoCD, and observability with Prometheus & Grafana.

---

## 📑 Table of Contents

- [Architecture Overview](#-architecture-overview)
- [Technology Stack](#-technology-stack)
- [Project Structure](#-project-structure)
- [Application Layer (app-repo)](#-application-layer-app-repo)
- [Infrastructure Layer (infra-repo)](#-infrastructure-layer-infra-repo)
- [Kubernetes Manifests (k8s)](#-kubernetes-manifests-k8s)
- [CI/CD Pipelines](#-cicd-pipelines)
- [GitOps with ArgoCD](#-gitops-with-argocd)
- [Monitoring & Observability](#-monitoring--observability)
- [Security](#-security)
- [Prerequisites](#-prerequisites)
- [Getting Started](#-getting-started)
- [Local Development](#-local-development)
- [Deployment](#-deployment)
- [Environment Variables](#-environment-variables)
- [License](#-license)

---

## 🏗 Architecture Overview

```
┌─────────────────────────────────────────────────────────────────────┐
│                        GitHub Repository                            │
│  ┌──────────┐    ┌──────────┐    ┌──────────┐    ┌──────────────┐  │
│  │ app-repo │    │infra-repo│    │   k8s/   │    │  monitoring/ │  │
│  └────┬─────┘    └────┬─────┘    └────┬─────┘    └──────┬───────┘  │
└───────┼───────────────┼───────────────┼─────────────────┼──────────┘
        │               │               │                 │
        ▼               ▼               ▼                 ▼
┌──────────────┐ ┌─────────────┐ ┌────────────┐  ┌──────────────────┐
│GitHub Actions│ │  Terraform  │ │   ArgoCD   │  │ kube-prometheus  │
│  CI/CD       │ │  AWS Infra  │ │   GitOps   │  │     stack        │
└──────┬───────┘ └──────┬──────┘ └─────┬──────┘  └────────┬─────────┘
       │                │              │                   │
       ▼                ▼              ▼                   ▼
┌──────────────────────────────────────────────────────────────────────┐
│                         AWS Cloud (ap-south-1)                       │
│                                                                      │
│  ┌──────────┐   ┌──────────────────────────────────────────┐         │
│  │   ECR    │   │            Amazon EKS Cluster             │         │
│  │ Backend  │──▶│  ┌──────────┐  ┌──────────┐             │         │
│  │ Frontend │   │  │ Backend  │  │ Frontend │             │         │
│  └──────────┘   │  │  Pod(s)  │  │  Pod(s)  │             │         │
│                 │  └─────┬────┘  └──────────┘             │         │
│                 └────────┼────────────────────────────────┘         │
│                          │                                           │
│                 ┌────────▼────────┐   ┌───────────────┐             │
│                 │   Amazon RDS    │   │   Secrets     │             │
│                 │  (PostgreSQL)   │   │   Manager     │             │
│                 └─────────────────┘   └───────────────┘             │
└──────────────────────────────────────────────────────────────────────┘
```

---

## 🛠 Technology Stack

### Application
| Component     | Technology                                                                 |
|---------------|---------------------------------------------------------------------------|
| **Backend**   | [FastAPI](https://fastapi.tiangolo.com) (Python 3.10)                     |
| **Frontend**  | [React](https://react.dev) + TypeScript + [Vite](https://vitejs.dev)     |
| **Database**  | [PostgreSQL 18](https://www.postgresql.org)                               |
| **ORM**       | [SQLModel](https://sqlmodel.tiangolo.com) / SQLAlchemy                   |
| **Validation**| [Pydantic](https://docs.pydantic.dev)                                    |
| **Auth**      | JWT (JSON Web Tokens)                                                     |
| **UI**        | [Tailwind CSS](https://tailwindcss.com) + [shadcn/ui](https://ui.shadcn.com) |
| **E2E Tests** | [Playwright](https://playwright.dev)                                      |
| **API Tests** | [Pytest](https://pytest.org)                                              |

### Infrastructure & DevOps
| Component           | Technology                                                          |
|---------------------|---------------------------------------------------------------------|
| **IaC**             | [Terraform](https://terraform.io) (>= 1.10.0) with AWS Provider    |
| **Cloud**           | AWS (ap-south-1 – Mumbai)                                           |
| **Container Orchestration** | [Amazon EKS](https://aws.amazon.com/eks/) (Kubernetes 1.35) |
| **Container Registry** | [Amazon ECR](https://aws.amazon.com/ecr/)                       |
| **Database (Managed)** | [Amazon RDS](https://aws.amazon.com/rds/) (PostgreSQL 18.4)     |
| **Secrets**         | [AWS Secrets Manager](https://aws.amazon.com/secrets-manager/)      |
| **CI/CD**           | [GitHub Actions](https://github.com/features/actions) (OIDC Auth)   |
| **GitOps**          | [ArgoCD](https://argo-cd.readthedocs.io/)                          |
| **Monitoring**      | [Prometheus](https://prometheus.io) + [Grafana](https://grafana.com) (kube-prometheus-stack) |
| **Policy Engine**   | [Kyverno](https://kyverno.io)                                      |
| **Reverse Proxy**   | [Traefik](https://traefik.io) (local dev) / AWS Load Balancer (prod)|
| **Containerization**| [Docker](https://docker.com) / Docker Compose                      |
| **Package Manager** | [uv](https://docs.astral.sh/uv/) (Python) / [Bun](https://bun.sh) (JS) |
| **Code Quality**    | pre-commit, Ruff, mypy, Biome, typos, zizmor                       |

---

## 📁 Project Structure

```
FastAPI_end-to-end_DevOps/
│
├── .github/workflows/              # CI/CD pipeline definitions
│   ├── backend-build.yml            #   → Build & deploy backend to EKS
│   ├── frontend-build.yml           #   → Build & push frontend to ECR
│   └── terraform-provision.yml      #   → Infrastructure provisioning
│
├── app-repo/                        # Full-stack application source code
│   ├── backend/                     #   → FastAPI backend (Python)
│   │   ├── app/                     #     → Application source code
│   │   ├── tests/                   #     → Pytest test suite
│   │   ├── scripts/                 #     → Startup & utility scripts
│   │   ├── Dockerfile               #     → Multi-stage Docker build
│   │   ├── pyproject.toml           #     → Python project config
│   │   └── alembic.ini              #     → Database migration config
│   ├── frontend/                    #   → React frontend (TypeScript)
│   │   ├── src/                     #     → React source code
│   │   ├── tests/                   #     → Playwright E2E tests
│   │   ├── Dockerfile               #     → Multi-stage build (Bun → Nginx)
│   │   ├── package.json             #     → Node dependencies
│   │   └── nginx.conf               #     → Production Nginx config
│   ├── compose.yml                  #   → Docker Compose (production)
│   ├── compose.override.yml         #   → Docker Compose (development)
│   ├── .env                         #   → Environment variables
│   └── .pre-commit-config.yaml      #   → Pre-commit hooks
│
├── infra-repo/                      # Terraform IaC
│   ├── environments/
│   │   └── staging/                 #   → Staging environment config
│   │       ├── main.tf              #     → Module orchestration
│   │       ├── backend.tf           #     → S3 remote state backend
│   │       ├── providers.tf         #     → AWS provider config
│   │       └── variables.tf         #     → Input variables
│   └── modules/                     #   → Reusable Terraform modules
│       ├── networking/              #     → VPC, subnets, routing
│       ├── cluster/                 #     → EKS cluster & node groups
│       ├── database/                #     → RDS PostgreSQL instance
│       ├── registry/                #     → ECR repositories
│       └── secrets/                 #     → Secrets Manager
│
├── k8s/                             # Kubernetes manifests
│   ├── backend.yaml                 #   → Backend Deployment + Service
│   ├── frontend.yaml                #   → Frontend Deployment + Service
│   ├── backend-serviceaccount.yaml  #   → IRSA ServiceAccount
│   ├── backend-servicemonitor.yaml  #   → Prometheus ServiceMonitor
│   ├── network-policy.yaml          #   → Network access control
│   ├── kyverno-disallow-root.yaml   #   → Pod security policy
│   └── argocd-private-repo-secret.yaml  → ArgoCD repo credentials
│
├── monitoring/                      # Monitoring stack configuration
│   └── values.yaml                  #   → kube-prometheus-stack Helm values
│
├── argocd-app.yaml                  # ArgoCD Application manifest
├── gitops-repo/                     # GitOps repository (placeholder)
└── .gitignore                       # Git ignore rules
```

---

## 🖥 Application Layer (app-repo)

### Backend — FastAPI

The backend is a production-ready **FastAPI** application featuring:

- **SQLModel ORM** for database interactions with PostgreSQL
- **Pydantic** for request/response validation and settings management
- **JWT Authentication** with secure password hashing
- **Alembic** for database schema migrations
- **Email-based password recovery** with SMTP support
- **Automatic API documentation** via Swagger UI / ReDoc
- **Health check endpoint** at `/api/v1/utils/health-check/`
- **Prometheus metrics** endpoint at `/metrics`
- Runs with **4 Uvicorn workers** in production

**Dockerfile** uses a multi-stage build with [uv](https://docs.astral.sh/uv/) for fast, deterministic Python dependency installation.

### Frontend — React + Vite

The frontend is a **React SPA** built with TypeScript:

- **Vite** for lightning-fast development and optimized production builds
- **Tailwind CSS** + **shadcn/ui** for a modern, accessible component library
- **Auto-generated API client** from the OpenAPI schema
- **Dark mode** support
- **Playwright** for end-to-end testing

**Dockerfile** uses a two-stage build:
1. **Build stage**: Uses Bun to install dependencies and compile the app
2. **Production stage**: Serves the static build via **Nginx**

### Local Development with Docker Compose

The app supports multi-service local development:

| Service      | Description                              |
|-------------|------------------------------------------|
| `db`        | PostgreSQL 18 database                   |
| `adminer`   | Database administration UI               |
| `prestart`  | Runs migrations and seeds initial data   |
| `backend`   | FastAPI application server               |
| `frontend`  | React app served via Nginx               |

Traefik is used as a reverse proxy with automatic HTTPS in production via Let's Encrypt.

---

## ☁ Infrastructure Layer (infra-repo)

All cloud infrastructure is managed as code using **Terraform** with modular architecture:

### Terraform Modules

| Module         | Resources Created                                                         |
|----------------|--------------------------------------------------------------------------|
| **networking** | VPC, 3 public subnets, 3 private subnets, 3 database subnets (across 3 AZs) |
| **cluster**    | EKS cluster (v1.35), managed node group (t3.micro SPOT instances), IRSA  |
| **database**   | RDS PostgreSQL 18.4 (db.t4g.micro), security group for VPC-internal access |
| **registry**   | 2 ECR repositories (backend + frontend), KMS encryption, lifecycle policies (keep last 10 images) |
| **secrets**    | AWS Secrets Manager secret with auto-generated database credentials       |

### State Management

- **Remote backend**: Terraform state stored in **S3** with encryption and lock files
- **Bucket**: `devops-project-01-tfstate-q919ah`
- **Region**: `ap-south-1` (Mumbai)

### Key Configuration

| Parameter       | Value             |
|-----------------|-------------------|
| AWS Region      | `ap-south-1`      |
| VPC CIDR        | `10.0.0.0/16`     |
| Environment     | `staging`          |
| EKS Version     | `1.35`             |
| Node Type       | `t3.micro` (SPOT)  |
| RDS Engine      | PostgreSQL `18.4`  |
| RDS Class       | `db.t4g.micro`     |

---

## ☸ Kubernetes Manifests (k8s)

### Backend Deployment

- **Replicas**: 1 (Recreate strategy)
- **Image**: Pulled from Amazon ECR
- **Port**: 8000 (exposed via LoadBalancer on port 80)
- **Resources**: 250m–500m CPU, 256Mi–512Mi memory
- **Security**: Runs as non-root user (UID 10001), read-only root filesystem, all capabilities dropped
- **Service Account**: IRSA-enabled (`fastapi-backend-sa`) for secure AWS API access
- **Secrets**: Database password injected from Kubernetes Secret `rds-db-credentials`

### Frontend Deployment

- **Replicas**: 1
- **Image**: Pulled from Amazon ECR (Nginx-based)
- **Port**: 80 (exposed via LoadBalancer)
- **Config**: `VITE_API_URL` pointed at the backend's LoadBalancer DNS

### Security Policies

| Manifest                        | Purpose                                           |
|---------------------------------|---------------------------------------------------|
| `network-policy.yaml`           | Restricts backend ingress to frontend pods and monitoring namespace only |
| `kyverno-disallow-root.yaml`    | **ClusterPolicy** enforcing `runAsNonRoot: true` on all pods (excludes `argocd` namespace) |
| `backend-serviceaccount.yaml`   | IRSA ServiceAccount for AWS API access from pods  |

### Observability

| Manifest                        | Purpose                                           |
|---------------------------------|---------------------------------------------------|
| `backend-servicemonitor.yaml`   | Prometheus ServiceMonitor scraping `/metrics` every 30s |

---

## 🔄 CI/CD Pipelines

Three **GitHub Actions workflows** automate the entire delivery pipeline:

### 1. Backend Build & Deploy (`backend-build.yml`)

**Trigger**: Push to `main` on changes in `app-repo/backend/**`

```
Checkout → AWS OIDC Auth → ECR Login → Docker Build & Push → Update kubeconfig → kubectl apply
```

- Authenticates to AWS via **OIDC** (no static credentials)
- Builds the Docker image and pushes to ECR with both `SHA` and `latest` tags
- Deploys directly to EKS by applying `k8s/backend.yaml`

### 2. Frontend Build & Push (`frontend-build.yml`)

**Trigger**: Push to `main` on changes in `app-repo/frontend/**`

```
Checkout → AWS OIDC Auth → ECR Login → Docker Build & Push
```

- Builds the frontend Docker image and pushes to ECR
- Tagged with commit SHA and `latest`

### 3. Infrastructure Provisioning (`terraform-provision.yml`)

**Trigger**: Push or PR to `main` on changes in `infra-repo/**`

```
Checkout → AWS OIDC Auth → Terraform Init → Validate → Plan (PR) → Apply (push to main)
```

- **Pull Requests**: Runs `terraform plan` for review
- **Push to main**: Auto-applies with `terraform apply -auto-approve`
- Uses Terraform v1.10.0

### Authentication

All workflows use **AWS OIDC federation** via `aws-actions/configure-aws-credentials@v4` — no long-lived AWS access keys stored in GitHub Secrets. Only the IAM role ARN is stored as a secret (`AWS_GITHUB_ACTIONS_ROLE_ARN`).

---

## 🔁 GitOps with ArgoCD

ArgoCD is configured to continuously sync Kubernetes manifests from this repository:

| Parameter            | Value                                                              |
|----------------------|---------------------------------------------------------------------|
| **Application Name** | `fastapi-gitops-stack`                                              |
| **Source Repo**      | `https://github.com/Mayank-Bhawsar/FastAPI_end-to-end_DevOps.git`  |
| **Source Path**      | `k8s/`                                                              |
| **Target Cluster**   | In-cluster (`https://kubernetes.default.svc`)                       |
| **Target Namespace** | `default`                                                           |
| **Sync Policy**      | Automated with **prune** and **self-heal** enabled                  |
| **Sync Options**     | `CreateNamespace=true`                                              |

ArgoCD watches the `k8s/` directory and automatically applies any changes committed to the `HEAD` branch, pruning stale resources and self-healing any drift.

---

## 📊 Monitoring & Observability

The project uses the **kube-prometheus-stack** Helm chart for full cluster observability:

### Components

| Tool            | Purpose                              | Configuration                    |
|-----------------|--------------------------------------|----------------------------------|
| **Prometheus**  | Metrics collection & alerting        | 2-day retention, ephemeral storage |
| **Grafana**     | Dashboards & visualization           | No persistent storage (ephemeral) |
| **Alertmanager**| Alert routing & notifications        | Ephemeral storage                 |

### Application Metrics

- The backend exposes Prometheus metrics at `/metrics`
- A **ServiceMonitor** (`backend-servicemonitor.yaml`) is configured to scrape metrics every **30 seconds**
- `serviceMonitorSelectorNilUsesHelmValues: false` ensures all ServiceMonitors across namespaces are discovered

---

## 🔒 Security

This project implements defense-in-depth security practices:

| Layer                | Implementation                                                            |
|----------------------|---------------------------------------------------------------------------|
| **CI/CD Auth**       | AWS OIDC federation – no static credentials                               |
| **Container Security** | Non-root user (UID 10001), read-only root filesystem, all capabilities dropped, no privilege escalation |
| **Cluster Policy**   | Kyverno `disallow-root-user` – enforces `runAsNonRoot` cluster-wide       |
| **Network Policy**   | Backend pods accept traffic only from frontend pods and monitoring namespace |
| **Database Security** | RDS in private subnets, security group limits access to VPC CIDR only     |
| **Secrets Management** | AWS Secrets Manager for DB credentials, Kubernetes Secrets for pod injection |
| **Image Security**   | ECR scan-on-push enabled, KMS encryption for images at rest               |
| **IRSA**             | Fine-grained IAM roles for Kubernetes ServiceAccounts                     |
| **HTTPS**            | Traefik with Let's Encrypt auto-TLS (local/staging), LoadBalancer (production) |

---

## ✅ Prerequisites

Before getting started, ensure you have the following installed:

| Tool            | Version       | Purpose                          |
|-----------------|---------------|----------------------------------|
| [Docker](https://www.docker.com/get-started)     | Latest        | Container runtime                |
| [Docker Compose](https://docs.docker.com/compose/) | v2+         | Local multi-service orchestration|
| [Terraform](https://www.terraform.io/downloads)  | >= 1.10.0     | Infrastructure provisioning      |
| [AWS CLI](https://aws.amazon.com/cli/)           | v2            | AWS resource management          |
| [kubectl](https://kubernetes.io/docs/tasks/tools/) | Latest      | Kubernetes cluster management    |
| [Helm](https://helm.sh/docs/intro/install/)      | v3            | Kubernetes package management    |
| [uv](https://docs.astral.sh/uv/)                | Latest        | Python package management        |
| [Bun](https://bun.sh)                            | v1+           | JavaScript runtime & bundler     |
| [Git](https://git-scm.com/)                      | Latest        | Version control                  |

### AWS Requirements

- An AWS account with appropriate IAM permissions
- An OIDC identity provider configured for GitHub Actions
- An IAM role with trust policy for GitHub Actions OIDC

---

## 🚀 Getting Started

### 1. Clone the Repository

```bash
git clone https://github.com/Mayank-Bhawsar/FastAPI_end-to-end_DevOps.git
cd FastAPI_end-to-end_DevOps
```

### 2. Provision Infrastructure

```bash
cd infra-repo/environments/staging

# Initialize Terraform
terraform init

# Review the plan
terraform plan

# Apply infrastructure changes
terraform apply
```

This will create:
- VPC with public, private, and database subnets
- EKS cluster with managed node groups
- RDS PostgreSQL instance
- ECR repositories for backend and frontend
- Secrets Manager for database credentials

### 3. Configure kubectl

```bash
aws eks update-kubeconfig --region ap-south-1 --name staging-fastapi-cluster
```

### 4. Install Monitoring Stack

```bash
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo update

helm install kube-prometheus-stack prometheus-community/kube-prometheus-stack \
  --namespace monitoring --create-namespace \
  -f monitoring/values.yaml
```

### 5. Install ArgoCD

```bash
kubectl create namespace argocd
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml

# Apply the ArgoCD Application
kubectl apply -f argocd-app.yaml
```

### 6. Deploy Kubernetes Manifests

```bash
kubectl apply -f k8s/
```

---

## 💻 Local Development

### Start the Full Stack Locally

```bash
cd app-repo

# Copy and configure environment variables
cp .env.example .env  # Edit .env with your values

# Start all services
docker compose up -d
```

### Access Local Services

| Service     | URL                         |
|------------|------------------------------|
| Frontend   | `http://localhost`           |
| Backend API| `http://localhost:8000`       |
| API Docs   | `http://localhost:8000/docs`  |
| Adminer    | `http://localhost:8080`       |

### Code Quality & Pre-commit Hooks

The project uses pre-commit hooks for code quality:

```bash
cd app-repo

# Install pre-commit hooks
pre-commit install

# Run all hooks manually
pre-commit run --all-files
```

**Configured hooks**:
- `ruff` — Python linting & formatting
- `mypy` — Python static type checking
- `biome` — Frontend linting
- `typos` — Spell checking
- `zizmor` — GitHub Actions security scanner
- Auto-generated frontend SDK from OpenAPI spec

---

## 🌍 Deployment

### Production Deployment Flow

1. **Push code** to `main` branch
2. **GitHub Actions** automatically:
   - Builds Docker images
   - Pushes to ECR with SHA + `latest` tags
   - Applies Kubernetes manifests (backend)
3. **ArgoCD** detects changes in `k8s/` and syncs to the cluster
4. **EKS** rolls out the new deployment

### Infrastructure Changes

1. **Modify** Terraform files in `infra-repo/`
2. **Create a PR** → GitHub Actions runs `terraform plan`
3. **Merge to main** → GitHub Actions runs `terraform apply`

---

## 🔐 Environment Variables

### Application (.env)

| Variable                    | Description                              | Required |
|----------------------------|------------------------------------------|----------|
| `SECRET_KEY`               | JWT signing key                          | ✅       |
| `POSTGRES_SERVER`          | Database hostname                        | ✅       |
| `POSTGRES_PORT`            | Database port (default: 5432)            | ✅       |
| `POSTGRES_DB`              | Database name                            | ✅       |
| `POSTGRES_USER`            | Database username                        | ✅       |
| `POSTGRES_PASSWORD`        | Database password                        | ✅       |
| `FIRST_SUPERUSER`          | Admin email address                      | ✅       |
| `FIRST_SUPERUSER_PASSWORD` | Admin password                           | ✅       |
| `BACKEND_CORS_ORIGINS`     | Allowed CORS origins                     | ✅       |
| `FRONTEND_HOST`            | Frontend URL                             | ✅       |
| `SMTP_HOST`                | Email server hostname                    | ❌       |
| `SMTP_USER`                | Email server username                    | ❌       |
| `SMTP_PASSWORD`            | Email server password                    | ❌       |
| `SENTRY_DSN`               | Sentry error tracking DSN               | ❌       |

### GitHub Actions Secrets

| Secret                         | Description                              |
|-------------------------------|------------------------------------------|
| `AWS_GITHUB_ACTIONS_ROLE_ARN` | IAM role ARN for OIDC authentication     |

### Terraform Variables

| Variable       | Default        | Description             |
|----------------|----------------|-------------------------|
| `aws_region`   | `ap-south-1`   | AWS deployment region   |
| `vpc_cidr`     | `10.0.0.0/16`  | VPC CIDR block          |
| `environment`  | `staging`      | Environment name        |

---

## 📄 License

This project is based on the [Full Stack FastAPI Template](https://github.com/fastapi/full-stack-fastapi-template) and is licensed under the **MIT License**. See the [LICENSE](app-repo/LICENSE) file for details.

---

## 🤝 Contributing

Contributions are welcome! Please see [CONTRIBUTING.md](app-repo/CONTRIBUTING.md) for guidelines on how to contribute to this project.

---

<p align="center">
  Built with ❤️ by <a href="https://github.com/Mayank-Bhawsar">Mayank Bhawsar</a>
</p>
