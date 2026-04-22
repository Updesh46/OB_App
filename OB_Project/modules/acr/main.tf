resource "azurerm_container_registry" "acr" {
  for_each = var.infra

  name                = each.value.acr.name
  resource_group_name = each.value.rg_name
  location            = each.value.location
  sku                 = each.value.acr.sku
  admin_enabled       = true
}

