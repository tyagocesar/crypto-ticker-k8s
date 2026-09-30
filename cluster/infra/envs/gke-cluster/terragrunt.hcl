terraform {
  source = "../../modules/cluster"
}

locals {
  project_id = get_env("GCP_PROJECT_ID", "")
}

inputs = {
  project_id   = local.project_id
  cluster_name = "crypto-cluster"
  region       = "us-central1"
  network      = "default"
  subnetwork   = "default"
}

