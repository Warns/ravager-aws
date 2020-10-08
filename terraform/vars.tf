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
  default = ""
}
variable "client_id" {
  default = ""
}
variable "client_secret" {
  default = ""
}
variable "tenant_id" {
  default = ""
}

variable "ssh_key" {
  type = string
  default = ""
}
