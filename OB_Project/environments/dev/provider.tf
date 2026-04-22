terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "4.58.0"
    }
  }
}


provider "azurerm" {
  features {}
  subscription_id = "34ecbd71-b5db-4680-9758-b1c7dbb4831c"
}



# #  Alias provider
# provider "azurerm" {
#   alias           = "dev"
#   features        {}
#   subscription_id = "DEV_SUB_ID"
# }

# provider "azurerm" {
#   alias           = "prod"
#   features        {}
#   subscription_id = "PROD_SUB_ID"
# }

