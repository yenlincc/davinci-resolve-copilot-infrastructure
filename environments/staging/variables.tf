# Variables for the staging environment.

variable "staging_project_id" {
  type        = string
  description = "The ID of your GCP staging project"
}

variable "staging_regions" {
  type        = list(string)
  description = "A list of GCP regions for your staging GKE clusters (cells)"
  # For more information, refer to the official GCP regions documentation:
  # https://cloud.google.com/about/locations
  # Append some of these regions to `default` if you want to include more US regions:
  # [
  #   "us-central1",    # Iowa
  #   "us-east1",       # South Carolina
  #   "us-east4",       # Northern Virginia
  #   "us-west1",       # Oregon
  #   "us-west2",       # Los Angeles
  #   "us-west3",       # Salt Lake City
  #   "us-west4",       # Las Vegas
  #   "us-south1",      # Dallas
  #   "us-north1"       # Columbus
  # ]
  default = ["us-central1"]
}

variable "staging_default_region" {
  type        = string
  description = "The default GCP region for global resources (e.g., load balancer) in staging"
  default     = "us-central1"
}

variable "staging_gke_cluster_name_prefix" {
  type        = string
  description = "Prefix for the names of the staging GKE clusters"
  default     = "staging-gke-cell"
}

variable "staging_gke_release_channel" {
  type        = string
  description = "The GKE release channel for the staging clusters"
  default     = "STABLE"
}

variable "staging_network_name" {
  type        = string
  description = "The name of the VPC network for staging"
  default     = "staging-cell-vpc"
}

variable "staging_subnets_config" {
  type = map(object({
    region = string
    cidr   = string
  }))
  description = "Configuration for private subnets in staging"
  default = {
    "us-central1-private" = {
      region = "us-central1"
      cidr   = "10.3.0.0/20"
    }
  }
}

variable "staging_health_check_port" {
  type        = number
  description = "The port for the staging global load balancer health check"
  default     = 80
}

variable "staging_service_neg_name" {
  type        = string
  description = "The NEG name used in staging GKE Service annotation"
  default     = "staging-my-service-neg"
}

# Example variables for Cloud DNS (uncomment if you are using the module)
# variable "staging_dns_zone_name" {
#   type        = string
#   description = "The name of the Cloud DNS managed zone for staging"
# }
#
# variable "staging_dns_name" {
#   type        = string
#   description = "The DNS name to associate with the staging global load balancer"
# }
