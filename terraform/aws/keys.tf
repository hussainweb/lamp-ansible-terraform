resource "aws_key_pair" "main" {
  key_name_prefix = "hw-mbp-"
  public_key = "example key"
}
