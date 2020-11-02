# Set default name prefix
variable "name_prefix" {
  default = "k8s-cluster"
}

# Set default location
variable "location" {
  default = "westeurope"
}

# Create Resource Group
resource "azurerm_resource_group" "aks" {
  name     = "${var.name_prefix}-rg"
  location = "${var.location}"
}

# Create Azure AD Application for Service Principal
resource "azurerm_azuread_application" "aks" {
  name = "${var.name_prefix}-sp"
}

# Create Service Principal
resource "azurerm_azuread_service_principal" "aks" {
  application_id = "${azurerm_azuread_application.aks.application_id}"
}

# Generate random string to be used for Service Principal Password
resource "random_string" "password" {
  length  = 32
  special = true
}

# Create Service Principal password
resource "azurerm_azuread_service_principal_password" "aks" {
  end_date             = "2299-12-30T23:00:00Z"                        # Forever
  service_principal_id = "${azurerm_azuread_service_principal.aks.id}"
  value                = "${random_string.password.result}"
}

# Create managed Kubernetes cluster (AKS)
resource "azurerm_kubernetes_cluster" "aks" {
  name                = "${var.name_prefix}-aks"
  location            = "${azurerm_resource_group.aks.location}"
  resource_group_name = "${azurerm_resource_group.aks.name}"
  dns_prefix          = "${var.name_prefix}"
  kubernetes_version  = "1.11.3"

  agent_pool_profile {
    name            = "linuxpool"
    count           = 1
    vm_size         = "Standard_DS2_v2"
    os_type         = "Linux"
    os_disk_size_gb = 30
  }

  service_principal {
    client_id     = "${azurerm_azuread_application.aks.application_id}"
    client_secret = "${azurerm_azuread_service_principal_password.aks.value}"
  }
}

# Initialize Helm (and install Tiller)
provider "helm" {
  install_tiller = true

  kubernetes {
    host                   = "${azurerm_kubernetes_cluster.aks.kube_config.0.host}"
    client_certificate     = "${base64decode(azurerm_kubernetes_cluster.aks.kube_config.0.client_certificate)}"
    client_key             = "${base64decode(azurerm_kubernetes_cluster.aks.kube_config.0.client_key)}"
    cluster_ca_certificate = "${base64decode(azurerm_kubernetes_cluster.aks.kube_config.0.cluster_ca_certificate)}"
  }
}

