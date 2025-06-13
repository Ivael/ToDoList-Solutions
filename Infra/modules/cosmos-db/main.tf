resource "azurerm_cosmosdb_account" "cosmosdb" {
  name                = var.cosmos_account_name
  resource_group_name = var.resource_group_name
  location            = var.location
  offer_type          = "Standard"
  kind                = "MongoDB" # or “GlobalDocumentDB” for SQL API
  consistency_policy {
    consistency_level = var.consistency_level
  }

  # Throughput settings can be scaled up/down later or using autoscale
  geo_location {
    location          = var.location
    failover_priority = 0
  }

}

resource "azurerm_cosmosdb_mongo_database" "db" {
  name                = var.database_name
  resource_group_name = var.resource_group_name
  account_name        = azurerm_cosmosdb_account.cosmosdb.name
}

resource "azurerm_cosmosdb_mongo_collection" "todos_collection" {
  name                = var.collection_name
  resource_group_name = var.resource_group_name
  account_name        = azurerm_cosmosdb_account.cosmosdb.name
  database_name       = azurerm_cosmosdb_mongo_database.db.name

  # You can configure indexing policy, throughput, etc.
  throughput = var.throughput
   index {
    keys   = ["_id"]
    unique = true
  }
}

