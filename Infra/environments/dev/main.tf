# 1. Resource Group
module "rg" {
  source              = "../../modules/resource-group"
  resource_group_name = var.resource_group_name
  location            = var.location
  tags                = var.tags
}

# 2. Container Registry
module "acr" {
  source                  = "../../modules/container-registry"
  container_registry_name = var.acr_name
  resource_group_name     = module.rg.resource_group_name
  location                = module.rg.location
  tags                    = var.tags
}

# 3. Application Insights
module "app_insights" {
  source              = "../../modules/app-insights"
  ai_name                = var.ai_name
  location            = module.rg.location
  resource_group_name = module.rg.resource_group_name
  tags                = var.tags
}

# 4. Cosmos DB
module "cosmos" {
  source                  = "../../modules/cosmos-db"
  cosmos_account_name     = var.cosmos_account_name
  resource_group_name     = module.rg.resource_group_name
  resource_group_location = module.rg.location
  location                = module.rg.location
  database_name           = var.cosmos_db_name
  collection_name         = var.cosmos_collection_name
}

# 5. Container Group (API)
module "api_cg" {
  source              = "../../modules/container-group"
  name                = var.api_container_group_name
  resource_group_name = module.rg.resource_group_name
  location            = module.rg.location
  container_name      = var.api_container_name
  image               = var.api_image
  cpu                 = 0.5
  memory              = 1.5
  port                = 3000
  dns_name_label      = var.api_dns_label
  environment_variables = {
    COSMOS_ENDPOINT = module.cosmos.COSMOS_ENDPOINT
    COSMOS_KEY      = module.cosmos.COSMOS_PRIMARY_KEY
    APPINSIGHTS_KEY = module.app_insights.app_insights_instrumentation_key
  }
  tags = var.tags
}

# 6. Static Web App (Frontend)
module "swa" {
  source                  = "../../modules/static-web-app"
  static_web_app_name     = var.swa_name
  resource_group_name     = module.rg.resource_group_name
  resource_group_location = module.rg.location
  app_location            = var.swa_app_location
  api_location            = "" # Set to your API location if needed
  #github_repo_url         = var.github_repo_url
  #github_branch           = var.github_branch
  #github_token            = var.github_token
}