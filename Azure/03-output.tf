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

data "template_file" "summary" {
  template = file("${path.module}/summary.tpl")

  vars = {
    username                   = var.USERNAME
    location                   = var.LOCATION
    fgt_public_ip_address      = data.azurerm_public_ip.fgtpip.ip_address
    fgt_public_fqdn            = data.azurerm_public_ip.fgtpip.fqdn
    fgt_private_ip_address_ext = azurerm_network_interface.fgtifcext.private_ip_address
    fgt_private_ip_address_int = azurerm_network_interface.fgtifcint.private_ip_address
  }
}

output "deployment_summary" {
  value = data.template_file.summary.rendered
}
