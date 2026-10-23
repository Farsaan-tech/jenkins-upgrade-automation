variable "aws_region" {
  description = "AWS region for the lab."
  type        = string
  default     = "us-east-2"
}
variable "project_name" {
  description = "Prefix used for resource names."
  type        = string
  default     = "jenkins-upgrade-lab"
}
variable "instance_type" {
  description = "EC2 instance size; verify account quotas and Jenkins memory requirements."
  type        = string
  default     = "t3.small"
}
variable "admin_cidr" {
  description = "Trusted administrator public IPv4 CIDR. Replace the example with your own IP/32."
  type        = string
}
variable "public_key_path" {
  description = "Path to the public SSH key on the machine running Terraform."
  type        = string
}
variable "ansible_private_key_path" {
  description = "Private key path as seen by the Ansible execution environment."
  type        = string
  default     = "/home/ubuntu/.ssh/jenkins_upgrade_key"
}
variable "jenkins_http_port" {
  description = "Jenkins web interface port."
  type        = number
  default     = 8080
}
