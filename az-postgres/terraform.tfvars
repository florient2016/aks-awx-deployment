# terraform.tfvars
resource_group_name         = "btech-rg-awx"
location                   = "East US 2"
create_resource_group      = true  # Set to false if resource group already exists

postgresql_server_name     = "awx-pg-server"
postgresql_admin_username  = "awxadmin"
postgresql_admin_password  = "tete@2016"

# HA Configuration - options: "auto", "ZoneRedundant", "SameZone", "disabled"
enable_high_availability   = "disabled"  # Will automatically choose best HA mode for region
enable_geo_redundant_backup = true
backup_retention_days      = 7  # Retain backups for 14 days

# Performance settings
postgresql_sku_name        = "GP_Standard_D2s_v3"
postgresql_storage_mb      = 32768

# Tags
tags = {
  Environment = "development"
  Application = "awx"
  ManagedBy   = "terraform"
  Project     = "awx-deployment"
}





