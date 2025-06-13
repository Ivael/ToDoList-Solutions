output "acr_login_server" {
  value       = azurerm_container_registry.TodoList-registry.login_server
  description = "The login server for the ACR (e.g. todolistacr.azurecr.io)"
}

output "acr_resource_id" {
  value       = azurerm_container_registry.TodoList-registry.id
  description = "Resource ID of ACR"
}
