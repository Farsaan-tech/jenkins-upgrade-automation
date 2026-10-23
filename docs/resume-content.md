# Resume and LinkedIn content

## Project title
Jenkins Upgrade Automation on AWS Using Terraform and Ansible

## Project description (~150 words)
Designed an infrastructure-as-code and configuration-management workflow to automate Jenkins version maintenance on AWS. Terraform provisions separate Ubuntu EC2 instances for an Ansible control node and Jenkins controller, defines scoped security-group rules, and generates an Ansible inventory from infrastructure outputs. Ansible installs a specified Jenkins package version to establish a controlled baseline, then creates a timestamped backup of the Jenkins home directory before maintenance. A separate upgrade playbook refreshes APT metadata, ensures the Java runtime package is installed, upgrades Jenkins from the configured stable repository, and restarts the service when required. Verification tasks report the installed package version, assert that the Jenkins systemd service is active, and check the local login endpoint. The repository includes a maintenance runbook, architecture documentation, screenshots from the source lab, GitHub Actions validation, and security notes covering restricted access, secret handling, backup restoration and version compatibility. The implementation should be described as tested only after a fresh end-to-end run.

## Resume bullets
- Provisioned AWS EC2 infrastructure for Jenkins maintenance using reusable Terraform resources and variables.
- Automated pinned Jenkins package installation and package-based upgrades with Ansible.
- Added timestamped pre-upgrade backups of Jenkins home and documented restoration considerations.
- Implemented post-upgrade checks for installed package version, systemd health and HTTP endpoint response.
- Restricted SSH and Jenkins UI ingress using source CIDRs and security-group references.
- Documented patching strategy, maintenance workflow, screenshots and GitHub Pages technical documentation.

## LinkedIn project description
Automated Jenkins version installation, backup and upgrade on AWS using Terraform and Ansible. The workflow provisions EC2 infrastructure, configures SSH inventory, installs a controlled baseline version, backs up Jenkins home, applies package updates and verifies service health. Includes a maintenance runbook, architecture documentation, security notes and a GitHub Pages project guide.

Only publish claims that match the work you have personally executed and verified.
