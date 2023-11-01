output "public_ip_address" {
  value = azurerm_public_ip.publicIP.ip_address
}

output "host_user" {
  value = azurerm_linux_virtual_machine.vm_linux_name.admin_username
}