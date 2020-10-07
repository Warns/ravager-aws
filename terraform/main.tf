provider "azurerm" {
  version = "=2.20.0"
}

# create resource group
resource "azurerm_resource_group" "dev-rg" {
  name = "dev-identity-rg"
  location = var.location
  tags = {
    env = "dev-identity-rg"
    source = "sociallme"
  }
}
