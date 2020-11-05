variable "resourcename" {
  default = "identity-aks-rg"
}

variable "clustername" {
  default = "identity-aks"
}

variable "location" {
  type = string
  default = "westeurope"
}

variable "prefix" {
  type = string
  default = "dev-identity"
}

#variable "size" {
#  default = "Standard_D2_V2"
#}

#variable "agentnode" {
#  default = "2"
#}

variable "subscription_id" {
  description = "The Azure subscription ID."  
  default = ""
}
variable "client_id" {
  description = "The Azure Service Principal app ID."
  default = ""
}
variable "client_secret" {
  description = "The Azure Service Principal password."
  default = ""
}
variable "tenant_id" {
  description = "The Azure Tenant ID."
  default = ""
}

variable "ssh_key" {
  type = string
  default = ""
}
