##############################################################################################################
#
# Fortinet
# Infrastructure As Code Demo
# GitHub Actions - Terraform Cloud
#
##############################################################################################################
#
# Deployment of the network infrastructure
#
##############################################################################################################

resource "azurerm_subnet_route_table_association" "subnet5rt" {
  subnet_id      = data.tfe_outputs.network.values.vnet_subnet_id[4]
  route_table_id = azurerm_route_table.protectedaroute.id
}

resource "azurerm_route_table" "protectedaroute" {
  name                = "${var.PREFIX}-RT-PROTECTED-A"
  location            = var.LOCATION
  resource_group_name = azurerm_resource_group.resourcegroup.name

  route {
    name                   = "VirtualNetwork"
    address_prefix         = data.tfe_outputs.network.values.vnet
    next_hop_type          = "VirtualAppliance"
    next_hop_in_ip_address = var.fgt_ipaddress[1]
  }
  route {
    name           = "Subnet"
    address_prefix = data.tfe_outputs.network.values.vnet_subnet[4]
    next_hop_type  = "VnetLocal"
  }
  route {
    name                   = "Default"
    address_prefix         = "0.0.0.0/0"
    next_hop_type          = "VirtualAppliance"
    next_hop_in_ip_address = var.fgt_ipaddress[1]
  }
}

resource "azurerm_subnet_route_table_association" "subnet6rt" {
  subnet_id      = data.tfe_outputs.network.values.vnet_subnet_id[5]
  route_table_id = azurerm_route_table.protectedbroute.id
}

resource "azurerm_route_table" "protectedbroute" {
  name                = "${var.PREFIX}-RT-PROTECTED-B"
  location            = var.LOCATION
  resource_group_name = azurerm_resource_group.resourcegroup.name

  route {
    name                   = "VirtualNetwork"
    address_prefix         = data.tfe_outputs.network.values.vnet
    next_hop_type          = "VirtualAppliance"
    next_hop_in_ip_address = var.fgt_ipaddress[1]
  }
  route {
    name           = "Subnet"
    address_prefix = data.tfe_outputs.network.values.vnet_subnet[5]
    next_hop_type  = "VnetLocal"
  }
  route {
    name                   = "Default"
    address_prefix         = "0.0.0.0/0"
    next_hop_type          = "VirtualAppliance"
    next_hop_in_ip_address = var.fgt_ipaddress[1]
  }
}

##############################################################################################################
