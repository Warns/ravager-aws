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

#   agent_pool_profile {
#     name            = "linuxpool"
#     count           = 3
#     vm_size         = "Standard_DS2_v2"
#     os_type         = "Linux"
#     os_disk_size_gb = 30
#   }

# service_principal {
#   client_id     = azurerm_azuread_application.aks.application_id
#   client_secret = azurerm_azuread_service_principal_password.aks.value
# }
# }

# Initialize Helm (and install Tiller)
provider "helm" {
  #  install_tiller = true