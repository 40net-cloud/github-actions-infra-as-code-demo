[fgt]
${fgt_hostname}  ansible_host="${fgt_public_ip_address}" ansible_user="${username}" ansible_password="${password}"

[fgt:vars]
ansible_network_os=fortios
