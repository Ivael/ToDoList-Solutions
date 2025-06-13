output "resource_group_name" {
  value = azurerm_resource_group.TodoListResourceGroup.name
}

output "location" {
  value = azurerm_resource_group.TodoListResourceGroup.location
}
