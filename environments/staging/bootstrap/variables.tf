# Variables for the staging environment.

variable "project_id" {
  type        = string
  description = "The ID of your GCP staging project"
  default     = "dr-copilot-staging"
}

variable "region" {
  type        = string
  description = "The GCP region for your staging environment"
  default     = "us-central1"
}
