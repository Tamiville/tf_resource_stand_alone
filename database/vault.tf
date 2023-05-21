resource "azurerm_resource_group" "elite_vault_rg" {
  name     = "elite_vault_rg"
  location = upper("north europe")
  provider = azurerm.vault
}

resource "azurerm_key_vault" "elite-vault" {
  provider                    = azurerm.vault
  name                        = "elite-vault"
  location                    = azurerm_resource_group.elite_vault_rg.location
  resource_group_name         = azurerm_resource_group.elite_vault_rg.name
  enabled_for_disk_encryption = true
  tenant_id                   = data.azurerm_client_config.current.tenant_id
  soft_delete_retention_days  = 7
  purge_protection_enabled    = false

  sku_name = "standard"

  access_policy {
    tenant_id = data.azurerm_client_config.current.tenant_id
    object_id = data.azurerm_client_config.current.object_id

    key_permissions = [
      "Get", "List"
    ]

    secret_permissions = [
      "Get", "Backup", "Delete", "List", "Purge", "Recover", "Restore", "Set",
    ]

    storage_permissions = [
      "Get", "List"
    ]
  }
}

# ## ===================================================== ##
# #Generating Random KeyVault Password VM for windows server

# resource "random_password" "windows_server_password" {
#   length  = 17
#   special = false
# }

# ## ------------------------------------------##
# #Create Key Vault Secret for windows server

# resource "azurerm_key_vault_secret" "windows_server_password" {
#   name         = upper("windowsserverpassword")
#   value        = random_password.windows_server_password.result
#   key_vault_id = azurerm_key_vault.elite-vault.id

#   depends_on = [azurerm_key_vault.elite-vault]
# }

## ------------------------------------------##
#Create KeyVault VM password for sql database

resource "random_password" "sql_server_password" {
  length  = 20
  special = true
}

## ------------------------------------------##
#Create Key Vault Secret for sql database

resource "azurerm_key_vault_secret" "sql_server_password" {
  name         = upper("msqlpassword")
  value        = random_password.sql_server_password.result
  key_vault_id = azurerm_key_vault.elite-vault.id

  depends_on = [azurerm_key_vault.elite-vault]
}