terraform {
  source = "../../modules/nodepool"
}

locals {
  project_id = get_env("GCP_PROJECT_ID", "")
}

inputs = {
  project_id     = local.project_id
  cluster_name   = "crypto-cluster"
  region         = "us-central1"
  node_pool_name = "prod-pool"
  machine_type   = "e2-medium"
  node_count     = 1
  labels = {
    env = "prod"
  }
  taints = [
    {
      key    = "env"
      value  = "prod"
      effect = "NO_SCHEDULE"
    }
  ]
}
