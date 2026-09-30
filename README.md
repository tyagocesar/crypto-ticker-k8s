# crypto-ticker-k8s

Technical challenge: deploy a REST API on Kubernetes using GitOps practices and full IaC.

## Architecture

```
                   ┌─────────────────────────────────────┐
  push to main     │           GitHub Actions             │
 ─────────────────►│  CI: build + push image to Docker Hub│
                   └─────────────┬───────────────────────┘
                                 │ workflow_dispatch
                                 ▼
                   ┌─────────────────────────────────────┐
                   │  CD: helm upgrade (staging | prod)   │
                   │  → GKE cluster (us-central1)         │
                   └─────────────┬───────────────────────┘
                                 │
                   ┌─────────────▼───────────────────────┐
                   │         GKE Cluster                  │
                   │  ┌──────────┐   ┌──────────────┐    │
                   │  │ staging  │   │     prod     │    │
                   │  │ node pool│   │  node pool   │    │
                   │  └──────────┘   └──────────────┘    │
                   └─────────────────────────────────────┘
                                 ▲
                   ┌─────────────┴───────────────────────┐
                   │  Terragrunt + Terraform              │
                   │  GCS backend (state)                 │
                   └─────────────────────────────────────┘
```

## Stack

| Layer | Tool |
|---|---|
| App | Python 3.9 / Flask |
| Container | Docker |
| Orchestration | Kubernetes (GKE) |
| IaC | Terraform + Terragrunt |
| Package manager | Helm |
| CI/CD | GitHub Actions |
| State backend | GCS |

## Project Structure

```
.
├── app/
│   └── mb/
│       ├── app.py                    # Crypto ticker proxy (Mercado Bitcoin API)
│       ├── Dockerfile
│       ├── requirements.txt
│       ├── helm/                     # Helm chart (Deployment, Service, Ingress, HPA)
│       └── .github/workflows/
│           ├── ci.yml                # Build + push image on push to main
│           └── cd.yml                # Deploy via Helm (staging | prod) on dispatch
└── cluster/
    ├── terragrunt.hcl                # Root config: GCS backend + Google provider
    └── infra/
        ├── modules/
        │   ├── cluster/              # GKE cluster (VPC-native, no default node pool)
        │   └── nodepool/             # Node pool (labels + taints per environment)
        └── envs/
            ├── gke-cluster/          # Provisions the GKE control plane
            ├── staging/              # Staging node pool
            └── prd/                  # Production node pool
```

## API

```
GET /<pair>    Proxy to Mercado Bitcoin ticker API
```

Example:

```bash
curl http://<service>/BTC
```

```json
{
  "environment": "prod",
  "ticker": [{ "high": "350000.00", "low": "340000.00", "last": "345000.00", ... }]
}
```

## Prerequisites

**Infrastructure:**
- GCP project with GKE API and GCS API enabled
- Service account with roles: `container.admin`, `storage.objectAdmin`
- GCS bucket `crypto-state-cluster` for Terraform state

**GitHub Secrets:**
| Secret | Description |
|---|---|
| `GCP_SA_KEY` | JSON key of the GCP service account |
| `REPO` | Docker Hub username/repo (e.g. `youruser/crypto-ticker`) |

**GitHub Variables:**
| Variable | Description |
|---|---|
| `PROJECT_ID` | GCP project ID |
| `CLUSTER` | GKE cluster name |
| `REGION` | GCP region (e.g. `us-central1`) |

## Infrastructure

Set the project ID via environment variable:

```bash
export GCP_PROJECT_ID=your-gcp-project-id
```

Provision in order:

```bash
# 1. GKE cluster
cd cluster/infra/envs/gke-cluster && terragrunt apply

# 2. Node pools
cd cluster/infra/envs/staging && terragrunt apply
cd cluster/infra/envs/prd     && terragrunt apply
```

## Local Development

```bash
cd app/mb
pip install -r requirements.txt
python app.py
curl http://localhost:5555/BTC
```

## Manual Deploy

```bash
helm upgrade --install crypto-ticker ./app/mb/helm \
  --namespace staging --create-namespace \
  --set image.repository=<REPO>/crypto-ticker \
  --set image.tag=latest \
  --set environment=staging
```
