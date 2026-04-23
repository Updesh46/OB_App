resource "azurerm_kubernetes_cluster" "aks" {
  for_each = var.infra

  name                = each.value.aks.name
  location            = each.value.location
  resource_group_name = each.value.rg_name
  dns_prefix          = each.value.aks.name

  oidc_issuer_enabled = true

  default_node_pool {
    name       = "nodepool"
    node_count = each.value.aks.node_count
    vm_size    = each.value.aks.vm_size
  }

  identity {
    type = "SystemAssigned"
  }

  network_profile {
    network_plugin = "azure"
  }

  oms_agent {
    log_analytics_workspace_id = var.log_workspace_id[each.key]
  }
}


#  ACR Pull Permission (AKS  to ACR)


resource "azurerm_role_assignment" "acr_pull" {
  for_each = var.infra

  principal_id         = azurerm_kubernetes_cluster.aks[each.key].kubelet_identity[0].object_id
  role_definition_name = "AcrPull"
  scope                = var.acr_id[each.key]
}