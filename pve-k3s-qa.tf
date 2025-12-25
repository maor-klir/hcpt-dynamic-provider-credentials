# "pve-k3s-qa" workspace federated identity credentials

# Creates a federated identity credential for the "pve-k3s-qa" workspace "plan" run phase.
#
# Reference: https://developer.hashicorp.com/terraform/cloud-docs/dynamic-provider-credentials/azure-configuration
resource "azuread_application_federated_identity_credential" "pve-k3s-qa_plan" {
  application_id = azuread_application.hcpt_application.id
  display_name   = "pve-k3s-qa-plan"
  audiences      = [var.hcpt_azure_audience]
  issuer         = "https://${var.hcpt_hostname}"
  subject        = "organization:${var.hcpt_organization_name}:project:${var.hcpt_project_name}:workspace:pve-k3s-qa:run_phase:plan"
  depends_on     = [azuread_application.hcpt_application]
}

# Creates a federated identity credential for the "pve-k3s-qa" workspace "apply" run phase.
resource "azuread_application_federated_identity_credential" "pve-k3s-qa_apply" {
  application_id = azuread_application.hcpt_application.id
  display_name   = "pve-k3s-qa-apply"
  audiences      = [var.hcpt_azure_audience]
  issuer         = "https://${var.hcpt_hostname}"
  subject        = "organization:${var.hcpt_organization_name}:project:${var.hcpt_project_name}:workspace:pve-k3s-qa:run_phase:apply"
  depends_on     = [azuread_application.hcpt_application]
}
