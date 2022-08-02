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

resource "azurerm_virtual_network" "vnet" {
  name                = "${var.PREFIX}-VNET"
  address_space       = [var.vnet]
  location            = azurerm_resource_group.resourcegroup.location
  resource_group_name = azurerm_resource_group.resourcegroup.name
}

resource "azurerm_subnet" "subnet1" {
  name                 = "${var.PREFIX}-SUBNET-FGT-EXTERNAL"
  resource_group_name  = azurerm_resource_group.resourcegroup.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = [var.subnet["1"]]
}

resource "azurerm_subnet" "subnet2" {
  name                 = "${var.PREFIX}-SUBNET-FGT-INTERNAL"
  resource_group_name  = azurerm_resource_group.resourcegroup.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = [var.subnet["2"]]
}

resource "azurerm_subnet" "subnet3" {
  name                 = "GatewaySubnet"
  resource_group_name  = azurerm_resource_group.resourcegroup.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = [var.subnet["3"]]
}

resource "azurerm_subnet" "subnet4" {
  name                 = "${var.PREFIX}-Management"
  resource_group_name  = azurerm_resource_group.resourcegroup.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = [var.subnet["4"]]
}

resource "azurerm_subnet" "subnet5" {
  name                 = "${var.PREFIX}-SUBNET-PROTECTED-A"
  resource_group_name  = azurerm_resource_group.resourcegroup.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = [var.subnet["5"]]
}

resource "azurerm_subnet" "subnet6" {
  name                 = "${var.PREFIX}-SUBNET-PROTECTED-B"
  resource_group_name  = azurerm_resource_group.resourcegroup.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = [var.subnet["6"]]
}

##############################################################################################################
# Azure VPN Gateway
#
# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/virtual_network_gateway
#
##############################################################################################################

resource "azurerm_local_network_gateway" "onpremise" {
  name                = "${var.PREFIX}-VPN-Sophia"
  location            = azurerm_resource_group.resourcegroup.location
  resource_group_name = azurerm_resource_group.resourcegroup.name
  gateway_fqdn        = "gorgon.jvh.be"
  address_space       = ["172.16.251.0/24"]
}

resource "azurerm_public_ip" "vpnpip" {
  name                = "${var.PREFIX}-VPN-PIP"
  location            = azurerm_resource_group.resourcegroup.location
  resource_group_name = azurerm_resource_group.resourcegroup.name
  allocation_method   = "Dynamic"
}

resource "azurerm_virtual_network_gateway" "vpngw" {
  name                = "${var.PREFIX}-VPN-GW"
  location            = azurerm_resource_group.resourcegroup.location
  resource_group_name = azurerm_resource_group.resourcegroup.name

  type     = "Vpn"
  vpn_type = "RouteBased"

  active_active = false
  enable_bgp    = false
  sku           = "VpnGw1"

  ip_configuration {
    public_ip_address_id          = azurerm_public_ip.vpnpip.id
    private_ip_address_allocation = "Dynamic"
    subnet_id                     = azurerm_subnet.subnet3.id
  }
}

resource "azurerm_virtual_network_gateway_connection" "onpremise" {
  name                = "toOnPremise"
  location            = azurerm_resource_group.resourcegroup.location
  resource_group_name = azurerm_resource_group.resourcegroup.name

  type                       = "IPsec"
  virtual_network_gateway_id = azurerm_virtual_network_gateway.vpngw.id
  local_network_gateway_id   = azurerm_local_network_gateway.onpremise.id

  shared_key = var.VPN_PSK
}

##############################################################################################################
