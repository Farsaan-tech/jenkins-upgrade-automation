variable "name" { type = string }
variable "ami_id" { type = string }
variable "instance_type" { type = string }
variable "key_name" { type = string }
variable "security_group_ids" { type = list(string) }
variable "tags" {
  type    = map(string)
  default = {}
}
