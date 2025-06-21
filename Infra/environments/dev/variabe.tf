variable "subscription_id" {
  description = "Azure subscription ID for the resources"
  type        = string
}

variable "location" {
  description = "Azure region for resources"
  type        = string
}
variable "resource_group_name" {
  description = "Name of the main resource group"
  type        = string
}
variable "tags" {
  description = "Common tags for all resources"
  type        = map(string)
}

# ACR
variable "acr_name" {
  type = string
}

variable "cluster_name" {
  description = "Name of the AKS cluster"
  type        = string
}

variable "vm_size" {
  description = "VM size for the AKS nodes"
  type        = string
}
