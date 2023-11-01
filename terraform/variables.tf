variable "rg_name" {
  default = "rg3"
}

variable "location" {
  default = "eastus"
}

variable "vnet_name" {
  default = "virtual-vnet"
}

variable "subnet" {
  default = "subnet1"
}

variable "nsg_name" {
  default = "nsg1_group"
}

variable "public_key_file_name" {
  default = "public_key_file_name"
}

variable "private_key" {
  default = "private-key"
}

variable "user_name" {
  default = "azureuser"
}

variable "publicIp_name" {
  default = "publicIP"
}

variable "network_interface_name" {
  default = "network_interface_name"
}

variable "linuxMachine_name" {
  default = "linuxMachine"
}

variable "vmLinuxSize" {
  default = "Standard_B1s"
}

variable "storage_account_type" {
  default = "Standard_LRS"
}

variable "ip_configuration_name" {
  default = "ip_configuration_name"
}