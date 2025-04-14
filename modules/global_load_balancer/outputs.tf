# Defines the output values for the global load balancer module.

output "global_load_balancer_ip" {
  value       = google_compute_global_forwarding_rule.https.ip_address
  description = "The IP address of the global load balancer"
}
