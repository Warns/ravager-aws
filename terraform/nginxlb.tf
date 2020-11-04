# Create Static Public IP Address to be used by Nginx Ingress
resource "azurerm_public_ip" "nginx_ingress" {
  name                         = "nginx-ingress-pip"
  location                     = "${azurerm_kubernetes_cluster.aks.location}"
  resource_group_name          = "${azurerm_kubernetes_cluster.aks.node_resource_group}"
  public_ip_address_allocation = "static"
  domain_name_label            = "${var.name_prefix}"
}

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
