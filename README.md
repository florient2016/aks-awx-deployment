# AKS AWX Deployment - Azure Infrastructure & Automation

This repository provides a complete solution for deploying AWX (the open-source version of Ansible Tower) on Azure Kubernetes Service (AKS), including all supporting infrastructure such as PostgreSQL and Terraform automation. The structure is modular, making it easy to manage, customize, and extend for your own needs.

---

## Components

### 1. **Terraform Root**

- **main.tf, variables.tf**: Entry point for orchestrating the deployment of all infrastructure modules (AKS, PostgreSQL, networking, etc.).
- Designed to be the central place to run `terraform init/plan/apply` for the whole stack.

### 2. **az-postgres/**

- **Purpose**: Deploys an Azure PostgreSQL Flexible Server for AWX.
- **Files**:
  - `main.tf`, `variables.tf`, `output.tf`, `provider.tf`: Terraform module for PostgreSQL.
  - `terraform.tfvars`: Example variable values.
  - `README.md`: Usage and configuration details.
- **Features**:
  - Supports new or existing resource groups.
  - Configurable HA, backup, firewall, and admin credentials.
  - Outputs connection info for AWX.

### 3. **awx-anisble-deploy/**

- **Purpose**: Contains Ansible playbooks and inventory for deploying AWX on AKS.
- **Files**:
  - `README.md`: Instructions for AWX deployment.
  - `inventory/inventory`: Ansible inventory file.
  - `playbooks/ansible.cfg`: Ansible configuration.
  - `playbooks/install-awx.yaml`: Playbook to install AWX on AKS.
  - `playbooks/setup-ingress.yaml`: Playbook to configure ingress for AWX.
  - `playbooks/vars/awx-vars.yaml`: Variables for AWX deployment.
- **Features**:
  - Automated AWX installation and configuration.
  - Ingress setup for external access.
  - Parameterized for easy customization.

### 4. **terraform/**

- **Purpose**: (Optional/Advanced) Additional Terraform modules or configurations, e.g., for AKS, networking, or other Azure resources.
- **Files**:
  - `main.tf`, `variables.tf`, `outputs.tf`: Infrastructure as code for Azure resources.
- **Features**:
  - Modular and reusable for other Azure projects.

---

## Getting Started

### Prerequisites

- [Terraform](https://www.terraform.io/downloads.html) v1.0+
- [Ansible](https://docs.ansible.com/ansible/latest/installation_guide/intro_installation.html)
- Azure CLI (`az login`)
- Access to an Azure subscription

### High-Level Workflow

1. **Provision Infrastructure with Terraform**
   - Deploy PostgreSQL, AKS, and any required networking.
   - Example:
     ```bash
     cd aks-awx-deployment
     terraform init
     terraform apply
     ```

2. **Deploy AWX with Ansible**
   - Configure your inventory and variables.
   - Run the playbooks to install AWX and set up ingress.
     ```bash
     cd awx-anisble-deploy/playbooks
     ansible-playbook -i ../inventory/inventory install-awx.yaml
     ansible-playbook -i ../inventory/inventory setup-ingress.yaml
     ```

3. **Access AWX**
   - Use the output from Terraform and Ansible to find the AWX URL and credentials.

---

## Customization

- **PostgreSQL**: Adjust variables in `az-postgres/terraform.tfvars` or via module inputs.
- **AWX**: Edit `awx-anisble-deploy/playbooks/vars/awx-vars.yaml` for custom settings.
- **AKS/Networking**: Use the `terraform/` directory for advanced Azure resource management.

---

## License

This project is licensed under the MIT License. See the `LICENSE` file for details.

---

## References

- [AWX Project](https://github.com/ansible/awx)
-