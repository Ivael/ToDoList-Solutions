variable "ai_name" {
  description = "App Insights resource name"
  type        = string
}
variable "location" {
  description = "Azure region for AI"
  type        = string
}
variable "resource_group_name" {
  description = "RG name"
  type        = string
}
variable "tags" {
  description = "Tags map"
  type        = map(string)
  default     = {}
}
