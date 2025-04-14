# terraform-gcp-cell-based/modules/cloud_dns/outputs.tf
# Defines the output values for the Cloud DNS module.

output "dns_record" {
  value       = google_dns_record_set.lb_a_record.fqdn
  description = "The fully qualified domain name of the created A record"
}
