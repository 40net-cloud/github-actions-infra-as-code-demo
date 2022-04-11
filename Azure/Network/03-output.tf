##############################################################################################################
#
# Fortinet
# Infrastructure As Code Demo
# GitHub Actions - Terraform Cloud
#
##############################################################################################################
#
# Output summary of deployment
#
##############################################################################################################

output "vnet" {
  value = var.vnet
}

output "vnet_subnet" {
  value = values(var.subnet)
}

output "vnet_subnet_id" {
  value = [azurerm_subnet.subnet1.id, azurerm_subnet.subnet2.id, azurerm_subnet.subnet3.id, azurerm_subnet.subnet4.id, azurerm_subnet.subnet5.id, azurerm_subnet.subnet6.id]
}

output "fgt_internalip" {
  value = var.fgt_internalip
}

##############################################################################################################
