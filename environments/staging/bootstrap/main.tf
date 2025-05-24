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
  # ref: https://medium.com/@bbeesley/notes-on-workload-identity-federation-from-github-actions-to-google-cloud-platform-7a818da2c33e
  #   {
  #     "actor": "github-bot",
  #     "actor_id": "123450642",
  #     "aud": "https://github.com/bbeesley",
  #     "base_ref": "",
  #     "enterprise": "bbeesley",
  #     "environment": "staging",
  #     "environment_node_id": "EN_kwDOI1Vzn84yRhwA",
  #     "event_name": "deployment",
  #     "exp": 1677506298,
  #     "head_ref": "",
  #     "iat": 1677505998,
  #     "iss": "https://token.actions.githubusercontent.com",
  #     "job_workflow_ref": "bbeesley/gql-federated-graph-explorer/.github/workflows/deployment.yml@d06e49a10fcaf3c8f71f9428949e6fedb9f07b09",
  #     "job_workflow_sha": "d06e49a10fcaf3c8f71f9428949e6fedb9f07b09",
  #     "jti": "ef405b0e-5507-4aa6-8685",
  #     "nbf": 1677505398,
  #     "ref": "",
  #     "ref_type": "branch",
  #     "repository": "bbeesley/gql-federated-graph-explorer",
  #     "repository_id": "592302719",
  #     "repository_owner": "bbeesley",
  #     "repository_owner_id": "21031",
  #     "repository_visibility": "private",
  #     "run_attempt": "1",
  #     "run_id": "4283094502",
  #     "run_number": "34",
  #     "runner_environment": "github-hosted",
  #     "sha": "d06e49a10fcaf3c8f71f9428949e6fedb9f07b09",
  #     "sub": "repo:bbeesley/gql-federated-graph-explorer:environment:staging",
  #     "workflow": "Deployment 🚀",
  #     "workflow_ref": "bbeesley/gql-federated-graph-explorer/.github/workflows/deployment.yml@d06e49a10fcaf3c8f71f9428949e6fedb9f07b09",
  #     "workflow_sha": "d06e49a10fcaf3c8f71f9428949e6fedb9f07b09"
  #   }
  attribute_condition = "assertion.repository=='yenlincc/davinci-resolve-copilot-infrastructure'"
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
  attribute_condition = "assertion.repository=='yenlincc/davinci-resolve-copilot-service'"
}
