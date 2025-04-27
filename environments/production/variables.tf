# Variables for the production environment.

variable "project_id" {
  type        = string
  description = "The ID of your GCP production project"
  default     = "dr-copilot-production"
}

variable "regions" {
  type        = list(string)
  description = "A list of GCP regions for your production GKE clusters (cells)"
  default     = ["us-central1", "europe-west1"]
}

variable "default_region" {
  type        = string
  description = "The default GCP region for global resources (e.g., load balancer)"
  default     = "us-central1"
}

variable "gke_cluster_name_prefix" {
  type        = string
  description = "Prefix for the names of the production GKE clusters"
  default     = "prod-gke-cell"
}

variable "gke_release_channel" {
  type        = string
  description = "The GKE release channel for the production clusters"
  default     = "STABLE"
}

variable "network_name" {
  type        = string
  description = "The name of the VPC network for production"
  default     = "prod-cell-vpc"
}

variable "subnets_config" {
  type = map(object({
    region = string
    cidr   = string
  }))
  description = "Configuration for private subnets in production"
  default = {
    "us-central1-private" = {
      region = "us-central1"
      cidr   = "10.1.0.0/20"
    }
    "europe-west1-private" = {
      region = "europe-west1"
      cidr   = "10.2.0.0/20"
    }
  }
}

variable "health_check_port" {
  type        = number
  description = "The port for the production global load balancer health check"
  default     = 80
}

variable "service_neg_name" {
  type        = string
  description = "The NEG name used in production GKE Service annotation"
  default     = "prod-my-service-neg"
}

# Example variables for Cloud DNS (uncomment if you are using the module)
# variable "dns_zone_name" {
#   type        = string
#   description = "The name of the Cloud DNS managed zone for production"
# }
#
# variable "dns_name" {
#   type        = string
#   description = "The DNS name to associate with the production global load balancer"
# }
