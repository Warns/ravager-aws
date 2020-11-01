# Set default name prefix
variable "name_prefix" {
  default = "k8s-cluster"
}

# Set default location
variable "location" {
  default = "westeurope"
}

# Create Resource Group
resource "azurerm_resource_group" "aks" {
  name     = "${var.name_prefix}-rg"
  location = "${var.location}"
}

# Create Azure AD Application for Service Principal
resource "azurerm_azuread_application" "aks" {
  name = "${var.name_prefix}-sp"
}

# Create Service Principal
resource "azurerm_azuread_service_principal" "aks" {
  application_id = "${azurerm_azuread_application.aks.application_id}"
}


