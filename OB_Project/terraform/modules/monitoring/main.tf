resource "azurerm_log_analytics_workspace" "log" {
  for_each = var.infra

  name                = each.value.monitoring.name
  location            = each.value.location
  resource_group_name = each.value.rg_name
  sku                 = "PerGB2018"
}