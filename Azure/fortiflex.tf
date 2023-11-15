resource "fortiflexvm_entitlements_vm_token" "fortiflex_vm" {
  config_id        = var.FORTIFLEX_CONFIG_ID
  serial_number    = var.FORTIFLEX_VM_SERIAL
  regenerate_token = true # If set as false, the provider would only provide the token and not regenerate the token.
}
output "debug_fortiflex" {
  #    value = fortiflexvm_entitlements_vm.fortiflex_vm
  value = fortiflexvm_entitlements_vm_token.fortiflex_vm
}
output "debug_fortiflex_token" {
  #    value = fortiflexvm_entitlements_vm.fortiflex_vm.token
  value = fortiflexvm_entitlements_vm_token.fortiflex_vm.token
}
