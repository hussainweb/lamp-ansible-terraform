//resource "azurerm_resource_group" "drupalcms" {
//  name = "drupal-CMS-Group"
//  location = "West Europe"
//}

data "azurerm_resource_group" "drupalcms" {
  name = "ITS-App-Notification"
}

resource "azurerm_virtual_network" "drupalcms" {
  name = "drupalcms-vnet"
  address_space = ["10.0.0.0/16"]
  location = data.azurerm_resource_group.drupalcms.location
  resource_group_name = data.azurerm_resource_group.drupalcms.name
}

resource "azurerm_subnet" "drupalcms" {
  name = "internal"
  resource_group_name = data.azurerm_resource_group.drupalcms.name
  virtual_network_name = azurerm_virtual_network.drupalcms.name
  address_prefix = "10.0.0.0/24"
}

resource "azurerm_public_ip" "drupalcms" {
  name = "drupalcms-public-ip"
  resource_group_name = data.azurerm_resource_group.drupalcms.name
  location = data.azurerm_resource_group.drupalcms.location
  allocation_method = "Static"

  tags = {
    Terraform = "true"
  }
}

resource "azurerm_network_interface" "drupalcms" {
  name = "drupalcms-nic"
  location = data.azurerm_resource_group.drupalcms.location
  resource_group_name = data.azurerm_resource_group.drupalcms.name

  ip_configuration {
    name = "internal"
    subnet_id = azurerm_subnet.drupalcms.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id = azurerm_public_ip.drupalcms.id
  }
}

resource "azurerm_linux_virtual_machine" "drupalcms" {
  name = "drupalcms"
  resource_group_name = data.azurerm_resource_group.drupalcms.name
  location = data.azurerm_resource_group.drupalcms.location
  size = var.web_instance_size
  admin_username = "ubuntu"
  network_interface_ids = [
    azurerm_network_interface.drupalcms.id,
  ]

  admin_ssh_key {
    username = "ubuntu"
    public_key = "example key"
  }

  os_disk {
    caching = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer = "UbuntuServer"
    sku = "18.04-LTS"
    version = "latest"
  }

  tags = {
    Terraform = "true"
  }
}
