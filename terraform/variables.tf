variable "project_id" {
  description = "The GCP project ID"
  type        = string
}

variable "region" {
  description = "The GCP region"
  type        = string
  default     = "us-central1"
}

variable "zone" {
  description = "The GCP zone"
  type        = string
  default     = "us-central1-c"
}

variable "cluster_name" {
  description = "The name of the GKE cluster"
  type        = string
  default     = "zero-trust-cluster"
}

variable "machine_type" {
  description = "The machine type for the GKE nodes"
  type        = string
  default     = "e2-small"
}

variable "node_count" {
  description = "The number of nodes in the default pool"
  type        = number
  default     = 1
}

variable "swagger_testing_1_image" {
  description = "Docker image for swagger-testing-1"
  type        = string
}

variable "swagger_testing_2_image" {
  description = "Docker image for swagger-testing-2"
  type        = string
}

variable "cloudflare_token" {
  description = "Cloudflare tunnel token"
  type        = string
  sensitive   = true
}
