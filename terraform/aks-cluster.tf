resource "azurerm_kubernetes_cluster" "dev-identity" {
  name                = "${var.prefix}-aks"
  location            = var.location
  resource_group_name = azurerm_resource_group.dev-rg.name
  dns_prefix          = "${var.prefix}-dns"

  default_node_pool {
    name            = "dev-indentity-node"
    node_count      = 2
    vm_size         = "Standard_D2_v2"
    os_disk_size_gb = 30
  }

  service_principal {
    client_id     = var.appId
    client_secret = var.password
  }

  role_based_access_control {
    enabled = true
  }

  tags = {
    environment = "Dev Identity Service K8s"
  }
}
