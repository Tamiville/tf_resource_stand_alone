## Outputting Info for network.tf ##

output "virtual_network_id" {
  value = data.azurerm_virtual_network.vnet.id
}

output "virtual_network_name" {
  value = data.azurerm_virtual_network.vnet.id
}

# # Outputting Info for main.tf ##


# output "virtual_machine_public_ip_address" {
#   value = data.azurerm_virtual_machine.Linux_vm.public_ip_address
# }