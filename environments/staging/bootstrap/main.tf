# Bootstrap the infrastructure necessary to configure
# Workload Identity pools and providers for authenticating to GCP using GitHub Actions OIDC tokens.
# Ref:
# https://github.com/terraform-google-modules/terraform-google-github-actions-runners/tree/main/modules/gh-oidc

resource "google_service_account" "dr_copilot_infrastructure" {
  account_id   = "dr-copilot-infrastructure"
  display_name = "Service Account for Copilot Infrastructure"
  project      = var.project_id
}

resource "google_service_account" "dr_copilot_service" {
  account_id   = "dr-copilot-service"
  display_name = "Service Account for Copilot service"
  project      = var.project_id
}

module "github-actions-runners-infrastructure" {
  depends_on  = [google_service_account.dr_copilot_infrastructure]
  source      = "terraform-google-modules/github-actions-runners/google//modules/gh-oidc"
  version     = "5.0.0"
  project_id  = var.project_id
  pool_id     = "infrastructure-pool"
  provider_id = "infrastructure-provider"
  sa_mapping = {
    "dr-copilot-infrastructure" = {
      sa_name   = "projects/${var.project_id}/serviceAccounts/${google_service_account.dr_copilot_infrastructure.email}"
      attribute = "attribute.repository/yenlincc/davinci-resolve-copilot-infrastructure"
    }
  }
  attribute_condition = "assertion.repository_owner=='yenlincc' && assertion.repository_name=='davinci-resolve-copilot-infrastructure'"
}

module "github-actions-runners-service" {
  depends_on  = [google_service_account.dr_copilot_service]
  source      = "terraform-google-modules/github-actions-runners/google//modules/gh-oidc"
  version     = "5.0.0"
  project_id  = var.project_id
  pool_id     = "service-pool"
  provider_id = "service-provider"
  sa_mapping = {
    "dr-copilot-service" = {
      sa_name   = "projects/${var.project_id}/serviceAccounts/${google_service_account.dr_copilot_service.email}"
      attribute = "attribute.repository/yenlincc/davinci-resolve-copilot-service"
    }
  }
  attribute_condition = "assertion.repository_owner=='yenlincc' && assertion.repository_name=='davinci-resolve-copilot-service'"
}
