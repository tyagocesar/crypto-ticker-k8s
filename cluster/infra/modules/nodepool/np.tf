resource "google_container_node_pool" "custom_pool" {
  name     = var.node_pool_name
  cluster  = var.cluster_name
  location = var.region
  project  = var.project_id

  node_config {
    machine_type = var.machine_type
    labels       = var.labels
    oauth_scopes = [
      "https://www.googleapis.com/auth/cloud-platform"
    ]
    dynamic "taint" {
      for_each = var.node_pool_name == "service-pool" ? [] : var.taints
      content {
        key    = taint.value.key
        value  = taint.value.value
        effect = taint.value.effect
      }
    }
  }
  initial_node_count = var.node_count
}

