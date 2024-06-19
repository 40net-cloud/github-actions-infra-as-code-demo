##############################################################################################################
#
# Fortinet
# Infrastructure As Code Demo
# GitHub Actions - Terraform Cloud
# Platform: Azure
#
##############################################################################################################
#
# Deployment in Microsoft Azure
#
##############################################################################################################

terraform {
  required_version = ">= 1.0"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">=2.0.0"
    }
    fortiflexvm = {
      source  = "fortinetdev/fortiflexvm"
      version = ">=2.0.0"
    }
  }

  backend "remote" {
    organization = "rrother_fortinet"

    workspaces {
      name = "github-actions-infra-as-code-demo-azure"
    }
  }
}

provider "fortiflexvm" {
  username = var.FORTIFLEX_USERNAME
  password = var.FORTIFLEX_PASSWORD
}

provider "azurerm" {
  features {}
}

