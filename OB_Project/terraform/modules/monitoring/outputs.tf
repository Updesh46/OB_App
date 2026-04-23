output "log_workspace_id" {
  value = {
    for k, v in azurerm_log_analytics_workspace.log : k => v.id
  }
}