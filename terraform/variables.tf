variable "resource_group_name" {
  description = "Name of the Azure Resource Group"
  type        = string
  default     = "btech-rg-aks"
}

variable "location" {
  description = "Azure region for resources"
  type        = string
  default     = "East US"
}

variable "cluster_name" {
  description = "Name of the AKS cluster"
  type        = string
  default     = "btech-aks-cluster"
}

variable "node_count" {
  description = "Number of nodes in the AKS cluster"
  type        = number
  default     = 3
}

variable "vm_size" {
  description = "VM size for AKS nodes"
  type        = string
  default     = "Standard_B2s"  # 2 vCPU, 4GB RAM - minimal for AWX
}

variable "kubernetes_version" {
  description = "Kubernetes version"
  type        = string
  default     = "1.32.6"
}

variable "dns_prefix" {
  description = "DNS prefix for the cluster"
  type        = string
  default     = "btech-aks-awx"
}

variable "tags" {
  description = "Tags to apply to resources"
  type        = map(string)
  default = {
    Environment = "development"
    Purpose     = "awx-deployment"
  }
}