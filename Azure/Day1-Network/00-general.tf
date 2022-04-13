##############################################################################################################
#
# Fortinet
# Infrastructure As Code Demo
# GitHub Actions - Terraform Cloud
#
##############################################################################################################
#
#
# Variables during deployment the first 4 (PREFIX, LOCATION, USERNAME, PASSWORD) are mandatory
#
#
##############################################################################################################

# Prefix for all resources created for this deployment in Microsoft Azure
variable "PREFIX" {
  description = "Added name to each deployed resource"
}

variable "LOCATION" {
  description = "Azure region"
}

variable "USERNAME" {
}

variable "PASSWORD" {
}

variable "VPN_PSK" {
  description = "VPN Site-2-Site PSK"
}

##############################################################################################################
# Deployment in Microsoft Azure
##############################################################################################################

terraform {
  required_version = ">= 0.12"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">=2.0.0"
    }
  }

  backend "remote" {
    organization = "40net-cloud"

    workspaces {
      name = "github-actions-infra-as-code-demo-azure-network"
    }
  }
}

provider "azurerm" {
  features {}
}

##############################################################################################################
# Static variables
##############################################################################################################

variable "vnet" {
  description = ""
  default     = "172.16.136.0/22"
}

variable "subnet" {
  type        = map(string)
  description = ""

  default = {
    "1" = "172.16.136.0/26"   # External
    "2" = "172.16.136.64/26"  # Internal
    "3" = "172.16.136.192/27" # Gateway Subnet
    "4" = "172.16.136.224/27" # Management
    "5" = "172.16.137.0/24"   # Protected a
    "6" = "172.16.138.0/24"   # Protected b
  }
}

variable "subnetmask" {
  type        = map(string)
  description = ""

  default = {
    "1" = "26" # External
    "2" = "26" # Internal
    "3" = "27" # GatewaySubnet
    "4" = "27" # Management
    "5" = "24" # Protected a
    "6" = "24" # Protected b
  }
}

variable "fgt_internalip" {
  description = ""
  default     = "172.16.136.69"
}

variable "fortinet_tags" {
  type = map(string)
  default = {
    publisher : "Fortinet",
    template : "GitHub Actions Infra As Code Demo Azure",
    environment : "staging"
  }
}

##############################################################################################################
# Resource Group
##############################################################################################################

resource "azurerm_resource_group" "resourcegroup" {
  name     = "${var.PREFIX}-RG"
  location = var.LOCATION
  tags     = var.fortinet_tags
}

##############################################################################################################

