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


