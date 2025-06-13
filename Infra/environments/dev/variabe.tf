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
# Container Group (ACI)
variable "api_container_name" {
  type = string
}
variable "api_image" {
  type = string
}
variable "api_dns_label" {
  type = string
}

# Static Web App
variable "swa_name" {
  type = string
}

# Static Web App location
variable "swa_app_location" {
  description = "Location for the static web app"
  type        = string
}

# Cosmos DB
variable "cosmos_account_name" {
  type = string
}
variable "cosmos_db_name" {
  type = string
}
variable "cosmos_collection_name" {
  type = string
}

# Application Insights
variable "ai_name" {
  type = string
}

variable "api_container_group_name" {
  description = "Name of the API container group"
  type        = string
}

#variable "github_repo_url" {
#  description = "GitHub repository URL for the static web app"
#  type        = string
#}

#variable "github_branch" {
#  description = "GitHub branch for the static web app"
#  type        = string
#}

#variable "github_token" {
#  description = "GitHub token for accessing the repository"
#  type        = string
#  sensitive   = true
#}