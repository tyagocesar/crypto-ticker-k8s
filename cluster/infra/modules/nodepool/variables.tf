variable "project_id" {
  type        = string
  description = "GCP project ID"
}

variable "cluster_name" {
  type = string
}

variable "region" {
  type = string
}

variable "node_pool_name" {
  type = string
}

variable "machine_type" {
  type = string
}

variable "node_count" {
  type = number
}

variable "labels" {
  type = map(string)
}

variable "taints" {
  type = list(object({
    key    = string
    value  = string
    effect = string
  }))
}
