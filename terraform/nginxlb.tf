# # Create Resource Group
# resource "azurerm_resource_group" "aks" {
#   name     = "${var.name_prefix}-rg"
#   location = var.location
# }

# # Create Azure AD Application for Service Principal
# resource "azuread_application" "aks" {
#   name = "${var.name_prefix}-sp"
# }

# # Create managed Kubernetes cluster (AKS)
# resource "azurerm_kubernetes_cluster" "aks" {
#   name                = "${var.name_prefix}-aks"
#   location            = azurerm_resource_group.aks.location
#   resource_group_name = azurerm_resource_group.aks.name
#   dns_prefix          = var.name_prefix
# # Change to match compliance
# # kubernetes_version  = "1.11.3"
