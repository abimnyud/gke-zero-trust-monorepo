output "cluster_name" {
  description = "Cluster name"
  value       = google_container_cluster.primary.name
}

output "cluster_endpoint" {
  description = "Cluster endpoint"
  value       = google_container_cluster.primary.endpoint
  sensitive   = true
}

output "cluster_ca_certificate" {
  description = "Cluster CA Certificate"
  value       = google_container_cluster.primary.master_auth[0].cluster_ca_certificate
  sensitive   = true
}

output "static_ip" {
  description = "Static IP address for Ingress"
  value       = google_compute_global_address.default.address
}

output "location" {
  description = "Cluster location"
  value       = google_container_cluster.primary.location
}

output "project_id" {
  description = "Project ID"
  value       = var.project_id
}
