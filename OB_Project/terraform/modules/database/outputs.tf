output "sqlserver_id" {
  description = "SQL Server IDs"
  value = {
    for k, v in azurerm_mssql_server.sqlserver : k => v.id
  }
}

output "sqlserver_fqdn" {
  description = "SQL Server FQDNs"
  value = {
    for k, v in azurerm_mssql_server.sqlserver : k => v.fully_qualified_domain_name
  }
}

output "database_ids" {
  description = "SQL Database IDs (format: env-db_key => id)"
  value = {
    for k, v in azurerm_mssql_database.sqldatabase : k => v.id
  }
}

output "private_endpoint_id" {
  description = "Private Endpoint IDs"
  value = {
    for k, v in azurerm_private_endpoint.sqlserver_pe : k => v.id
  }
}

output "private_endpoint_ip" {
  description = "Private Endpoint IP Addresses"
  value = {
    for k, v in azurerm_private_endpoint.sqlserver_pe : k => v.private_service_connection[0].private_ip_address
  }
}
