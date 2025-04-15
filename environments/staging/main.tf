# Configuration for the staging environment.

module "staging_network" {
  source         = "../../modules/network"
  project_id     = var.staging_project_id
  network_name   = var.staging_network_name
  subnets_config = var.staging_subnets_config
}

module "staging_gke_clusters" {
  source     = "../../modules/gke_cluster"
  for_each   = toset(var.staging_regions)
  project_id = var.staging_project_id
  # each.key dynamically holds the value of the current region being processed.
  region           = each.key
  cluster_name     = "${var.staging_gke_cluster_name_prefix}-${each.key}"
  network_name     = module.staging_network.network_name
  subnet_name      = module.staging_network.subnets["${each.key}-private"].name
  release_channel  = var.staging_gke_release_channel
  service_neg_name = var.staging_service_neg_name
}

module "staging_global_load_balancer" {
  source = "../../modules/global_load_balancer"
  providers = {
    # google = google.global # Explicitly use the global alias
  }
  project_id = var.staging_project_id
  regions    = var.staging_regions
  neg_names_by_region = {
    for region in var.staging_regions : region => "projects/${var.staging_project_id}/regions/${region}/networkEndpointGroups/${var.staging_gke_cluster_name_prefix}-${region}-${module.staging_gke_clusters[region].service_neg_name}"
  }
  health_check_port = var.staging_health_check_port
  default_region    = var.staging_default_region # Add the default_region variable
}

# Example Cloud DNS for staging
# module "staging_cloud_dns" {
#   source = "../../modules/cloud_dns"
#   providers = {
#     google = google.global # Explicitly use the global alias
#   }
#   project_id = var.staging_project_id
#   dns_zone_name = var.staging_dns_zone_name
#   dns_name = var.staging_dns_name
#   load_balancer_ip = module.staging_global_load_balancer.global_load_balancer_ip
# }

output "staging_global_load_balancer_ip" {
  value       = module.staging_global_load_balancer.global_load_balancer_ip
  description = "The IP address of the staging global load balancer"
}

output "staging_gke_cluster_ids" {
  value       = module.staging_gke_clusters
  description = "A map of staging GKE cluster IDs by region"
}

output "staging_vpc_network_name" {
  value       = module.staging_network.network_name
  description = "The name of the staging VPC network"
}

output "staging_subnetwork_names" {
  value       = module.staging_network.subnets
  description = "A map of staging subnetwork names by region"
}

# output "staging_dns_record" {
#   value       = module.staging_cloud_dns.dns_record
#   description = "The full DNS record created for the staging load balancer"
# }
