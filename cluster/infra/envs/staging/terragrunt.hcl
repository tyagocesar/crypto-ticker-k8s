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
  node_pool_name = "staging-pool"
  machine_type   = "e2-medium"
  node_count     = 1
  labels = {
    env = "staging"
  }
  taints = [
    {
      key    = "env"
      value  = "staging"
      effect = "NO_SCHEDULE"
    }
  ]
}
