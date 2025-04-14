# Defines the output values for the GKE cluster module.

output "cluster_id" {
  value       = google_container_cluster.autopilot_cluster.id
  description = "The ID of the GKE Autopilot cluster"
}

output "endpoint" {
  value       = google_container_cluster.autopilot_cluster.endpoint
  description = "The endpoint of the GKE Autopilot cluster"
}

output "service_neg_name" {
  value       = var.service_neg_name
  description = "The name of the Network Endpoint Group associated with the service"
}
