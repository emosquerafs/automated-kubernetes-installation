# Kubernetes Cluster Setup with Ansible

This repository contains Ansible playbooks for automating the deployment and configuration of a Kubernetes cluster. The playbooks support setting up a multi-node cluster with multiple control plane nodes and worker nodes.

## Prerequisites

- Ansible installed on the control machine
- Target machines with Ubuntu/Debian-based OS
- SSH access to all target machines
- Proper network connectivity between nodes

## Project Structure

- `dev`: Inventory file containing the host definitions for controller and worker nodes
- `templates/`: Directory containing configuration templates  
  - `config_kubectl.j2`: kubectl configuration template
  - `config_ssh.j2`: SSH configuration template for disabling strict host checking
- `add_nodes_2etchosts.awk`: AWK script for adding node IPs to /etc/hosts
- `hostname.yaml`: Playbook for configuring hostnames on all servers
- `timezone.yaml`: Playbook for setting timezone to America/Bogota
- `kubernetes_install.yaml`: Main playbook for installing Kubernetes components
- `kubernetes_add_controlplane.yaml`: Playbook for adding additional control plane nodes
- `kubernetes_add_workernode.yaml`: Playbook for adding worker nodes to the cluster
- `kubernetes_helm_install.yaml`: Playbook for installing Helm and Cilium CNI
- `kubernetes_postinstall.yaml`: Post-installation configuration tasks

## Playbook Descriptions

### 1. hostname.yaml
- Configures hostnames on all servers
- Updates /etc/hosts with proper mappings
- Removes IPv6 localhost entries
- Sets up proper host resolution

### 2. timezone.yaml
- Sets the timezone to America/Bogota on all nodes

### 3. kubernetes_install.yaml
- Installs prerequisites and container runtime (containerd)
- Configures system settings for Kubernetes
- Installs kubeadm, kubelet, and kubectl
- Initializes the first control plane node
- Sets up pod network CIDR

### 4. kubernetes_add_controlplane.yaml
- Joins additional control plane nodes to the cluster
- Configures kubeconfig for new control plane nodes
- Sets up certificates and tokens for secure joining

### 5. kubernetes_add_workernode.yaml
- Joins worker nodes to the cluster
- Configures kubeconfig for worker nodes
- Sets up proper node labels

### 6. kubernetes_helm_install.yaml
- Installs Helm package manager
- Deploys Cilium CNI with Hubble
- Configures monitoring and metrics collection

## Execution Order

Run the playbooks in the following order:

```bash
# 1. Configure hostnames
ansible-playbook -i dev hostname.yaml

# 2. Set timezone
ansible-playbook -i dev timezone.yaml

# 3. Install Kubernetes components
ansible-playbook -i dev kubernetes_install.yaml

# 4. Add additional control plane nodes (if any)
ansible-playbook -i dev kubernetes_add_controlplane.yaml

# 5. Add worker nodes
ansible-playbook -i dev kubernetes_add_workernode.yaml

# 6. Install Helm and Cilium
ansible-playbook -i dev kubernetes_helm_install.yaml
```

## Inventory Configuration

The `dev` inventory file should be configured with your node information. Example structure:

```ini
[controller]
dev-controlplane-01 ansible_host=172.100.0.200 ansible_user=sysadmin ansible_ssh_private_key_file=/path/to/ssh/key
dev-controlplane-02 ansible_host=172.100.0.201 ansible_user=sysadmin ansible_ssh_private_key_file=/path/to/ssh/key

[worker]
dev-workernode-01 ansible_host=172.100.0.202 ansible_user=sysadmin ansible_ssh_private_key_file=/path/to/ssh/key
dev-workernode-02 ansible_host=172.100.0.203 ansible_user=sysadmin ansible_ssh_private_key_file=/path/to/ssh/key
```

## Network Configuration

- Pod Network CIDR: 10.244.0.0/20
- Control Plane Endpoint: First control plane node (port 6443)
- CNI: Cilium with Hubble UI and monitoring enabled

## Post-Installation

After successful installation, you can access your cluster using kubectl from any control plane node. The kubeconfig file will be automatically configured in the user's home directory.