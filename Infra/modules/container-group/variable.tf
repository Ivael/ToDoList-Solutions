variable "name" {
  description = "Name of the container group"
  type        = string
}

variable "resource_group_name" {
  description = "Resource Group for the container group"
  type        = string
}

variable "location" {
  description = "Azure region"
  type        = string
}

variable "container_name" {
  description = "Name of the container inside the group"
  type        = string
}

variable "image" {
  description = "Container image (e.g. <acr>.azurecr.io/backend:tag)"
  type        = string
}

variable "cpu" {
  description = "vCPU allocation"
  type        = number
  default     = 0.5
}

variable "memory" {
  description = "Memory in GB"
  type        = number
  default     = 1.5
}

variable "port" {
  description = "Port to expose"
  type        = number
  default     = 80
}

variable "dns_name_label" {
  description = "Unique DNS label for public access"
  type        = string
}

variable "ip_address_type" {
  description = "Public or Private IP"
  type        = string
  default     = "Public"
}

variable "environment_variables" {
  description = "Map of environment variables for the container"
  type        = map(string)
  default     = {}
}

variable "tags" {
  description = "Tags to apply"
  type        = map(string)
  default     = {}
}

