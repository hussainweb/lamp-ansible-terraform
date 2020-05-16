variable "region" {
  default = "eu-west-1"
}

variable "web_instance_type" {
  default = "t2.micro"
}

output "instance_ip_addr" {
  value = aws_eip.web_ip.public_ip
}
