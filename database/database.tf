resource "azurerm_resource_group" "elite_general_rg" {
  name     = "elite_general_rg"
  location = "North Europe"
}

resource "azurerm_storage_account" "elitestorageaccount" {
  name                     = join("", ["elite", "storage", "account"])
  resource_group_name      = azurerm_resource_group.elite_general_rg.name
  location                 = azurerm_resource_group.elite_general_rg.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

resource "azurerm_mssql_server" "elitemssqlserver" {
  name                         = join("", ["elite", "mssql", "server"])
  resource_group_name          = azurerm_resource_group.elite_general_rg.name
  location                     = azurerm_resource_group.elite_general_rg.location
  version                      = "12.0"
  administrator_login          = join("", ["elite", "mssqladmin"])
  administrator_login_password = azurerm_key_vault_secret.sql_server_password.value
#   administrator_login_password = "4-v3ry-53cr37-p455w0rd"
}

resource "azurerm_mssql_database" "elitedev_database" {
  name         = join("_", ["elitedev", "database"])
  server_id    = azurerm_mssql_server.elitemssqlserver.id
  collation    = "SQL_Latin1_General_CP1_CI_AS"
  license_type = "LicenseIncluded"
  #   max_size_gb    = 4
  read_scale = false
  #   sku_name       = "S0"
  zone_redundant = false

  tags = local.common_tags
}

resource "azurerm_mssql_firewall_rule" "firewallruledatabase" {
  name             = join("", ["firewallrule", "database"])
  server_id        = azurerm_mssql_server.elitemssqlserver.id
  start_ip_address = "84.232.141.74"
  end_ip_address   = "84.232.141.74"
}

# az mysql flexible-server connect -n elitemssqlserver -u elitemssqladmin -p lE7LpHJ$k:Q)UxjIPeb2 -d elitedev_database