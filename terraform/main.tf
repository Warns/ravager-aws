provider "azurerm" {
  version = "=2.20.0"
}

# Create a resource group
resource "azurerm_resource_group" "wagtail" {
  name     = "wagtail-playground"
  location = var.location
}
