data "azurerm_subscription" "current" {}

data "azurerm_client_config" "config" {}

# Generate random string to be used for service principal password
resource "random_string" "password" {
  length  = 32
  special = true
}

resource "azuread_application" "aks" {
  name = "${var.name_prefix}-sp"
}

resource "azuread_service_principal" "aks" {
  application_id = azuread_application.aks.application_id
}

# Create service principal password
resource "azuread_service_principal_password" "sp-password" {
  end_date             = "2299-12-30T23:00:00Z" #forever
  service_principal_id = azuread_service_principal.aks.id
  value                = random_string.password.result
}

resource "azurerm_role_assignment" "contributer" {
  scope                = data.azurerm_subscription.current.id
  role_definition_name = "Contributer"
  principal_id         = data.azurerm_client_config.config.object_id
}