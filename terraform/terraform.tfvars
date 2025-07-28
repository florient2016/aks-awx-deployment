resource_group_name = "rg-aks-awx-demo"
location           = "East US"
cluster_name       = "aks-awx-minimal"
node_count         = 2
vm_size           = "Standard_B2s"
dns_prefix        = "aks-awx-demo"

tags = {
  Environment = "development"
  Purpose     = "awx-deployment"
  Owner       = "devops-team"
}