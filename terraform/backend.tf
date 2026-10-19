terraform {
  backend "azurerm" {
    resource_group_name  = "rg-iac-tfstate"
    storage_account_name = "stiactfstate1234"
    container_name       = "tfstate"
    key                  = "iac-foundation/dev.tfstate"
    use_azuread_auth     = true
  }
}