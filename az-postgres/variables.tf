# define resource group name
variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
  default     = "awx-rg"
}

# define location for resources 
variable "location" {
  description = "Azure region for resources"
  type        = string
  default     = "East US"
}

# whether to create resource group or use existing one 
variable "create_resource_group" {
  description = "Whether to create the resource group or use existing one"
  type        = bool
  default     = true
}

# give postgresql server a unique name
variable "postgresql_server_name" {
  description = "Name of the PostgreSQL server"
  type        = string
}

# database name for AWX
variable "postgresql_db_name" {
  description = "Name of the PostgreSQL database"
  type        = string
  default     = "awx"
}

# admin username for postgresql
variable "postgresql_admin_username" {
  description = "PostgreSQL admin username"
  type        = string
  default     = "awxadmin"
}

# admin password for postgresql
variable "postgresql_admin_password" {
  description = "PostgreSQL admin password"
  type        = string
  sensitive   = true
}

# SKU for PostgreSQL server (e.g. GP_Standard_D2s_v3) 
# define resource size and performance 
variable "postgresql_sku_name" {
  description = "PostgreSQL SKU name"
  type        = string
  default     = "GP_Standard_D2s_v3"
}

# storage in MB for PostgreSQL server
variable "postgresql_storage_mb" {
  description = "PostgreSQL storage in MB"
  type        = number
  default     = 32768
}

# list available postgresql versions in the region using:
# Ref: https://learn.microsoft.com/en-us/azure/postgresql/flexible-server/concepts-supported-versions
# define postgresql version
variable "postgresql_version" {
  description = "PostgreSQL version"
  type        = string
  default     = "13"
}

# define high availability mode
variable "enable_high_availability" {
  description = "Enable high availability for PostgreSQL (ZoneRedundant or SameZone)"
  type        = string
  default     = "auto"
  validation {
    condition     = contains(["auto", "ZoneRedundant", "SameZone", "disabled"], var.enable_high_availability)
    error_message = "enable_high_availability must be one of: auto, ZoneRedundant, SameZone, disabled."
  }
}

# enable geo-redundant backup
variable "enable_geo_redundant_backup" {
  description = "Enable geo-redundant backup"
  type        = bool
  default     = false  # Changed to false as it might not be available in all regions
}

# backup retention days (7-35)
variable "backup_retention_days" {
  description = "Backup retention period in days"
  type        = number
  default     = 7
  validation {
    condition     = var.backup_retention_days >= 7 && var.backup_retention_days <= 35
    error_message = "Backup retention days must be between 7 and 35."
  }
}

# allowed IP ranges to access PostgreSQL
# give access to all IPs by default (not secure for production)
# set a client public IP or range for better security
variable "allowed_ip_ranges" {
  description = "List of IP ranges allowed to access PostgreSQL"
  type        = list(string)
  default     = ["0.0.0.0/0"]
}

variable "tags" {
  description = "Tags to apply to all resources"
  type        = map(string)
  default = {
    Environment = "production"
    Application = "awx"
    ManagedBy   = "platform-team"
  }
}