
========== Prerequisites needed for Creating a simple VNET: ============= 

1. Resource group

2. Network Security Group

3. Virtual Network

4. Subnets ## set subnet to zero in the vnet block (ie; in-line);  subnet - []
and create a stabdalone subnet afterwards

5. Tags = created locals.tf to house tags

6. Route table

7. subnet_route_table_association

8. nsg-association



=========== Deploying a windows virtual machine  =====================

1. resource_group

2. virtual_network

3. subnets

4. public_ip

5. network_interface nic && attach the public_ip to your nic below

6. network_security_group and set your inbound security rule.

7. created a keyvault to store a secret.

8. added random_password to randomly generate 17 length characters for our windows-server.

9. created azurerm_key_vault_secret; we can store a secret in our key_vault.

10. and also used the depends_on function. so terraform will not create the azurerm_key_vault_secret first, but will wait till the azurerm_key_vault is created first eg:

depends_on = azurerm_key_vault



================== Deploying a Database  =====================

1. resource_group

2. azurerm_storage_account

3. azurerm_mssql_server.

4. created vault to generate password for mssql_server.

5. azurerm_mssql_database.

6. tags

7. azurerm_mssql_firewall_rule
