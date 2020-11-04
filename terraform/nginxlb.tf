# # Create Resource Group
# resource "azurerm_resource_group" "aks" {
#   name     = "${var.name_prefix}-rg"
#   location = var.location
# }

# # Create Azure AD Application for Service Principal
# resource "azuread_application" "aks" {
#   name = "${var.name_prefix}-sp"
# }

# Install Nginx Ingress using Helm Chart
resource "helm_release" "nginx_ingress" {
  name       = "nginx-ingress"
  repository = "${helm_repository.stable.metadata.0.name}"
  chart      = "nginx-ingress"

  set {
    name  = "rbac.create"
    value = "false"
  }

  set {
    name  = "controller.service.loadBalancerIP"
    value = "${azurerm_public_ip.nginx_ingress.ip_address}"
  }
}
