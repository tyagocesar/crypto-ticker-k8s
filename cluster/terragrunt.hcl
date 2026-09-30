locals {
  project_id = get_env("GCP_PROJECT_ID", "")
}

remote_state {
  backend = "gcs"
  config = {
    bucket = "crypto-state-cluster"
    prefix = "state/state"
  }
}

generate "provider" {
  path      = "provider.tf"
  if_exists = "overwrite"
  contents  = <<EOF
provider "google" {
  project = "${local.project_id}"
  region  = "us-central1"
}
EOF
}
