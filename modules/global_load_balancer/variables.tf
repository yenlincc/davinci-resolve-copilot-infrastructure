# Defines the input variables for the global load balancer module.

variable "project_id" {
  type        = string
  description = "The ID of your GCP project"
}

variable "regions" {
  type        = list(string)
  description = "A list of GCP regions where your GKE clusters (cells) are located"
}

variable "neg_names_by_region" {
  type        = map(string)
  description = "A map of region to the self-link of the NEG for the backend service"
}

variable "health_check_port" {
  type        = number
  description = "The port for the global load balancer health check"
}

variable "default_region" {
  type        = string
  description = "The default GCP region to use"
}

# Optional: Variables for SSL certificate
# variable "ssl_certificate_path" {
#   type        = string
#   description = "Path to the SSL certificate file"
#   default     = ""
# }
#
# variable "ssl_private_key_path" {
#   type        = string
#   description = "Path to the SSL private key file"
#   default     = ""
# }
