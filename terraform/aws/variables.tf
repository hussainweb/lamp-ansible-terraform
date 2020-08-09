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
