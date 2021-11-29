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
    password                   = aws_instance.fgtvm.id
    location                   = var.REGION
    fgt_public_ip_address      = aws_eip.FGTPublicIP.public_ip
    fgt_private_ip_address_ext = data.aws_network_interface.eth0.private_ip
    fgt_private_ip_address_int = data.aws_network_interface.eth1.private_ip
  }
}

output "deployment_summary" {
  value = data.template_file.summary.rendered
}

##############################################################################################################
output "FGTPublicIP" {
  value = aws_eip.FGTPublicIP.public_ip
}

output "Username" {
  value = "admin"
}

output "Password" {
  value = aws_instance.fgtvm.id
}
