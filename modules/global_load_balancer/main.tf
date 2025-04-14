# Creates the global HTTP(S) load balancer.

resource "google_compute_global_forwarding_rule" "https" {
  name                  = "global-https-forwarding-rule"
  project               = var.project_id
  target                = google_compute_target_https_proxy.https.id
  port_range            = "443"
  load_balancing_scheme = "EXTERNAL"
}

resource "google_compute_target_https_proxy" "https" {
  name    = "global-https-target-proxy"
  project = var.project_id
  url_map = google_compute_global_url_map.default.id
  # Optional: ssl_certificates = [google_compute_ssl_certificate.default.id]
}

# TODO: a lot of these are called "default". Is that like a logical name or physical
# name of the resource provisioned?
# Also, why is there another name attribute?
resource "google_compute_global_url_map" "default" {
  name            = "global-url-map"
  project         = var.project_id
  default_service = google_compute_global_backend_service.default.id
}

resource "google_compute_global_backend_service" "default" {
  name                  = "global-backend-service"
  project               = var.project_id
  protocol              = "HTTP" # Or HTTPS if traffic to backends is also secured
  load_balancing_scheme = "EXTERNAL"
  health_checks         = [google_compute_health_check.default.id]

  dynamic "backend" {
    for_each = var.neg_names_by_region
    content {
      group           = each.value # The self-link of the NEG
      balancing_mode  = "UTILIZATION"
      max_utilization = 0.8
    }
  }
}

resource "google_compute_health_check" "default" {
  name    = "global-health-check"
  project = var.project_id
  http_health_check {
    port = var.health_check_port # Use the provided health check port
  }
}

# Optional: SSL Certificate Management
# resource "google_compute_ssl_certificate" "default" {
#   name        = "global-ssl-certificate"
#   project     = var.project_id
#   private_key = file(var.ssl_private_key_path)
#   certificate = file(var.ssl_certificate_path)
# }
