========== Prerequisites needed for Creating a simple VNET: ============= 

Resource group
Network Security Group
Virtual Network
Subnets ## set subnet to zero in the vnet block (ie; in-line);  subnet - []
and create a stabdalone subnet afterwards
Tags = created locals.tf to house tags
Route table
subnet_route_table_association
nsg-association



=========== Deploying a windows virtual machine  =====================
create your rg
vnet
subnet
public_ip
network_interface nic && attach the public_ip to your nic below
network_security_group and set your inbound security rule

created a keyvault to store a secret
added random_password to randomly generate 17 length characters for our win-server
created azurerm_key_vault_secret; we can store a secret in our key_vault

and also used the depends_on function. so terraform will not create the azurerm_key_vault_secret first, but will wait till the azurerm_key_vault is created first
depends_on = azurerm_key_vault

=========== Deploying a Database  =====================
rg
azurerm_storage_account
azurerm_mssql_server
created vault to generate password for mssql_server
azurerm_mssql_database
tags
azurerm_mssql_firewall_rule
