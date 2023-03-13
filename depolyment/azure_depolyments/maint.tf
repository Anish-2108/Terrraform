terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = "=3.0.0"
    }
  }
}

provider "azurerm" {
  features {
  }

  subscription_id   = "2c8f4502-a330-4e85-9858-5ac7d37b2019"
  tenant_id         = "cb77aef3-a720-4313-a825-6a8d5d19ed26"
  client_id         = "1bd22c10-a776-49f8-81ff-ddf4cb4de35c"
  client_secret     = "iR-8Q~jqw1JLm7ieM1pSIPYEaHCgrLTNBAIeSbp0"
}

resource "azurerm_resource_group" "anish_tftest" {
  name     = "anish_tftest"
  location = "West Europe"
  tags = {
    environment = "dev"
  }
}

resource "azurerm_virtual_network" "vnet1" {
  name                = "tftesting_network"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.anish_tftest.location
  resource_group_name = azurerm_resource_group.anish_tftest.name
}
resource "azurerm_subnet" "tftesting_internal" {
  name                 = "tftesting_internal"
  resource_group_name  = azurerm_resource_group.anish_tftest.name
  virtual_network_name = azurerm_virtual_network.vnet1.name
  address_prefixes     = ["10.0.2.0/24"]
}

resource "azurerm_network_interface" "tftesting_internal_main" {
  name                = "tftesting_internal-nic"
  location            = azurerm_resource_group.anish_tftest.location
  resource_group_name = azurerm_resource_group.anish_tftest.name

  ip_configuration {
    name                          = "testconfiguration1"
    subnet_id                     = azurerm_subnet.tftesting_internal.id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_virtual_machine" "tftesting_main" {
  name                  = "tftesting-vm"
  location              = azurerm_resource_group.anish_tftest.location
  resource_group_name   = azurerm_resource_group.anish_tftest.name
  network_interface_ids = [azurerm_network_interface.tftesting_internal_main.id]
  vm_size               = "Standard_DS1_v2"

  # Uncomment this line to delete the OS disk automatically when deleting the VM
  # delete_os_disk_on_termination = true

  # Uncomment this line to delete the data disks automatically when deleting the VM
  # delete_data_disks_on_termination = true

  storage_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "16.04-LTS"
    version   = "latest"
  }
  storage_os_disk {
    name              = "myosdisk1"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }
  os_profile {
    computer_name  = "hostname"
    admin_username = "testadmin"
    admin_password = "Password1234!"
  }
  os_profile_linux_config {
    disable_password_authentication = false
  }
  tags = {
    environment = "staging"
  }
}
