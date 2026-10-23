resource "aws_instance" "this" {
  ami                         = var.ami_id
  instance_type               = var.instance_type
  key_name                    = var.key_name
  vpc_security_group_ids      = var.security_group_ids
  associate_public_ip_address = true

  metadata_options {
    http_tokens   = "required"
    http_endpoint = "enabled"
  }

  root_block_device {
    encrypted             = true
    volume_size           = 16
    volume_type           = "gp3"
    delete_on_termination = true
  }

  tags = merge(var.tags, { Name = var.name })
}
