# Defines the input variables for the GKE cluster module.

variable "project_id" {
  type        = string
  description = "The ID of your GCP project"
}

variable "region" {
  type        = string
  description = "The GCP region for the GKE cluster"
}

variable "cluster_name" {
  type        = string
  description = "The name of the GKE cluster"
}

variable "network_name" {
  type        = string
  description = "The name of the VPC network to which the cluster will be connected"
}

variable "subnet_name" {
  type        = string
  description = "The name of the private subnetwork to which the cluster will be connected"
}

variable "release_channel" {
  type        = string
  description = "The GKE release channel for the cluster"
}

variable "service_neg_name" {
  type        = string
  description = "The name used in the GKE Service annotation for the NEG"
}
