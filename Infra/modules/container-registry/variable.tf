variable "resource_group_name" {
  description = "The name of the resource group."
  type        = string
}

variable "container_registry_name" {
  description = "The name of the Azure Container Registry."
  type        = string
}

variable "location" {
  description = "The Azure location where the container registry will be created."
  type        = string
}

variable "tags" {
  type        = map(string)
  description = "Tags to apply"
  default     = {}
}