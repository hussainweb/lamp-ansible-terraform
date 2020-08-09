data "aws_ami" "db_ubuntu2004hvm" {
  most_recent = true
  owners = ["099720109477"] # Canonical

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-${local.db_instance_arch}-*"]
  }
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

resource "aws_instance" "db" {
  ami = data.aws_ami.db_ubuntu2004hvm.id
  instance_type = var.db_instance_type

  count = var.db_instance_type == "" ? 0 : 1

  key_name = aws_key_pair.main.id

  root_block_device {
    volume_type = "gp2"
    volume_size = var.db_storage_size
    delete_on_termination = true
  }

  tags = {
    Name = "Drupal Database server - ${terraform.workspace}"
    Terraform = "True"
  }
}

resource "aws_security_group" "allow_db" {
  name_prefix = "allow-db-"
  description = "Allow DB, Redis ports and SSH"

  count = var.db_instance_type == "" ? 0 : 1

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
    description = "MySQL"
    protocol = "tcp"
    from_port = 3306
    to_port = 3306
  }
  ingress {
    cidr_blocks = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
    description = "Redis"
    protocol = "tcp"
    from_port = 6379
    to_port = 6379
  }

  tags = {
    Terraform = "True"
  }
}

resource "aws_network_interface_sg_attachment" "db_sg" {
  count = length(aws_instance.db)
  network_interface_id = aws_instance.db[count.index].primary_network_interface_id
  security_group_id = join("", aws_security_group.allow_db.*.id)
}

resource "aws_eip" "db_ip" {
  count = length(aws_instance.db)
  instance = aws_instance.db[count.index].id
}
