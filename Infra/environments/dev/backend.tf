terraform {
  required_version = ">= 1.2.0"
  backend "azurerm" {
    resource_group_name  = "rg-todo-dev-tfstate"
    storage_account_name = "sttodotfstatedev"
    container_name       = "tfstate"
    key                  = "dev.terraform.tfstate"
  }
}


