resource "azurerm_static_web_app" "TodoListStaticWebApp" {
  name                = var.static_web_app_name
  location            = var.resource_group_location
  resource_group_name = var.resource_group_name


  sku_tier            = "Free"
  sku_size            = "Free"
  #repository_url    = var.github_repo_url
  #repository_branch = var.github_branch
  #repository_token  = var.github_token
}