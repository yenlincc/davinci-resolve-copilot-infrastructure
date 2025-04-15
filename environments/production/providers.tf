terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 6.0"
    }
  }
}

provider "google" {
  project = var.project_id
  region  = var.default_region
}

provider "google" {
  project = var.project_id
  region  = var.default_region
  alias   = "global" # Alias to differentiate from region-specific resources
}
