# Defines the input variables for the Cloud DNS module.

variable "project_id" {
  type        = string
  description = "The ID of your GCP project"
}

variable "dns_zone_name" {
  type        = string
  description = "The name of the Cloud DNS managed zone to create"
}

variable "dns_name" {
  type        = string
  description = "The DNS name (without trailing dot) to associate with the load balancer (e.g., 'myapp.com' or 'staging.myapp.com')"
}

variable "load_balancer_ip" {
  type        = string
  description = "The IP address of the global load balancer"
}
