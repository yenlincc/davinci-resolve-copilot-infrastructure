# Creates the regional GKE Autopilot clusters in private subnets.

# TODO: should probably further customize this
# https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/container_cluster

resource "google_container_cluster" "autopilot_cluster" {
  name     = var.cluster_name
  location = var.region
  project  = var.project_id

  # Note that when this option is enabled, certain features of Standard GKE are not available
  # https://cloud.google.com/kubernetes-engine/docs/concepts/autopilot-overview#comparison
  enable_autopilot = true

  network    = var.network_name
  subnetwork = var.subnet_name

  release_channel {
    channel = var.release_channel
  }
}
