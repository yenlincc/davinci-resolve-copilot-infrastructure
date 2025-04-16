# TODO: should probably revisit and rename these logical IDs or even physical
# names to avoid conflict in the future?

# Creates the global HTTP(S) load balancer.
# Ref: https://cloud.google.com/load-balancing/docs/https#component

terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 6.0"
      # Ref: https://stackoverflow.com/questions/77537323/terraform-required-providers-block-configuration-aliases-argument
      # when calling this module in particular, you need to
      # provide the configuration alias it expects below:
      configuration_aliases = [google.global]
    }
  }
}

# An external forwarding rule specifies an external IP address, port, and target
# HTTP(S) proxy. Clients use the IP address and port to connect to the load
# balancer.
resource "google_compute_global_forwarding_rule" "https" {
  provider   = google.global
  name       = "global-https-forwarding-rule"
  project    = var.project_id
  target     = google_compute_target_https_proxy.https.id
  port_range = "443"
  # https://cloud.google.com/load-balancing/docs/forwarding-rule-concepts
  # https://cloud.google.com/load-balancing/docs/https
  # The following uses Global external Application Load Balancer instead of
  # the Classic Application Load Balancer.
  load_balancing_scheme = "EXTERNAL_MANAGED"
}

# A target HTTP(S) proxy receives a request from the client. The HTTP(S) proxy
# evaluates the request by using the URL map to make traffic routing decisions.
# The proxy can also authenticate communications by using SSL certificates.
# Ref: https://cloud.google.com/load-balancing/docs/https/traffic-management-global
resource "google_compute_target_https_proxy" "https" {
  provider = google.global
  name     = "global-https-target-proxy"
  project  = var.project_id
  url_map  = google_compute_url_map.default.id
  # Optional: ssl_certificates = [google_compute_ssl_certificate.default.id]
}

# A lot of these are called "default". Is that like a logical name or physical
# name of the resource provisioned? A: This name is a local identifier within
# the Terraform configuration. I.e. so essentially, it's the logical ID that
# only exists in Terraform configuration. Similar to
# https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/resources-section-structure.html#resources-section-logical-id
#
# The HTTP(S) proxy uses a URL map to make a routing determination based on HTTP
# attributes (such as the request path, cookies, or headers). Based on the
# routing decision, the proxy forwards client requests to specific backend
# services or backend buckets. The URL map can specify additional actions, such
# as sending redirects to clients.
#
# Ref: https://cloud.google.com/load-balancing/docs/url-map#terraform
#
# google_compute_url_map:
# This resource is used for global load balancers, specifically the Global
# external Application Load Balancer and the classic Application Load Balancer.
# It defines how traffic is routed to backend services or backend buckets based
# on rules applied to hostnames and URL paths.
#
# google_compute_region_url_map:
# This resource is used for regional load balancers, specifically the Regional
# external Application Load Balancer and the Internal Application Load Balancer.
# It serves a similar purpose to the global URL map but operates within a
# specific region.
resource "google_compute_url_map" "default" {
  provider = google.global
  # Also, why is there another name attribute?
  # A: It's the actual physical name of the resource in GCP.
  name            = "global-url-map"
  project         = var.project_id
  default_service = google_compute_backend_service.default.id
}

# A backend service distributes requests to healthy backends. The global
# external Application Load Balancers also support backend buckets. One or more
# backends must be connected to the backend service or backend bucket.
resource "google_compute_backend_service" "default" {
  provider              = google.global
  name                  = "global-backend-service"
  project               = var.project_id
  protocol              = "HTTP" # Or HTTPS if traffic to backends is also secured
  load_balancing_scheme = "EXTERNAL_MANAGED"
  health_checks         = [google_compute_health_check.default.id]

  dynamic "backend" {
    for_each = var.neg_names_by_region
    content {
      group = each.value # The self-link of the NEG
      # TODO: experiment with the balancing mode
      balancing_mode  = "UTILIZATION"
      max_utilization = 0.8
    }
  }
}

# A health check periodically monitors the readiness of your backends. This
# reduces the risk that requests might be sent to backends that can't service
# the request.


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
