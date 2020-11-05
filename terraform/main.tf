provider "azurerm" {
  version = "=2.20.0"
  subscription_id = var.subscription_id
  client_id       = var.client_id
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

# this has been creating by following https://www.terraform.io/docs/backends/types/azurerm.html
# to properly create the state do apply first without plan
terraform {
  backend "azurerm" {
    resource_group_name   = "tstate"
    storage_account_name  = "tstatesociallme15315"
    container_name        = "tstate"
    access_key            = ""
    key                   = "terraform.tfstate"
  }
}
