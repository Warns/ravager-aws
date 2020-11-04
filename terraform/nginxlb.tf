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

    kubernetes {
    host                   = azurerm_kubernetes_cluster.aks.kube_config.0.host
    client_certificate     = base64decode(azurerm_kubernetes_cluster.aks.kube_config.0.client_certificate)
    client_key             = base64decode(azurerm_kubernetes_cluster.aks.kube_config.0.client_key)
    cluster_ca_certificate = base64decode(azurerm_kubernetes_cluster.aks.kube_config.0.cluster_ca_certificate)
  }
}

# Create Static Public IP Address to be used by Nginx Ingress
resource "azurerm_public_ip" "nginx_ingress" {
  name                = "nginx-ingress-pip"
  location            = azurerm_kubernetes_cluster.aks.location
  resource_group_name = azurerm_kubernetes_cluster.aks.node_resource_group
  allocation_method   = "Static"
  domain_name_label   = var.name_prefix
}

# Add Kubernetes Stable Helm charts repo
resource "helm_repository" "stable" {
  name = "stable"
  url  = "https://kubernetes-charts.storage.googleapis.com"
}

# Install Nginx Ingress using Helm Chart
resource "helm_release" "nginx_ingress" {
  name       = "nginx-ingress"
  repository = helm_repository.stable.metadata.0.name
  chart      = "nginx-ingress"

}