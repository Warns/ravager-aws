# test contrib set
resource "azurerm_kubernetes_cluster" "aks" {
  name                = "${var.name_prefix}-aks"
  location            = azurerm_resource_group.aks.location
  resource_group_name = azurerm_resource_group.aks.name
  dns_prefix          = "${var.name_prefix}-dns"

  default_node_pool {
    name            = "identitynode"
    node_count      = 3
    vm_size         = "Standard_D2_v2"
    os_disk_size_gb = 30
  }

  # service_principal {
  #   client_id     = azurerm_azuread_application.aks.application_id
  #   client_secret = azurerm_azuread_service_principal_password.aks.value
  # }
# }

  service_principal {
    client_id     = var.client_id
    client_secret = var.client_secret
  }

  # linux_profile {
  #   admin_username = "dev"
  #   ssh_key {
  #     key_data = var.ssh-key
  #   }
 # }

  # network_profile {
  #   network_plugin = "kubenet"
  #   load_balancer_sku = "Standard"
  # }

# Create the virtual network for an AKS cluster
# module "network" {
#  source              = "Azure/network/azurerm"
#  resource_group_name = azurerm_resource_group.dev-rg.name
#  address_space       = "10.0.0.0/16"
## subnet
 subnet_prefixes     = ["10.0.1.0/24"]
 subnet_names        = ["subnet1"]
 depends_on          = [azurerm_resource_group.dev-identity]
}
