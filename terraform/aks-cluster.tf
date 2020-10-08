resource "azurerm_kubernetes_cluster" "dev-identity" {
  name                = "${var.prefix}-aks"
  location            = var.location
  resource_group_name = azurerm_resource_group.dev-rg.name
  dns_prefix          = "${var.prefix}-dns"

  linux_profile {
    admin_username = "dev"

    ssh_key {
      key_data = file(var.ssh_public_key)
    }
  }

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

module "network" {
  source = "Azure/network/azurerm"
  resource_group_name = "azurerm_resource_group.dev-rg.name
  address_space = "10.0.0.0/16"
  subnet_prefixes = ["10.0.1.0/24"]
  subnet_names = ["subnet1"]
  depends_on = [azurerm_resource_group.dev-identity]