terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 6.0"
    }
  }
}

/*
Default provider "google" (without an alias):

This block is typically configured with the project and a default region for
that specific environment. It's used for creating and managing regional
resources. Most GCP resources, such as Compute Engine instances, GKE clusters,
subnets, and regional load balancers, are tied to a specific region. When you
don't explicitly specify a provider for a resource, Terraform will use this
default google provider configuration.
*/
provider "google" {
  project = var.staging_project_id     # Environment-specific project ID
  region  = var.staging_default_region # Environment-specific default region
}

/*
We need "provider = google.global" in the context of the global load balancer
resources because global load balancers in GCP are, well, global resources.

Think of it this way:

Global Resources: Some GCP resources operate across all regions. Examples
include global load balancers, Cloud DNS managed zones, and global network
resources. These resources aren't tied to a specific geographical location.   
Regional Resources: Most other GCP resources are specific to a particular region
(like Compute Engine instances, regional GKE clusters, and subnets).   
When we configure the main google provider block in our environment's
providers.tf file, we typically set a region. This tells Terraform to manage
most resources within that specific region.

However, since the global load balancer operates outside of any single region,
we need to explicitly tell Terraform to use the global scope for these
particular resources. We do this by referencing the google provider with the
alias .global that we defined in our environment's main.tf file.
*/
provider "google" {
  project = var.staging_project_id
  region  = var.staging_default_region
  alias   = "global" # Alias to differentiate global resources
}
