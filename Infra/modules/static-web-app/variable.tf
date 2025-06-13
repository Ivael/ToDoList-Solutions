variable "resource_group_name" {
  description = "The name of the resource group."
  type        = string
}

variable "resource_group_location" {
  description = "The Azure location where the resource group will be created."
  type        = string
}

variable "static_web_app_name" {
  description = "The name of the Azure Static Web App."
  type        = string
}

variable "app_location" {
  description = "The location of the API within the repository."
  type        = string
}

variable "api_location" {
  description = "The location of the app within the repository."
  type        = string
}

#variable "github_branch" {
#  description = "The branch of the GitHub repository to deploy from."
#  type        = string
#}

#variable "github_repo_url" {
#  description = "The URL of the GitHub repository."
#  type        = string
#}

#variable "github_token" {
#  description = "The GitHub token for accessing the repository."
#  type        = string
#}

