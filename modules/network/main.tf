# Creates the global VPC network and regional private subnets (
# Placing your GKE nodes in private subnets is generally a more secure approach.
# The global load balancer will handle all incoming public traffic to your application.
# Your GKE nodes don't need public IP addresses to receive this traffic).
#
# with Cloud NAT (enable resources in the private subnet, such as GKE nodes, to initiate
# outbound connections without having a public IP).
#
# and Private Google Access (This option allows VMs and containers without external IP
# addresses to reach Google Cloud APIs and services using the internal IP addresses of
# the subnet. Traffic stays within Google's network).

terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 6.0"
    }
  }
}

resource "google_compute_network" "vpc_network" {
  project                 = var.project_id
  name                    = var.network_name
  auto_create_subnetworks = false
  routing_mode            = "GLOBAL"
}

resource "google_compute_subnetwork" "subnet" {
  for_each = var.subnets_config

  project                  = var.project_id
  name                     = each.key
  region                   = each.value.region
  network                  = google_compute_network.vpc_network.id
  ip_cidr_range            = each.value.cidr
  private_ip_google_access = true # Enable Private Google Access for this subnet
}

# Cloud NAT configuration for private subnets
resource "google_compute_router" "nat_router" {
  for_each = var.subnets_config

  project = var.project_id
  name    = "${each.key}-router"
  region  = each.value.region
  network = google_compute_network.vpc_network.id
}

resource "google_compute_router_nat" "nat_config" {
  for_each = google_compute_router.nat_router

  project                            = var.project_id
  name                               = "${each.key}-nat"
  router                             = each.value.name
  region                             = each.value.region
  nat_ip_allocate_option             = "AUTO_ONLY"
  source_subnetwork_ip_ranges_to_nat = "ALL_SUBNETWORKS_ALL_IP_RANGES"
}
