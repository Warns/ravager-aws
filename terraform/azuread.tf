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

