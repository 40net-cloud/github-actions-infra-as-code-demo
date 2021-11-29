##############################################################################################################
#
# Fortinet
# GitHub Actions - Infrastructure as Code
# Terraform deployment template for AWS
#
# FortiGate management is reachable via GUI HTTPS on port 8443 and for SSH on port 22
#
# BEWARE: The state files contain sensitive data like passwords and others. After the demo clean up your
#         clouddrive directory
#
# Deployment location: ${location}
# Username: ${username}
# Password: ${password}
#
# Management FortiGate: https://${fgt_public_ip_address}/
#
##############################################################################################################

fgt_public_ip_address = ${fgt_public_ip_address}
fgt_private_ip_address_ext = ${fgt_private_ip_address_ext}
fgt_private_ip_address_int = ${fgt_private_ip_address_int}

##############################################################################################################