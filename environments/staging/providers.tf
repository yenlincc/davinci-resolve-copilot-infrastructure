terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 6.0"
    }
  }
}

provider "google" {
  project = var.staging_project_id
  region  = var.staging_default_region
  alias   = "global"
}
