# Defines the output values for the network module.

output "network_name" {
  value       = google_compute_network.vpc_network.name
  description = "The name of the VPC network"
}

output "subnets" {
  value       = google_compute_subnetwork.subnet
  description = "A map of the created subnets"
}
