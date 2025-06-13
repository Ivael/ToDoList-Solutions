variable "resource_group_name" {
  description = "The name of the resource group."
  type        = string
}

variable "resource_group_location" {
  description = "The Azure location where the resource group will be created."
  type        = string
}

variable "cosmos_account_name" {
  description = "The name of the Cosmos DB account."
  type        = string
}

variable "database_name" {
  description = "The name of the Cosmos DB database."
  type        = string
}

variable "location" {
  description = "The Azure location for the Cosmos DB account."
  type        = string
}

variable "consistency_level" {
  description = "The consistency level for the Cosmos DB account."
  type        = string
  default     = "Session" # Options: Eventual, ConsistentPrefix, BoundedStaleness, Session, Strong
}

variable "throughput" {
  description = "The throughput for the Cosmos DB collection in RU/s."
  type        = number
  default     = 400 # Default value, can be adjusted based on needs
}

variable "collection_name" {
  description = "The name of the Cosmos DB collection."
  type        = string
}

