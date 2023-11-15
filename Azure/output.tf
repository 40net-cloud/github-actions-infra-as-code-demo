##############################################################################################################
#
# Fortinet
# Infrastructure As Code Demo
# GitHub Actions - Terraform Cloud
# Platform: Azure
#
##############################################################################################################
#
# Output summary of deployment
#
##############################################################################################################

output "deployment_summary" {
  value = templatefile("${path.module}/summary.tpl", {
    username                   = var.USERNAME,
    location                   = var.LOCATION,
    fgt_public_ip_address      = data.azurerm_public_ip.fgtpip.ip_address,
    fgt_public_fqdn            = data.azurerm_public_ip.fgtpip.fqdn,
    fgt_private_ip_address_ext = azurerm_network_interface.fgtifcext.private_ip_address,
    fgt_private_ip_address_int = azurerm_network_interface.fgtifcint.private_ip_address
  })
}

output "ansible_inventory" {
  value = templatefile("${path.module}/ansible.tpl", {
    username              = var.USERNAME,
    password              = var.PASSWORD,
    location              = var.LOCATION,
    fgt_public_ip_address = data.azurerm_public_ip.fgtpip.ip_address,
    fgt_public_fqdn       = data.azurerm_public_ip.fgtpip.fqdn,
    fgt_hostname          = "${var.PREFIX}-FGT-VM"
  })
}
##############################################################################################################
