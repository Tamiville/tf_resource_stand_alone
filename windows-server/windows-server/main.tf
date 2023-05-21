resource "azurerm_resource_group" "elite_general_rg" {
  name     = "elite_general_rg"
  location = "North Europe"
}

resource "azurerm_virtual_network" "elite_win_vnet" {
  name                = "elite_win_vnet"
  address_space       = ["10.0.0.0/16"]
  dns_servers         = ["10.0.0.4", "10.0.0.5"]
  location            = azurerm_resource_group.elite_general_rg.location
  resource_group_name = azurerm_resource_group.elite_general_rg.name
}

resource "azurerm_subnet" "db-subnet" {
  name                 = "db-subnet"
  resource_group_name  = azurerm_resource_group.elite_general_rg.name
  virtual_network_name = azurerm_virtual_network.elite_win_vnet.name
  address_prefixes     = ["10.0.1.0/24"]
}

resource "azurerm_subnet" "app-subnet" {
  name                 = "app-subnet"
  resource_group_name  = azurerm_resource_group.elite_general_rg.name
  virtual_network_name = azurerm_virtual_network.elite_win_vnet.name
  address_prefixes     = ["10.0.2.0/24"]
}

resource "azurerm_public_ip" "elitedev_pip" {
  name                = "elitedev_pip"
  resource_group_name = azurerm_resource_group.elite_general_rg.name
  location            = azurerm_resource_group.elite_general_rg.location
  allocation_method   = "Static"

  tags = {
    environment = "Development"
    Company     = "Elitesolutionit"
    ManagedWith = "Terraform"
  }
}

resource "azurerm_network_interface" "elitedev_nic" {
  name                = "elitedev_nic"
  location            = azurerm_resource_group.elite_general_rg.location
  resource_group_name = azurerm_resource_group.elite_general_rg.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.db-subnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.elitedev_pip.id
  }
}

resource "azurerm_windows_virtual_machine" "windows-server" {
  name                = join("-", ["win", "server", "dev"])
  resource_group_name = azurerm_resource_group.elite_general_rg.name
  location            = azurerm_resource_group.elite_general_rg.location
  size                = "Standard_DS1_v2"
  admin_username      = join("",[local.admin_username, "admin"])
  admin_password      = "P@$$w0rd1234!"
  network_interface_ids = [
    azurerm_network_interface.elitedev_nic.id,
  ]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2016-Datacenter"
    version   = "latest"
  }
}

resource "azurerm_network_security_group" "elitedev_nsg" {
  name                = "elitedev_nsg"
  location            = azurerm_resource_group.elite_general_rg.location
  resource_group_name = azurerm_resource_group.elite_general_rg.name

  security_rule {
    name                       = "RDP"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "3389"
    destination_port_range     = "*"
    source_address_prefix      = "84.232.141.74"
    destination_address_prefix = "VirtualNetwork"
  }

  tags = local.common_tags
}