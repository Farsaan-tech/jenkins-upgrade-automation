output "ansible_control_public_ip" {
  value = module.control_node.public_ip
}
output "jenkins_public_ip" {
  value = module.jenkins_node.public_ip
}
output "jenkins_url" {
  value       = "http://${module.jenkins_node.public_ip}:${var.jenkins_http_port}"
  description = "Lab URL; plain HTTP only, restrict access to admin_cidr."
}
