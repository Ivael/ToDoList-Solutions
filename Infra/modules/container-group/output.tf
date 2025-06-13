output "fqdn" {
  description = "Fully qualified domain name (from DNS label)"
  value       = azurerm_container_group.todo_api.fqdn
}

output "ip_address" {
  description = "IP address assigned to the container group"
  value       = azurerm_container_group.todo_api.ip_address
}