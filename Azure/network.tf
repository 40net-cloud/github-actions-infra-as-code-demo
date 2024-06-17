##############################################################################################################
#
# Fortinet
# Infrastructure As Code Demo
# GitHub Actions - Terraform Cloud
# Platform: Azure
#
##############################################################################################################
#
# Deployment of the network infrastructure
#
##############################################################################################################

resource "azurerm_virtual_network" "vnet" {
  name                = "${var.PREFIX}-vnet"
  address_space       = [var.vnet]
  location            = azurerm_resource_group.resourcegroup.location
  resource_group_name = azurerm_resource_group.resourcegroup.name
}

resource "azurerm_subnet" "subnet1" {
  name                 = "${var.PREFIX}-subnet-fgt-external"
  resource_group_name  = azurerm_resource_group.resourcegroup.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = [var.subnet["1"]]
}

resource "azurerm_subnet" "subnet2" {
  name                 = "${var.PREFIX}-subnet-fgt-internal"
  resource_group_name  = azurerm_resource_group.resourcegroup.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = [var.subnet["2"]]
}

resource "azurerm_subnet" "subnet3" {
  name                 = "${var.PREFIX}-subnet-protected-a"
  resource_group_name  = azurerm_resource_group.resourcegroup.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = [var.subnet["3"]]
}

resource "azurerm_subnet" "subnet4" {
  name                 = "${var.PREFIX}-subnet-protected-b"
  resource_group_name  = azurerm_resource_group.resourcegroup.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = [var.subnet["4"]]
}

resource "azurerm_subnet_route_table_association" "subnet3rt" {
  subnet_id      = azurerm_subnet.subnet3.id
  route_table_id = azurerm_route_table.protectedaroute.id
}

resource "azurerm_route_table" "protectedaroute" {
  name                = "${var.PREFIX}-rt-protected-a"
  location            = var.LOCATION
  resource_group_name = azurerm_resource_group.resourcegroup.name

  route {
    name                   = "VirtualNetwork"
    address_prefix         = var.vnet
    next_hop_type          = "VirtualAppliance"
    next_hop_in_ip_address = var.fgt_ipaddress["2"]
  }
  route {
    name           = "Subnet"
    address_prefix = var.subnet["3"]
    next_hop_type  = "VnetLocal"
  }
  route {
    name                   = "Default"
    address_prefix         = "0.0.0.0/0"
    next_hop_type          = "VirtualAppliance"
    next_hop_in_ip_address = var.fgt_ipaddress["2"]
  }
}

resource "azurerm_subnet_route_table_association" "subnet4rt" {
  subnet_id      = azurerm_subnet.subnet4.id
  route_table_id = azurerm_route_table.protectedbroute.id
}

resource "azurerm_route_table" "protectedbroute" {
  name                = "${var.PREFIX}-rt-protected-b"
  location            = var.LOCATION
  resource_group_name = azurerm_resource_group.resourcegroup.name

  route {
    name                   = "VirtualNetwork"
    address_prefix         = var.vnet
    next_hop_type          = "VirtualAppliance"
    next_hop_in_ip_address = var.fgt_ipaddress["2"]
  }
  route {
    name           = "Subnet"
    address_prefix = var.subnet["4"]
    next_hop_type  = "VnetLocal"
  }
  route {
    name                   = "Default"
    address_prefix         = "0.0.0.0/0"
    next_hop_type          = "VirtualAppliance"
    next_hop_in_ip_address = var.fgt_ipaddress["2"]
  }
}

resource "azurerm_network_security_group" "fgtnsg" {
  name                = "${var.PREFIX}-fgt-nsg"
  location            = var.LOCATION
  resource_group_name = azurerm_resource_group.resourcegroup.name
}

resource "azurerm_network_security_rule" "fgtnsgallowallout" {
  name                        = "AllowAllOutbound"
  resource_group_name         = azurerm_resource_group.resourcegroup.name
  network_security_group_name = azurerm_network_security_group.fgtnsg.name
  priority                    = 100
  direction                   = "Outbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "*"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
}

resource "azurerm_network_security_rule" "fgtnsgallowallin" {
  name                        = "AllowAllInbound"
  resource_group_name         = azurerm_resource_group.resourcegroup.name
  network_security_group_name = azurerm_network_security_group.fgtnsg.name
  priority                    = 100
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "*"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
}
##############################################################################################################
