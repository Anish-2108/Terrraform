terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = "=3.0.0"
    }
  }
}

provider "azurerm" {
  features {
  }

  subscription_id   = "2c8f4502-a330-4e85-9858-5ac7d37b2019"
  tenant_id         = "cb77aef3-a720-4313-a825-6a8d5d19ed26"
  client_id         = "1bd22c10-a776-49f8-81ff-ddf4cb4de35c"
  client_secret     = "iR-8Q~jqw1JLm7ieM1pSIPYEaHCgrLTNBAIeSbp0"
}