data "azurerm_virtual_network" "vnet" {
  name                = "elite_linux_vnet"
  resource_group_name = "elite_network_rg"
}

# data "azurerm_virtual_machine" "Linux_vm" {
#   name                = "elite_linux_vm"
#   resource_group_name = "elite_general_rg"
# }
