variable "web_instance_size" {
  default = "Standard_B1ms"
}

output "instance_ip_addr" {
  value = azurerm_public_ip.drupalcms.ip_address
}
