locals {
  common_tags = {
    Project   = var.project_name
    ManagedBy = "Terraform"
  }
}

data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"]

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }
}

resource "aws_key_pair" "admin" {
  key_name   = "${var.project_name}-admin"
  public_key = file(var.public_key_path)
  tags       = local.common_tags
}

resource "aws_security_group" "control" {
  name        = "${var.project_name}-control-sg"
  description = "SSH access to the Ansible control node"
  ingress {
    description = "SSH from administrator CIDR"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.admin_cidr]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = local.common_tags
}

resource "aws_security_group" "jenkins" {
  name        = "${var.project_name}-jenkins-sg"
  description = "Restricted SSH and Jenkins web access"
  ingress {
    description = "SSH from administrator CIDR"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.admin_cidr]
  }
  ingress {
    description     = "SSH from Ansible control node"
    from_port       = 22
    to_port         = 22
    protocol        = "tcp"
    security_groups = [aws_security_group.control.id]
  }
  ingress {
    description = "Jenkins UI from administrator CIDR"
    from_port   = var.jenkins_http_port
    to_port     = var.jenkins_http_port
    protocol    = "tcp"
    cidr_blocks = [var.admin_cidr]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = local.common_tags
}

module "control_node" {
  source             = "./modules/ec2"
  name               = "${var.project_name}-ansible"
  ami_id             = data.aws_ami.ubuntu.id
  instance_type      = var.instance_type
  key_name           = aws_key_pair.admin.key_name
  security_group_ids = [aws_security_group.control.id]
  tags               = local.common_tags
}

module "jenkins_node" {
  source             = "./modules/ec2"
  name               = "${var.project_name}-jenkins"
  ami_id             = data.aws_ami.ubuntu.id
  instance_type      = var.instance_type
  key_name           = aws_key_pair.admin.key_name
  security_group_ids = [aws_security_group.jenkins.id]
  tags               = local.common_tags
}

resource "local_file" "ansible_inventory" {
  filename        = "${path.module}/../ansible/inventory/terraform.ini"
  file_permission = "0600"
  content = templatefile("${path.module}/templates/inventory.ini.tftpl", {
    control_public_ip = module.control_node.public_ip
    jenkins_public_ip = module.jenkins_node.public_ip
    private_key_path  = var.ansible_private_key_path
  })
}
