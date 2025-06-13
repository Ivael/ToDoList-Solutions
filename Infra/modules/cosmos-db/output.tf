output "COSMOS_ENDPOINT" {
  description = "The endpoint of the Cosmos DB account"
  value       = azurerm_cosmosdb_account.cosmosdb.endpoint
}

output "COSMOS_PRIMARY_KEY" {
  description = "The primary key of the Cosmos DB account"
  value       = azurerm_cosmosdb_account.cosmosdb.primary_key
}