resource "azurerm_resource_group" "elite_general_rg" {
  name     = "elite_general_rg"
  location = "eastus2"
}


resource "azurerm_public_ip" "elitedev_pip" {
  name                = "elitedev_pip"
  resource_group_name = azurerm_resource_group.elite_general_rg.name
  location            = azurerm_resource_group.elite_general_rg.location
  allocation_method   = "Static"

  tags = {
    environment = "Development"
    Company     = "Elitesolutionsit"
    ManagedWith = "Terraform"
    Owner       = "Tamie_Emmanuel"
  }
}

resource "azurerm_network_interface" "elitedev_nic" {
  name                = "elitedev_nic"
  location            = azurerm_resource_group.elite_general_rg.location
  resource_group_name = azurerm_resource_group.elite_general_rg.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.app-subnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.elitedev_pip.id
  }
}


## Connecting NSG to NIC
resource "azurerm_network_interface_security_group_association" "nsg_nic" {
  network_interface_id      = azurerm_network_interface.elitedev_nic.id
  network_security_group_id = azurerm_network_security_group.elitedev_nsg.id
}


resource "azurerm_linux_virtual_machine" "Linux_vm" {
  name                = join("-", ["elite", "linux", "vm"])
  resource_group_name = azurerm_resource_group.elite_general_rg.name
  location            = azurerm_resource_group.elite_general_rg.location
  size                = "Standard_E2s_v3"
  admin_username      = "adminuser"
  network_interface_ids = [
    azurerm_network_interface.elitedev_nic.id,
  ]

  admin_ssh_key {
    username   = "adminuser"
    public_key = file("Linuxserverkey.pub")  ## ssh-keygen -f Linuxserverkey
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku     = "20.04-LTS"
    version = "latest"
  }
}
