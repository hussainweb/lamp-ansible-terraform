resource "aws_key_pair" "main" {
  key_name_prefix = "hw-mbp-"
  public_key = var.ssh_public_key
}
