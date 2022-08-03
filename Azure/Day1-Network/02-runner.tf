##############################################################################################################
#
# Fortinet
# Infrastructure As Code Demo
# GitHub Actions - Terraform Cloud
#
##############################################################################################################
#
# Deployment of GitHub Action runner
#
##############################################################################################################

variable "runner_token" {
  type        = string
  description = "(Required) The Github actions self-hosted runner registration token"
}

variable "runner_version" {
  type        = string
  description = "(Optional) The version of the runner to use"
  default     = "2.289.2"
}

variable "github_repo" {
  type        = string
  description = "The Github repo to use"
  default     = "40net-cloud/github-actions-infra-as-code-demo"
}

data "template_file" "runner_custom_data" {
  template = file("${path.module}/customdata-runner.tpl")

  vars = {
    runner_version = var.runner_version
    runner_token   = var.runner_token
    github_repo    = var.github_repo
    username       = var.USERNAME
  }
}

variable "runner_tags" {
  type = map(string)
  default = {
    template : "GitHub Actions Runner Infra As Code Demo Azure",
    environment : "staging",
    type : "runner",
  }
}

##############################################################################################################

resource "random_id" "storage_account" {
  byte_length = 8
}

resource "azurerm_storage_account" "runnersa" {
  name                     = "tfsta${lower(random_id.storage_account.hex)}"
  resource_group_name      = azurerm_resource_group.resourcegroup.name
  location                 = azurerm_resource_group.resourcegroup.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

resource "azurerm_network_security_group" "runnernsg" {
  name                = "${var.PREFIX}-RUNNER-NSG"
  location            = var.LOCATION
  resource_group_name = azurerm_resource_group.resourcegroup.name
}

resource "azurerm_network_security_rule" "runnernsgallowallout" {
  name                        = "AllowAllOutbound"
  resource_group_name         = azurerm_resource_group.resourcegroup.name
  network_security_group_name = azurerm_network_security_group.runnernsg.name
  priority                    = 100
  direction                   = "Outbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "*"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
}

resource "azurerm_network_security_rule" "runnernsgallowallssh" {
  name                        = "AllowAllInbound"
  resource_group_name         = azurerm_resource_group.resourcegroup.name
  network_security_group_name = azurerm_network_security_group.runnernsg.name
  priority                    = 100
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "22"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
}

resource "azurerm_public_ip" "runnerpip" {
  name                = "${var.PREFIX}-RUNNER-VM-PIP"
  resource_group_name = azurerm_resource_group.resourcegroup.name
  location            = azurerm_resource_group.resourcegroup.location
  allocation_method   = "Static"

  tags = var.runner_tags
}

resource "azurerm_network_interface" "runnerifc" {
  name                 = "${var.PREFIX}-RUNNER-VM-ifc"
  location             = var.LOCATION
  resource_group_name  = azurerm_resource_group.resourcegroup.name
  enable_ip_forwarding = false

  ip_configuration {
    name                          = "interface1"
    subnet_id                     = azurerm_subnet.subnet4.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.runnerpip.id
  }

  tags = var.runner_tags
}

resource "azurerm_network_interface_security_group_association" "runnerifcnsg" {
  network_interface_id      = azurerm_network_interface.runnerifc.id
  network_security_group_id = azurerm_network_security_group.runnernsg.id
}

resource "azurerm_linux_virtual_machine" "runnervm" {
  name                  = "${var.PREFIX}-RUNNER-VM"
  location              = var.LOCATION
  resource_group_name   = azurerm_resource_group.resourcegroup.name
  network_interface_ids = [azurerm_network_interface.runnerifc.id]
  size                  = "Standard_B2s"

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-focal"
    sku       = "20_04-lts"
    version   = "latest"
  }

  os_disk {
    name                 = "${var.PREFIX}-RUNNER-VM-OSDISK"
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  admin_username                  = var.USERNAME
  admin_password                  = var.PASSWORD
  disable_password_authentication = false
  custom_data                     = base64encode(data.template_file.runner_custom_data.rendered)

  boot_diagnostics {
    storage_account_uri = azurerm_storage_account.runnersa.primary_blob_endpoint
  }

  tags = var.runner_tags
}
