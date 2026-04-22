
# HUB VNET

resource "azurerm_virtual_network" "hub" {
  for_each = var.infra

  name                = each.value.hub.vnet_name
  location            = each.value.location
  resource_group_name = each.value.rg_name
  address_space       = each.value.hub.address_space
}


# SPOKE VNET

resource "azurerm_virtual_network" "spoke" {
  for_each = var.infra

  name                = each.value.spoke.vnet_name
  location            = each.value.location
  resource_group_name = each.value.rg_name
  address_space       = each.value.spoke.address_space
}


#  AKS SUBNET (SPOKE)

resource "azurerm_subnet" "aks" {
  for_each = var.infra

  name                 = each.value.spoke.subnet_name
  resource_group_name  = each.value.rg_name
  virtual_network_name = each.value.spoke.vnet_name
  address_prefixes     = ["10.1.1.0/24"]
}

# FIREWALL SUBNET (HUB)

resource "azurerm_subnet" "firewall" {
  for_each = var.infra

  name                 = "AzureFirewallSubnet"   # fixed name
  resource_group_name  = each.value.rg_name
  virtual_network_name = azurerm_virtual_network.hub[each.key].name
  address_prefixes     = ["10.0.1.0/24"]
}


# PUBLIC IP FOR FIREWALL

resource "azurerm_public_ip" "fw_ip" {
  for_each = var.infra

  name                = "fw-ip-${each.key}"
  location            = each.value.location
  resource_group_name = each.value.rg_name
  allocation_method   = "Static"
  sku                 = "Standard"
}


# AZURE FIREWALL

resource "azurerm_firewall" "fw" {
  for_each = var.infra

  name                = "fw-${each.key}"
  location            = each.value.location
  resource_group_name = each.value.rg_name
  sku_name            = "AZFW_VNet"
  sku_tier            = "Standard"

  ip_configuration {
    name                 = "fw-config"
    subnet_id            = azurerm_subnet.firewall[each.key].id
    public_ip_address_id = azurerm_public_ip.fw_ip[each.key].id
  }
}


 # HUB → SPOKE PEERING

resource "azurerm_virtual_network_peering" "hub_to_spoke" {
  for_each = var.infra

  name                      = "hub-to-spoke-${each.key}"
  resource_group_name       = each.value.rg_name
  virtual_network_name      = azurerm_virtual_network.hub[each.key].name
  remote_virtual_network_id = azurerm_virtual_network.spoke[each.key].id

  allow_virtual_network_access = true
}


# ROUTE TABLE


resource "azurerm_route_table" "rt" {
  for_each = var.infra

  name                = "rt-${each.key}"
  location            = each.value.location
  resource_group_name = each.value.rg_name
}


# DEFAULT ROUTE → FIREWALL



resource "azurerm_route" "default" {
  for_each = var.infra

  name                   = "default-route"
  resource_group_name    = each.value.rg_name
  route_table_name       = azurerm_route_table.rt[each.key].name
  address_prefix         = "0.0.0.0/0"
  next_hop_type          = "VirtualAppliance"
  next_hop_in_ip_address = azurerm_firewall.fw[each.key].ip_configuration[0].private_ip_address
}



 # ROUTE TABLE ATTACH TO AKS SUBNET

 resource "azurerm_subnet_route_table_association" "assoc" {
  for_each = var.infra

  subnet_id      = azurerm_subnet.aks[each.key].id
  route_table_id = azurerm_route_table.rt[each.key].id
}


# PRIVATE ENDPOINT SUBNET (SPOKE)

resource "azurerm_subnet" "private_endpoint" {
  for_each = var.infra

  name                 = each.value.private_endpoint.subnet_name
  resource_group_name  = each.value.rg_name
  virtual_network_name = azurerm_virtual_network.spoke[each.key].name
  address_prefixes     = ["10.1.2.0/24"]

  private_endpoint_network_policies = "Disabled"
}

# APPLICATION GATEWAY SUBNET (SPOKE)

resource "azurerm_subnet" "agw" {
  for_each = var.infra

  name                 = "agw-subnet"
  resource_group_name  = each.value.rg_name
  virtual_network_name = azurerm_virtual_network.spoke[each.key].name
  address_prefixes     = ["10.1.3.0/24"]
}

