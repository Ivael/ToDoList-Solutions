output "static_site_default_hostname" {
  value       = azurerm_static_web_app.TodoListStaticWebApp.default_host_name
  description = "Default hostname (e.g. mytodoapp.azurestaticapps.net)"
}

output "static_site_url" {
  value       = "https://${azurerm_static_web_app.TodoListStaticWebApp.default_host_name}"
  description = "URL of the static web app (e.g. https://mytodoapp.azurestaticapps.net)"
}