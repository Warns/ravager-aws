resource "azurerm_kubernetes_cluster" "dev-identity-k8s" {
  name                = var.clustername
  location            = azurerm_resource_group.dev-identity-k8s.location
  resource_group_name = azurerm_resource_group.dev-identity-k8s.name
  dns_prefix          = "${var.prefix}-dns"

  default_node_pool {
    name            = "identitynode"
    node_count      = 3
    vm_size         = "Standard_D2_v2"
    os_disk_size_gb = 30
  }

  service_principal {
    client_id     = var.client_id
    client_secret = var.client_secret
  }

  linux_profile {
    admin_username = "dev"
    ssh_key {
      key_data = var.ssh-key
    }
 }

  network_profile {
    network_plugin = "kubenet"
    load_balancer_sku = "Standard"
  }

  role_based_access_control {
    enabled = true
  }

  tags = {
    environment = "Dev Identity Service"
  }
}

# Create the virtual network for an AKS cluster
module "network" {
 source              = "Azure/network/azurerm"
 resource_group_name = azurerm_resource_group.dev-rg.name
 address_space       = "10.0.0.0/16"

}
