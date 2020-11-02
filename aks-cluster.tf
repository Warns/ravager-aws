resource "random_pet" "prefix" {}

provider "azurerm" {
  version = "~> 2.0"
  features {""}
}

# this should be changed to proper region
resource "azurerm_resource_group" "ims" {
  name     = "${random_pet.prefix.id}-rg"
  location = "westeurope"

  tags = {
    environment = "develop"
  }
}

# create cluster
resource "azurerm_kubernetes_cluster" "ims" {
  name                = "${random_pet.prefix.id}-aks"
  location            = azurerm_resource_group.ims.location
  resource_group_name = azurerm_resource_group.ims.name
  dns_prefix          = "${random_pet.prefix.id}-k8s"

# Cluster specifications >>
  default_node_pool {
    name            = "ims"
    node_count      = 3
    vm_size         = "Standard_D2_v2"
    os_disk_size_gb = 50
  }

  service_principal {
    client_id     = var.appId
    client_secret = var.password
  }

# rbac
  role_based_access_control {
    enabled = true
  }

  tags = {
    environment = "Develop"
  }
}
