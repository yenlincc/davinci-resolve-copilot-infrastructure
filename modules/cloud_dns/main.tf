# Creates a Cloud DNS managed zone and an A record pointing to the load balancer.

terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 6.0"
    }
  }
}

resource "google_dns_managed_zone" "zone" {
  provider    = google.global # Explicitly use the global provider
  project     = var.project_id
  name        = var.dns_zone_name
  dns_name    = "${var.dns_name}." # Ensure the trailing dot
  description = "Managed zone for ${var.dns_name}"
  visibility  = "public"
}

resource "google_dns_record_set" "lb_a_record" {
  provider     = google.global # Explicitly use the global provider
  project      = var.project_id
  managed_zone = google_dns_managed_zone.zone.name
  name         = var.dns_name
  type         = "A"
  ttl          = 300
  rrdatas      = [var.load_balancer_ip]
}

output "dns_record" {
  value       = google_dns_record_set.lb_a_record.fqdn
  description = "The fully qualified domain name of the created A record"
}
