
output "private_endpoint_subnet_id" {
  value = {
    for k, v in azurerm_subnet.private_endpoint : k => v.id
  }
}

output "agw_subnet_id" {
  value = {
    for k, v in azurerm_subnet.agw : k => v.id
  }
}

output "spoke_vnet_id" {
  description = "Spoke Virtual Network ID"
  value = {
    for k, v in azurerm_virtual_network.spoke : k => v.id
  }
}