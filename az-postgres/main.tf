# Create Resource Group (conditional)
resource "azurerm_resource_group" "main" {
  count    = var.create_resource_group ? 1 : 0
  name     = var.resource_group_name
  location = var.location
  tags     = var.tags
}

# Data source for existing Resource Group (conditional)
data "azurerm_resource_group" "existing" {
  count = var.create_resource_group ? 0 : 1
  name  = var.resource_group_name
}

# Local variables
locals {
  # Set the resource group name based on whether a new resource group should be created
resource_group_name = var.create_resource_group ? azurerm_resource_group.main[0].name : data.azurerm_resource_group.existing[0].name
  resource_group_location = var.create_resource_group ? azurerm_resource_group.main[0].location : data.azurerm_resource_group.existing[0].location
  
  # Regions that support Zone Redundant HA
  zone_redundant_regions = [
    "eastus", "eastus2", "westus2", "westus3", "centralus",
    "northcentralus", "southcentralus", "westcentralus",
    "canadacentral", "brazilsouth", "uksouth", "westeurope",
    "northeurope", "francecentral", "germanywestcentral",
    "switzerlandnorth", "norwayeast", "swedencentral",
    "japaneast", "koreacentral", "southeastasia", "eastasia",
    "australiaeast", "centralindia", "uaenorth", "southafricanorth"
  ]
  
  # Convert location to lowercase for comparison
  location_lower = lower(replace(local.resource_group_location, " ", ""))
  
  # Determine HA mode based on region and user preference
  # Determine High Availability (HA) mode based on user preference and region support
ha_mode = var.enable_high_availability == "auto" ? (
    contains(local.zone_redundant_regions, local.location_lower) ? "ZoneRedundant" : "SameZone"
  ) : var.enable_high_availability
  
  # Enable HA only if not disabled
  # Enable HA only if HA mode is not explicitly disabled
enable_ha = local.ha_mode != "disabled"
}

# Random password generation (fallback if not provided)
resource "random_password" "postgresql_password" {
  count   = var.postgresql_admin_password == "" ? 1 : 0
  length  = 16
  # Include special characters in the generated password
special = true
}

# PostgreSQL Flexible Server
resource "azurerm_postgresql_flexible_server" "awx_db" {
  name                   = var.postgresql_server_name
  resource_group_name    = local.resource_group_name
  location              = local.resource_group_location
  version               = var.postgresql_version
  
  administrator_login    = var.postgresql_admin_username
  administrator_password = var.postgresql_admin_password != "" ? var.postgresql_admin_password : random_password.postgresql_password[0].result
  
  sku_name              = var.postgresql_sku_name
  storage_mb            = var.postgresql_storage_mb
  
  backup_retention_days        = var.backup_retention_days
  geo_redundant_backup_enabled = var.enable_geo_redundant_backup
  
  # Conditional high availability block
  dynamic "high_availability" {
    for_each = local.enable_ha ? [1] : []
    content {
      mode                      = local.ha_mode
      standby_availability_zone = local.ha_mode == "ZoneRedundant" ? "2" : null
    }
  }

  # Enable automatic failover and point-in-time restore
  # Set PostgreSQL Flexible Server to default create mode for initial deployment
create_mode = "Default"
  
  tags = merge(var.tags, {
    HAMode = local.enable_ha ? local.ha_mode : "disabled"
  })

  lifecycle {
    prevent_destroy = false  # Changed to false for easier development/testing
    ignore_changes = [
      # Ignore changes to backup window to prevent unnecessary updates
      backup_retention_days,
    ]
  }
}

# PostgreSQL Database
resource "azurerm_postgresql_flexible_server_database" "awx_db" {
  name      = var.postgresql_db_name
  server_id = azurerm_postgresql_flexible_server.awx_db.id
  collation = "en_US.utf8"
  charset   = "utf8"
  
  depends_on = [azurerm_postgresql_flexible_server.awx_db]
}

# PostgreSQL Firewall Rules
resource "azurerm_postgresql_flexible_server_firewall_rule" "allow_azure_services" {
  name             = "AllowAzureServices"
  server_id        = azurerm_postgresql_flexible_server.awx_db.id
  start_ip_address = "0.0.0.0"
  end_ip_address   = "0.0.0.0"
}

resource "azurerm_postgresql_flexible_server_firewall_rule" "allow_all_azure_ips" {
  name             = "AllowAllAzureIps"
  server_id        = azurerm_postgresql_flexible_server.awx_db.id
  start_ip_address = "0.0.0.0"
  end_ip_address   = "255.255.255.255"
}

# PostgreSQL Configuration for optimal AWX performance
#resource "azurerm_postgresql_flexible_server_configuration" "max_connections" {
#  name      = "max_connections"
#  server_id = azurerm_postgresql_flexible_server.awx_db.id
#  value     = "200"
#}
#
#resource "azurerm_postgresql_flexible_server_configuration" "work_mem" {
#  name      = "work_mem"
#  server_id = azurerm_postgresql_flexible_server.awx_db.id
#  value     = "4MB"
#}
#
#resource "azurerm_postgresql_flexible_server_configuration" "maintenance_work_mem" {
#  name      = "maintenance_work_mem"
#  server_id = azurerm_postgresql_flexible_server.awx_db.id
#  value     = "64MB"
#}
#
#resource "azurerm_postgresql_flexible_server_configuration" "effective_cache_size" {
#  name      = "effective_cache_size"
#  server_id = azurerm_postgresql_flexible_server.awx_db.id
#  value     = "1GB"
#}