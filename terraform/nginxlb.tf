# # Create Resource Group
# resource "azurerm_resource_group" "aks" {
#   name     = "${var.name_prefix}-rg"
#   location = var.location
# }

# Add Kubernetes Stable Helm charts repo
resource "helm_repository" "stable" {
  name = "stable"
  url  = "https://kubernetes-charts.storage.googleapis.com"
}

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
    name  = "controller.service.externalTrafficPolicy"
    value = "Local"
  }

  set {
    name  = "controller.service.loadBalancerIP"
    value = "${azurerm_public_ip.nginx_ingress.ip_address}"
  }
}
