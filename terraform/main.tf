terraform {
  required_version = ">= 0.12"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0.2"
    }
  }

  # backend "azurerm" {
  #   resource_group_name  = "rg2"
  #   storage_account_name = "stacterraform12"
  #   container_name       = "terraforminit"
  #   key                  = "terraform.tfstate"
  # }
}

provider "azurerm" {
  features {
    resource_group {
      prevent_deletion_if_contains_resources = false
    }
  }
}

resource "azurerm_resource_group" "rg" {
  name     = var.rg_name
  location = var.var_location
}

# Create virtual network
resource "azurerm_virtual_network" "virtual_network" {
  name                = "virtual-vnet"
  address_space       = ["10.0.0.0/16"]
  subnet              = []
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
}

resource "azurerm_subnet" "subnet1" {
  name                 = var.var_subnet
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.virtual_network.name
  address_prefixes     = ["10.0.0.0/17"]

}

resource "azurerm_network_security_group" "nsg_group" {
  name                = var.var_nsg_name
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  security_rule {
    name                       = "nsg_rule1"
    priority                   = 100
    access                     = "Allow"
    protocol                   = "Tcp"
    destination_address_prefix = "*"
    source_address_prefix      = "*"
    direction                  = "Inbound"
    source_port_range          = "*"
    destination_port_range     = "*"
  }
}

resource "azurerm_subnet_network_security_group_association" "association" {
  subnet_id                 = azurerm_subnet.subnet1.id
  network_security_group_id = azurerm_network_security_group.nsg_group.id
}

resource "azurerm_public_ip" "publicIP" {
  name                = "publicIp1"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  allocation_method   = "Dynamic"
  depends_on = [ azurerm_linux_virtual_machine.vm_linux_name ]
}

resource "azurerm_network_interface" "network_interface_vm_linux" {
  name                = "network_interface_name"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  ip_configuration {
    name                          = "ip_configuration_name"
    subnet_id                     = azurerm_subnet.subnet1.id
    public_ip_address_id          = azurerm_public_ip.publicIP.id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_linux_virtual_machine" "vm_linux_name" {
  name                = "linuxMachine"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  size                = "Standard_B1s"
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
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-focal"
    sku       = "20_04-lts"
    version   = "latest"
  }
}

