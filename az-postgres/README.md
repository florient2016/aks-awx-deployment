# Azure PostgreSQL Flexible Server Terraform Module for AWX

This Terraform module automates the deployment of an Azure PostgreSQL Flexible Server, optimized for use with AWX or similar applications. It supports both the creation of a new resource group or using an existing one, enables high availability based on region and user preference, and provides secure, configurable access and backup options.

---

## Features

- **Resource Group Management:**  
  Optionally create a new resource group or use an existing one.

- **Flexible PostgreSQL Server:**  
  Deploys an Azure PostgreSQL Flexible Server with configurable version, SKU, storage, and backup settings.

- **High Availability:**  
  Automatically selects the best HA mode (`ZoneRedundant` or `SameZone`) based on region and user input.

- **Secure Access:**  
  Generates a random admin password if not provided, and allows you to specify allowed IP ranges for firewall rules.

- **Database Initialization:**  
  Creates the target database for AWX.

- **Firewall Rules:**  
  By default, allows Azure services and all IPs (for demo/testing; restrict in production).

- **Outputs:**  
  Provides connection details, FQDN, credentials, and backup/HA configuration.

---

## File Structure

- `main.tf` – Main resource definitions for resource group, PostgreSQL server, database, firewall rules, and logic for HA.
- `variables.tf` – All configurable variables with descriptions and defaults.
- `output.tf` – Outputs for connection strings, credentials, and configuration.
- `provider.tf` – AzureRM provider configuration.
- `README.md` – This documentation.

---

## Usage

### 1. Prerequisites

- [Terraform](https://www.terraform.io/downloads.html) v1.0 or higher
- Azure subscription and credentials (e.g., via `az login`)
- AWX or other application that will use the database

### 2. Example Terraform Configuration

```hcl
module "awx_postgres" {
  source                   = "./az-postgres"
  resource_group_name      = "awx-rg"
  location                 = "East US"
  create_resource_group    = true
  postgresql_server_name   = "awx-postgres-01"
  postgresql_db_name       = "awx"
  postgresql_admin_username = "awxadmin"
  postgresql_admin_password = "yourStrongPasswordHere" # or leave blank for random
  postgresql_sku_name      = "GP_Standard_D2s_v3"
  postgresql_storage_mb    = 32768
  postgresql_version       = "13"
  enable_high_availability = "auto"
  enable_geo_redundant_backup = false
  backup_retention_days    = 7
  allowed_ip_ranges        = ["0.0.0.0/0"]
  tags = {
    Environment = "production"
    Application = "awx"
    ManagedBy   = "platform-team"
  }
}
```

### 3. **Initialize and Apply**
```hcl
   terraform init
   terraform plan
   terraform apply
```

### 4. **Variables**
See variables.tf for all options. Key variables include:

## **Outputs**
After terraform apply, you will get:

- resource_group_name and resource_group_location
- postgresql_server_name and postgresql_fqdn
- postgresql_connection_string (for AWX, sensitive)
- postgresql_host, postgresql_database, postgresql_username, postgresql_password (sensitive)
- backup_configuration and region_ha_support (for reference)

Security Notes
- Passwords: If you do not provide a password, a secure random one will be generated.
- Firewall: By default, all IPs are allowed. Restrict allowed_ip_ranges for production.
- Backups: Adjust retention and geo-redundancy as needed for your compliance.
- HA: The module will auto-select the best HA mode for your region if set to auto.

## **License**
This project is licensed under the MIT License. See the LICENSE file for details.