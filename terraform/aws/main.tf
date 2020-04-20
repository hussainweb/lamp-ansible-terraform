data "aws_ami" "ubuntu1804hvm" {
  most_recent = true
  owners = ["099720109477"] # Canonical

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-bionic-18.04-amd64-*"]
  }
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

resource "aws_instance" "web" {
  ami = data.aws_ami.ubuntu1804hvm.id
  instance_type = var.web_instance_type

  key_name = aws_key_pair.main.id

  root_block_device {
    volume_type = "gp2"
    volume_size = 10
    delete_on_termination = true
  }

  tags = {
    Name = "Drupal WebServer"
    Terraform = "True"
  }
}

resource "aws_security_group" "allow_web" {
  name_prefix = "allow-web-"
  description = "Allow web ports and SSH"

  ingress {
    cidr_blocks = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
    description = "SSH"
    protocol = "tcp"
    from_port = 22
    to_port = 22
  }
  ingress {
    cidr_blocks = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
    description = "Normal Web Traffic"
    protocol = "tcp"
    from_port = 80
    to_port = 80
  }
  ingress {
    cidr_blocks = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
    description = "HTTPS Web Traffic"
    protocol = "tcp"
    from_port = 443
    to_port = 443
  }

  tags = {
    Terraform = "True"
  }
}

resource "aws_network_interface_sg_attachment" "web_sg" {
  network_interface_id = aws_instance.web.primary_network_interface_id
  security_group_id = aws_security_group.allow_web.id
}

resource "aws_eip" "web_ip" {
  instance = aws_instance.web.id
}
