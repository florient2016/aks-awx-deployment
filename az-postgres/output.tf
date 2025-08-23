# Outputs
output "resource_group_name" {
  description = "Resource group name"
  value       = local.resource_group_name
}

output "resource_group_location" {
  description = "Resource group location"
  value       = local.resource_group_location
}

output "postgresql_server_name" {
  description = "PostgreSQL server name"
  value       = azurerm_postgresql_flexible_server.awx_db.name
}

output "postgresql_fqdn" {
  description = "PostgreSQL server FQDN"
  value       = azurerm_postgresql_flexible_server.awx_db.fqdn
}

output "postgresql_connection_string" {
  description = "PostgreSQL connection string for AWX"
  value       = "postgresql://${var.postgresql_admin_username}:${var.postgresql_admin_password != "" ? var.postgresql_admin_password : random_password.postgresql_password[0].result}@${azurerm_postgresql_flexible_server.awx_db.fqdn}:5432/${var.postgresql_db_name}?sslmode=require"
  sensitive   = true
}

output "postgresql_host" {
  description = "PostgreSQL host"
  value       = azurerm_postgresql_flexible_server.awx_db.fqdn
}

output "postgresql_database" {
  description = "PostgreSQL database name"
  value       = azurerm_postgresql_flexible_server_database.awx_db.name
}

output "postgresql_username" {
  description = "PostgreSQL username"
  value       = var.postgresql_admin_username
}

output "postgresql_password" {
  description = "PostgreSQL password"
  value       = var.postgresql_admin_password != "" ? var.postgresql_admin_password : random_password.postgresql_password[0].result
  sensitive   = true
}

#output "high_availability_mode" {
#  description = "High availability mode configured"
#  value       = local.enable_ha ? local.ha_mode : "disabled"
#}

output "backup_configuration" {
  description = "Backup configuration details"
  value = {
    retention_days           = var.backup_retention_days
    geo_redundant_enabled   = var.enable_geo_redundant_backup
  }
}

output "region_ha_support" {
  description = "High availability support for selected region"
  value = {
    location              = local.resource_group_location
    supports_zone_redundant = contains(local.zone_redundant_regions, local.location_lower)
    configured_ha_mode    = local.enable_ha ? local.ha_mode : "disabled"
  }
}