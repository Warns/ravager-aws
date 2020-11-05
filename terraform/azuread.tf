data "azurerm_subscription" "current" {}

data "azurerm_client_config" "config" {}

# Generate random string to be used for service principal password
resource "random_string" "password" {
  length  = 32
  special = true
}

