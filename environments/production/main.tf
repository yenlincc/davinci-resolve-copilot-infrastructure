# Configuration for the production environment.

module "production_network" {
  source         = "../../modules/network"
  project_id     = var.project_id
  network_name   = var.network_name
  subnets_config = var.subnets_config
}

module "production_gke_clusters" {
  source           = "../../modules/gke_cluster"
  for_each         = toset(var.regions)
  project_id       = var.project_id
  region           = each.key
  cluster_name     = "${var.gke_cluster_name_prefix}-${each.key}"
  network_name     = module.production_network.network_name
  subnet_name      = module.production_network.subnets["${each.key}-private"].name
  release_channel  = var.gke_release_channel
  service_neg_name = var.service_neg_name
}

module "production_global_load_balancer" {
  source = "../../modules/global_load_balancer"
  providers = {
    # Ref: https://stackoverflow.com/questions/77537323/terraform-required-providers-block-configuration-aliases-argument
    # the left-hand side is the provider name (explicitly declared in
    # `configuration_aliases`) in the child module (i.e. the module you are
    # calling) while the right-hand side is the provider configuration in the
    # root module (the caller module, i.e. this module)
    google.global = google.global
  }
  project_id = var.project_id
  regions    = var.regions
  neg_names_by_region = {
    for region in var.regions : region => "projects/${var.project_id}/regions/${region}/networkEndpointGroups/${var.gke_cluster_name_prefix}-${region}-${module.production_gke_clusters[region].service_neg_name}"
  }
  health_check_port = var.health_check_port
  default_region    = var.default_region # Add the default_region variable
}

# Example Cloud DNS for production
# module "production_cloud_dns" {
#   source = "../../modules/cloud_dns"
#   project_id = var.project_id
#   dns_zone_name = var.dns_zone_name
#   dns_name = var.dns_name
#   load_balancer_ip = module.production_global_load_balancer.global_load_balancer_ip
# }

output "production_global_load_balancer_ip" {
  value       = module.production_global_load_balancer.global_load_balancer_ip
  description = "The IP address of the production global load balancer"
}

output "production_gke_cluster_ids" {
  value       = module.production_gke_clusters
  description = "A map of production GKE cluster IDs by region"
}

output "production_vpc_network_name" {
  value       = module.production_network.network_name
  description = "The name of the production VPC network"
}

output "production_subnetwork_names" {
  value       = module.production_network.subnets
  description = "A map of production subnetwork names by region"
}

# output "production_dns_record" {
#   value       = module.production_cloud_dns.dns_record
#   description = "The full DNS record created for the production load balancer"
# }
