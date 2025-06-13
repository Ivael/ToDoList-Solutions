resource "azurerm_key_vault" "kv" {
  name                       = var.key_vault_name
  resource_group_name        = var.resource_group_name
  location                   = var.location
  tenant_id                  = var.tenant_id
  sku_name                   = "standard"
  soft_delete_retention_days = 7

  access_policy {
    tenant_id = var.tenant_id
    object_id = var.admin_object_id # typically your DevOps SP or your user during development
    secret_permissions = [
      "get", "list", "set", "delete"
    ]
  }

  tags = var.tags
}

resource "azurerm_key_vault_secret" "cosmos_primary_key" {
  name         = var.cosmos_primary_key
  value        = var.cosmos_primary_key
  key_vault_id = azurerm_key_vault.kv.id
}


