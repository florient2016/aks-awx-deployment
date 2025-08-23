# AWX Ansible Deploy

This directory contains all the Ansible resources needed to deploy AWX (the open-source version of Ansible Tower) on an Azure Kubernetes Service (AKS) cluster. It includes inventory files, playbooks for installation and ingress setup, configuration files, and variable definitions for a streamlined and automated deployment process.



---

## Contents

- **inventory/inventory**  
  The Ansible inventory file listing the target hosts or Kubernetes API endpoints for AWX deployment.

- **playbooks/ansible.cfg**  
  Ansible configuration file to set defaults such as inventory location, roles path, and connection settings.

- **playbooks/install-awx.yaml**  
  The main Ansible playbook to automate the installation and configuration of AWX on your Kubernetes cluster. This playbook uses variables and roles for a modular and flexible deployment.

- **playbooks/vars/awx-vars.yaml**  
  Variable definitions for customizing your AWX deployment, such as namespace, admin credentials, image versions, and resource settings.

---

## Usage

1. **Configure Inventory**  
   Edit `inventory/inventory` to specify your target hosts or Kubernetes API endpoint.

2. **Set Variables**  
   Adjust `playbooks/vars/awx-vars.yaml` to match your desired AWX configuration (namespace, admin user, etc.).

3. **Run the Playbook**  
   From the `playbooks/` directory, execute:
   ```bash
   ansible-playbook -i ../inventory/inventory install-awx.yaml
   ```

4. **Customization**
- AWX Settings:
Change any deployment parameters in vars/awx-vars.yaml to fit your environment.

- Ansible Configuration:
Modify ansible.cfg for advanced Ansible options (e.g., SSH settings, roles path).

**Prerequisites**
- Ansible installed on your control machine.
- Access to a Kubernetes cluster (e.g., AKS, EKS, GKE, or on-prem).
- kubectl configured and access to the target cluster.

**License**
This project is licensed under the MIT License. See the LICENSE file for details
