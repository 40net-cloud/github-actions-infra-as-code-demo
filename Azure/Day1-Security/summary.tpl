##############################################################################################################
#
# Fortinet
# GitHub Actions - Infrastructure as Code
# Terraform deployment template for Microsoft Azure
#
# FortiGate management is reachable via GUI HTTPS on port 443 and for SSH on port 22
#
# BEWARE: The state files contain sensitive data like passwords and others. After the demo clean up your
#         clouddrive directory
#
# Deployment location: ${location}
# Username: ${username}
#
# Management FortiGate: https://${fgt_public_fqdn}/ or https://${fgt_public_ip_address}/
#
##############################################################################################################

fgt_public_ip_address = ${fgt_public_ip_address}
fgt_public_fqdn = ${fgt_public_fqdn}
fgt_private_ip_address_ext = ${fgt_private_ip_address_ext}
fgt_private_ip_address_int = ${fgt_private_ip_address_int}

##############################################################################################################