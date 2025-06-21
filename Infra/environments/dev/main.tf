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

# environments/dev/aks.tf
module "aks" {
  source              = "../../modules/aks"
  cluster_name        = var.cluster_name
  resource_group_name = module.rg.resource_group_name
  location            = module.rg.location
  dns_prefix          = "tododev"
  node_count          = 1
  vm_size             = "Standard_B2s"
  tags                = var.tags
}

