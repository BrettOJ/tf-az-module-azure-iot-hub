terraform {
  required_version = ">= 1.5.4"
}
terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = "3.67.0"
    }
  }
}

provider "azurerm" {
  storage_use_azuread        = false
  use_msi                    = false
  skip_provider_registration = false
  tenant_id            = ""
  subscription_id      = ""
   features {}
}