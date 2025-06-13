variable "resource_group_name" {
  description = "The name of the resource group."
  type        = string
}

variable "key_vault_name" {
  description = "The name of the Key Vault."
  type        = string
}

variable "location" {
  description = "The Azure location for the Key Vault."
  type        = string
}

variable "tenant_id" {
  description = "The Azure tenant ID."
  type        = string
}

variable "admin_object_id" {
  description = "The object ID of the admin user or service principal."
  type        = string
}

variable "tags" {
  description = "Tags to apply to the Key Vault."
  type        = map(string)
  default     = {}
}

variable "cosmos_primary_key" {
  description = "The primary key for the Cosmos DB account, stored as a secret in Key Vault."
  type        = string
  sensitive   = true
}