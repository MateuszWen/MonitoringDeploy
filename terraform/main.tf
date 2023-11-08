terraform {
  required_version = ">= 0.12"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0.2"
    }
  }
}

provider "azurerm" {
  features {
  }
}

resource "azurerm_resource_group" "rg" {
  name     = var.rg_name
  location = var.location
}

# Create virtual network
resource "azurerm_virtual_network" "virtual_network" {
  name                = var.vnet_name
  address_space       = ["10.0.0.0/16"]
  subnet              = []
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
}

resource "azurerm_subnet" "subnet1" {
  name                 = var.subnet
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.virtual_network.name
  address_prefixes     = ["10.0.0.0/17"]

}

resource "azurerm_network_security_group" "nsg_group" {
  name                = var.nsg_name
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  security_rule {
    name                       = "AllowSSH"
    priority                   = 100
    access                     = "Allow"
    protocol                   = "Tcp"
    destination_address_prefix = "*"
    source_address_prefix      = "*"
    direction                  = "Inbound"
    source_port_range          = "*"
    destination_port_range     = "22"
  }

  security_rule {
    name                       = "AllowGrafana"
    priority                   = 110
    access                     = "Allow"
    protocol                   = "Tcp"
    destination_address_prefix = "*"
    source_address_prefix      = "*"
    direction                  = "Inbound"
    source_port_range          = "*"
    destination_port_range     = "3000"
  }

  security_rule {
    name                       = "AllowPrometheus"
    priority                   = 120
    access                     = "Allow"
    protocol                   = "Tcp"
    destination_address_prefix = "*"
    source_address_prefix      = "*"
    direction                  = "Inbound"
    source_port_range          = "*"
    destination_port_range     = "9090"
  }
}

resource "azurerm_subnet_network_security_group_association" "association" {
  subnet_id                 = azurerm_subnet.subnet1.id
  network_security_group_id = azurerm_network_security_group.nsg_group.id
}

resource "azurerm_public_ip" "publicIP" {
  name                = var.publicIp_name
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  allocation_method   = "Static"
}

resource "azurerm_network_interface" "network_interface_vm_linux" {
  name                = var.network_interface_name
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  ip_configuration {
    name                          = var.ip_configuration_name
    subnet_id                     = azurerm_subnet.subnet1.id
    public_ip_address_id          = azurerm_public_ip.publicIP.id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_linux_virtual_machine" "vm_linux_name" {
  name                = var.linuxMachine_name
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  size                = var.vmLinuxSize
  admin_username      = var.user_name
  network_interface_ids = [
    azurerm_network_interface.network_interface_vm_linux.id
  ]

  admin_ssh_key {
    username   = var.user_name
    public_key = file(format("./%s", var.public_key_file_name))
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = var.storage_account_type
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-focal"
    sku       = "20_04-lts"
    version   = "latest"
  }
}

