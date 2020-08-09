variable "region" {
  default = "eu-west-1"
}

variable "web_instance_type" {
  default = "t2.micro"
}

variable "web_storage_size" {
  default = 10
}

output "web_instance_ip_addr" {
  value = aws_eip.web_ip.public_ip
}

locals {
  arm64_instance_types = ["a1", "c6g", "m6g", "r6g"]
  web_instance_arch = contains(local.arm64_instance_types, split(".", var.web_instance_type)[0]) ? "arm64": "amd64"
}
