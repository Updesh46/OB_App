# 1️⃣ Data block
data "azurerm_client_config" "current" {}

# 2️⃣ Key Vault
resource "azurerm_key_vault" "kv" {
  for_each = var.infra
  name                = each.value.keyvault.name
  location            = each.value.location
  resource_group_name = each.value.rg_name
  tenant_id           = data.azurerm_client_config.current.tenant_id
  sku_name            = "standard"
  
}

# 3️⃣ Private Endpoint
resource "azurerm_private_endpoint" "kv_pe" {
  for_each = var.infra

  name                = "kv-pe-${each.key}"
  location            = each.value.location
  resource_group_name = each.value.rg_name

  subnet_id = var.subnet_id[each.key]

  private_service_connection {
    name                           = "kv-connection"
    private_connection_resource_id = azurerm_key_vault.kv[each.key].id
    subresource_names              = ["vault"]
    is_manual_connection           = false
  }
}