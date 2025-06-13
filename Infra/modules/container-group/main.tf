resource "azurerm_container_group" "todo_api" {
  name                = var.name
  location            = var.location
  resource_group_name = var.resource_group_name
  os_type             = "Linux"

  container {
    name   = var.container_name
    image  = var.image
    cpu    = var.cpu
    memory = var.memory

    ports {
      port     = var.port
      protocol = "TCP"
    }

    environment_variables = var.environment_variables
  }

  ip_address_type = var.ip_address_type
  dns_name_label  = var.dns_name_label

  tags = var.tags
}
