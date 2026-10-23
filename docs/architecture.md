# Architecture

## Components

- **Terraform runner:** Creates a key pair from a supplied public key, two Ubuntu 22.04 LTS EC2 instances, and security groups.
- **Ansible control node:** Receives the generated inventory and executes playbooks over SSH.
- **Jenkins controller:** Runs Jenkins and Java. The UI port is only allowed from `admin_cidr`.
- **Inventory output:** Terraform's `local_file` resource renders `ansible/inventory/terraform.ini` using public IP outputs and the configured private-key path.

## Network controls

- TCP/22 on the control node: administrator CIDR only.
- TCP/22 on Jenkins: administrator CIDR and control-node security group.
- TCP/8080 on Jenkins: administrator CIDR only.
- Outbound access is open for package installation. Consider private subnets, NAT, SSM Session Manager, TLS termination and private access for production.

## Maintenance sequence

1. Provision resources.
2. Install the pinned package for the lab baseline.
3. Back up Jenkins home while the service is stopped.
4. Upgrade Jenkins from the configured stable APT repository and ensure Java 17 runtime is installed.
5. Restart and verify the systemd service, package version and local login endpoint.

The PDF's final browser screenshot shows Jenkins 2.490. That is evidence from the original exercise, not a version pinned by this repository.
