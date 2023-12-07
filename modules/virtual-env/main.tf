locals {
  location            = "eastus2"
  imageID             = "/subscriptions/b9e38f20-7c9c-4497-a25d-1a0c5eef2108/resourceGroups/IaC-hardware-sim/providers/Microsoft.Compute/galleries/vHci/images/vHCI-Specialized/versions/1.0.0"
  resource_group_name = "test-rg"
  vm_name             = "virtualhci"
}


resource "azurerm_resource_group" "rg" {
  location = local.location
  name     = local.resource_group_name
}
resource "azurerm_managed_disk" "res" {
  count = 6
  create_option              = "FromImage"
  gallery_image_reference_id = local.imageID
  location                   = local.location
  name                       = "${local.vm_name}_lun_${count.index}_2_60e2470395da4beaa9d44665b304d912"
  resource_group_name        = azurerm_resource_group.rg.name
  storage_account_type       = "Premium_LRS"
  tags = {
    "platformsettings.host_environment.service.platform_optedin_for_rootcerts" = "true"
  }
}

resource "azurerm_virtual_machine" "vm" {
  location              = local.location
  name                  = local.vm_name
  network_interface_ids = [azurerm_network_interface.network-interface.id]
  resource_group_name   = azurerm_resource_group.rg.name
  tags = {
    "platformsettings.host_environment.service.platform_optedin_for_rootcerts" = "true"
  }
  vm_size = "Standard_E32s_v5"
  delete_os_disk_on_termination = true
  storage_image_reference {
    id = local.imageID
  }
  boot_diagnostics {
    enabled     = true
    storage_uri = ""
  }
  storage_os_disk {
    create_option = "FromImage"
    name          = "${local.vm_name}_OsDisk_1_0e0e73c422a24b6daf1df9216c226f24"
  }
  depends_on = [
    azurerm_network_interface.network-interface,
  ]
}
resource "azurerm_network_interface" "network-interface" {
  location            = local.location
  name                = "${local.vm_name}946"
  resource_group_name = azurerm_resource_group.rg.name
  ip_configuration {
    name                          = "ipconfig1"
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.publicip.id
    subnet_id                     = azurerm_subnet.subnet.id
  }
  depends_on = [
    azurerm_public_ip.publicip,
    azurerm_subnet.subnet,
  ]
}
resource "azurerm_network_interface_security_group_association" "res-9" {
  network_interface_id      = azurerm_network_interface.network-interface.id
  network_security_group_id = azurerm_network_security_group.network-sg.id
  depends_on = [
    azurerm_network_interface.network-interface,
    azurerm_network_security_group.network-sg,
  ]
}
resource "azurerm_network_security_group" "network-sg" {
  location            = local.location
  name                = "${local.vm_name}-nsg"
  resource_group_name = azurerm_resource_group.rg.name
}
resource "azurerm_network_security_rule" "res-11" {
  access                      = "Allow"
  destination_address_prefix  = "*"
  destination_port_range      = "*"
  direction                   = "Inbound"
  name                        = "NRMS-Rule-103"
  network_security_group_name = azurerm_network_security_group.network-sg.name
  priority                    = 103
  protocol                    = "*"
  resource_group_name         = azurerm_resource_group.rg.name
  source_address_prefix       = "CorpNetPublic"
  source_port_range           = "*"
  depends_on = [
    azurerm_network_security_group.network-sg,
  ]
}
resource "azurerm_network_security_rule" "res-12" {
  access                      = "Allow"
  destination_address_prefix  = "*"
  destination_port_range      = "*"
  direction                   = "Inbound"
  name                        = "NRMS-Rule-104"
  network_security_group_name = azurerm_network_security_group.network-sg.name
  priority                    = 104
  protocol                    = "*"
  resource_group_name         = azurerm_resource_group.rg.name
  source_address_prefix       = "CorpNetSaw"
  source_port_range           = "*"
  depends_on = [
    azurerm_network_security_group.network-sg,
  ]
}
resource "azurerm_public_ip" "publicip" {
  allocation_method   = "Static"
  location            = local.location
  name                = "${local.vm_name}-ip"
  resource_group_name = azurerm_resource_group.rg.name
  sku                 = "Standard"
}
resource "azurerm_virtual_network" "virtual-network" {
  address_space       = ["172.17.0.0/16"]
  location            = local.location
  name                = "${local.vm_name}-vnet"
  resource_group_name = azurerm_resource_group.rg.name
}
resource "azurerm_subnet" "subnet" {
  address_prefixes     = ["172.17.0.0/24"]
  name                 = "default"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = "${local.vm_name}-vnet"
  depends_on = [
    azurerm_virtual_network.virtual-network,
  ]
}
