# Data blocks to read secrets
data "azurerm_key_vault_secret" "db_admin_username" {
  for_each = var.infra

  name         = "db-admin-username"
  key_vault_id = var.key_vault_id[each.key]
}

data "azurerm_key_vault_secret" "db_admin_password" {
  for_each = var.infra

  name         = "db-admin-password"
  key_vault_id = var.key_vault_id[each.key]
}

data "azurerm_key_vault_secret" "db_server_name" {
  for_each = var.infra

  name         = "db-server-name"
  key_vault_id = var.key_vault_id[each.key]
}

# Azure SQL Server 
resource "azurerm_mssql_server" "sqlserver" {
  for_each = var.infra

  name                         = data.azurerm_key_vault_secret.db_server_name[each.key].value
  resource_group_name          = each.value.rg_name
  location                     = each.value.location
  version                      = "12.0"
  administrator_login          = data.azurerm_key_vault_secret.db_admin_username[each.key].value
  administrator_login_password = data.azurerm_key_vault_secret.db_admin_password[each.key].value

  tags = {
    Environment = each.key
    Managed_By  = "Terraform"
  }
}

# SQL Databases 
resource "azurerm_mssql_database" "sqldatabase" {
  for_each = merge([
    for env_key, env_val in var.infra : {
      for db_key, db_val in env_val.databases : "${env_key}-${db_key}" => {
        env_key = env_key
        db_key  = db_key
        env_val = env_val
        db_val  = db_val
      }
    }
  ]...)

  name           = each.value.db_val.database_name
  server_id      = azurerm_mssql_server.sqlserver[each.value.env_key].id
  collation      = "SQL_Latin1_General_CP1_CI_AS"
  license_type   = "LicenseIncluded"
  sku_name       = each.value.db_val.sku_name
  zone_redundant = false

  tags = {
    Environment = each.value.env_key
    Database    = each.value.db_key
    Managed_By  = "Terraform"
  }
}

# Firewall Rule
resource "azurerm_mssql_firewall_rule" "azure_services" {
  for_each = var.infra

  name             = "AllowAzureServices-${each.key}"
  server_id        = azurerm_mssql_server.sqlserver[each.key].id
  start_ip_address = "0.0.0.0"
  end_ip_address   = "0.0.0.0"
}

# Private Endpoint for SQL Server
resource "azurerm_private_endpoint" "sqlserver_pe" {
  for_each = var.infra

  name                = "${data.azurerm_key_vault_secret.db_server_name[each.key].value}-pe"
  location            = each.value.location
  resource_group_name = each.value.rg_name
  subnet_id           = var.subnet_id[each.key]

  private_service_connection {
    name                           = "${data.azurerm_key_vault_secret.db_server_name[each.key].value}-psc"
    private_connection_resource_id = azurerm_mssql_server.sqlserver[each.key].id
    subresource_names              = ["sqlServer"]
    is_manual_connection           = false
  }

  tags = {
    Environment = each.key
    Managed_By  = "Terraform"
  }
}

# Private DNS  for SQL Server

resource "azurerm_private_dns_zone" "sqlserver_dns" {
  for_each = var.infra

  name                = "privatelink-${each.key}.database.windows.net"
  resource_group_name = each.value.rg_name

  tags = {
    Environment = each.key
    Managed_By  = "Terraform"
  }
}

# Private DNS Link
resource "azurerm_private_dns_zone_virtual_network_link" "sqlserver_dns_link" {
  for_each = var.infra

  name                  = "${data.azurerm_key_vault_secret.db_server_name[each.key].value}-dns-link"
  private_dns_zone_name = azurerm_private_dns_zone.sqlserver_dns[each.key].name
  virtual_network_id    = var.vnet_id[each.key]
  resource_group_name   = each.value.rg_name
}

# Private DNS A Record
resource "azurerm_private_dns_a_record" "sqlserver_record" {
  for_each = var.infra

  name                = data.azurerm_key_vault_secret.db_server_name[each.key].value
  zone_name           = azurerm_private_dns_zone.sqlserver_dns[each.key].name
  resource_group_name = each.value.rg_name
  ttl                 = 3600
  records             = [azurerm_private_endpoint.sqlserver_pe[each.key].private_service_connection[0].private_ip_address]
}
