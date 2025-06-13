output "app_insights_instrumentation_key" {
  value       = azurerm_application_insights.app_insights.instrumentation_key
  description = "Instrumentation Key for your Node.js/Express"
  sensitive   = true
}

output "app_insights_app_id" {
  value       = azurerm_application_insights.app_insights.app_id
  description = "App Insights Application ID (for queries)"
}

