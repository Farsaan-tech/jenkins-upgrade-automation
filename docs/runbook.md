# Deployment and maintenance runbook

## Before you start

1. Choose a disposable AWS account/environment and confirm costs.
2. Create a dedicated SSH key pair. Keep the private key outside Git.
3. Find your public IP and set `admin_cidr` to that address with `/32`.
4. Check that your desired Jenkins baseline is available from the configured APT repository. Very old versions may no longer be available or may not work with current Java and plugins.

## Provision infrastructure

```bash
cd terraform
cp terraform.tfvars.example terraform.tfvars
# Edit required variables.
terraform init
terraform fmt -check -recursive
terraform validate
terraform plan
terraform apply
terraform output
```

Terraform writes the inventory to `ansible/inventory/terraform.ini`. If Terraform is run from Windows but Ansible is run on Linux, set the key path to a path valid on the Linux Ansible host.

## Verify SSH connectivity

```bash
cd ../ansible
ansible -i inventory/terraform.ini jenkins -m ping
```

If using the control EC2 as the Ansible host, copy the private key securely to that instance and set owner-only permissions. Do not paste private key content into source files or terminal logs.

## Install the baseline

```bash
ansible-playbook -i inventory/terraform.ini playbooks/install-pinned.yml   -e jenkins_version=2.249.1
```

Confirm the version from the CLI and Jenkins UI. The version in the source PDF is old; use it only in a lab.

## Back up before upgrading

```bash
ansible-playbook -i inventory/terraform.ini playbooks/backup.yml
```

The playbook stops Jenkins, archives `/var/lib/jenkins` to `/var/backups/jenkins`, and starts Jenkins again. Copy backups to off-host storage and test a restore. For larger instances, consider a storage snapshot or application-consistent backup process.

## Upgrade and validate

```bash
ansible-playbook -i inventory/terraform.ini playbooks/upgrade.yml
ansible-playbook -i inventory/terraform.ini playbooks/verify.yml
```

Review the displayed package version, service state and HTTP response. Check Jenkins system logs if the service fails:

```bash
sudo systemctl status jenkins --no-pager
sudo journalctl -u jenkins -n 200 --no-pager
sudo dpkg-query -W jenkins
```

## Rollback approach

Do not assume that downgrading a package alone restores a working controller. Jenkins upgrades can migrate internal data and plugins. A reliable rollback requires a tested backup of Jenkins home plus a compatible package/runtime, and may require restoring a pre-upgrade disk snapshot. Practice restoration in a disposable environment.

## Cleanup

```bash
cd ../terraform
terraform destroy
```

Confirm EC2 instances, security groups, volumes, snapshots and public IPv4 resources are removed or intentionally retained.
