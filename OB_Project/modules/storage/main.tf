resource "azurerm_storage_account" "st" {
  for_each = var.infra

  name                     = each.value.storage.name
  resource_group_name      = each.value.rg_name
  location                 = each.value.location
  account_tier             = "Standard"
  account_replication_type = "LRS"

  tags = {
    env = each.key
  }
}