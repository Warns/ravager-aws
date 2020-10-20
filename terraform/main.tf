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

terraform {
  backend "azurerm" {
    resource_group_name   = "tstate"
    storage_account_name  = "tstatesociallme15315"
    container_name        = "tstate"
    access_key            = ""
    key                   = "terraform.tfstate"
  }
}
