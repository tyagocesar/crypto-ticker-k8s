variable "cluster_name" {
  type        = string
  description = "Nome do cluster GKE"
}

variable "region" {
  type = string
}

variable "network" {
  type = string
}

variable "subnetwork" {
  type = string
}

variable "project_id" {
  type        = string
  description = "GCP project ID"
}
