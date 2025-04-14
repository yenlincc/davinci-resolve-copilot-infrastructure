# Defines the input variables for the network module.

variable "project_id" {
  type        = string
  description = "The ID of your GCP project"
}

variable "network_name" {
  type        = string
  description = "The name of the VPC network to create"
}

variable "subnets_config" {
  type = map(object({
    region = string
    cidr   = string
  }))
  description = "Configuration for private subnets, with region and CIDR for each"
}
