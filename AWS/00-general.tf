##############################################################################################################
#
# Fortinet
# Infrastructure As Code Demo
# GitHub Actions - Terraform Cloud
# Platform: AWS
#
##############################################################################################################
#
# Variables during deployment the first 7  are mandatory:
#   PREFIX, LOCATION, USERNAME, PASSWORD, ACCESS_KEY, SECRET_KEY, KEY_PAIR
#
##############################################################################################################

# Prefix for all resources created for this deployment in Microsoft Azure
variable "PREFIX" {
  description = "Added name to each deployed resource"
}

variable "REGION" {
  description = "AWS region"
}

variable "USERNAME" {
}

variable "PASSWORD" {
}

//AWS Configuration
variable "ACCESS_KEY" {}
variable "SECRET_KEY" {}

//  Existing SSH Key on the AWS
variable "KEY_PAIR" {
  default = ""
}

##############################################################################################################
# FortiGate license type
##############################################################################################################

// License Type to create FortiGate-VM
// Provide the license type for FortiGate-VM Instances, either byol or payg.
variable "FGT_LICENSE_TYPE" {
  default = "byol"
}

variable "FGT_IMAGE_SKU" {
  description = "Azure Marketplace default image sku hourly (PAYG 'fortinet_fg-vm_payg_20190624') or byol (Bring your own license 'fortinet_fg-vm')"
  default     = "fortinet_fg-vm_payg_20190624"
}

variable "FGT_VERSION" {
  description = "FortiGate version by default the 'latest' available version in the Azure Marketplace is selected"
  default     = "latest"
}

variable "FGT_BYOL_LICENSE_FILE" {
  default = ""
}

variable "FGT_BYOL_FORTIFLEX_LICENSE_FILE" {
  default = ""
}

variable "FGT_SSH_PUBLIC_KEY_FILE" {
  default = ""
}

##############################################################################################################
# Deployment in AWS
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
      name = "github-actions-infra-as-code-demo-aws"
    }
  }
}

//AWS Configuration
provider "aws" {
  region     = var.REGION
  access_key = var.ACCESS_KEY
  secret_key = var.SECRET_KEY
}

// Availability zones for the region
locals {
  az1 = "${var.REGION}a"
}

variable "vpccidr" {
  default = "10.1.0.0/16"
}

variable "publiccidraz1" {
  default = "10.1.0.0/24"
}

variable "privatecidraz1" {
  default = "10.1.1.0/24"
}


// AMIs are for FGTVM-AWS(PAYG) - 7.0.2
variable "fgtvmami" {
  type = map(any)
  default = {
    us-west-2      = "ami-0e569295bb3f6ab11"
    us-west-1      = "ami-095959eb30adfa9a3"
    us-east-1      = "ami-0f37125f0c38e8ea8"
    us-east-2      = "ami-06793c2af5608535d"
    ap-east-1      = "ami-0699af54b4633491a"
    ap-south-1     = "ami-0a127f57954a4a1f2"
    ap-northeast-3 = "ami-09ad17171ea4eff8d"
    ap-northeast-2 = "ami-0d3c494bb99d82447"
    ap-southeast-1 = "ami-00112697759f99d8d"
    ap-southeast-2 = "ami-07452c768a8cbed39"
    ap-northeast-1 = "ami-03e8c6e055020dd9b"
    ca-central-1   = "ami-0ede51ef40cee3efa"
    eu-central-1   = "ami-07e1b42208e73e245"
    eu-west-1      = "ami-0fab4ac7da7ff40e7"
    eu-west-2      = "ami-0c061b51af9e9b077"
    eu-south-1     = "ami-0cb93c71083b7dae7"
    eu-west-3      = "ami-0fdfb85a314198974"
    eu-north-1     = "ami-03107d291accd5ea4"
    me-south-1     = "ami-0ad2dfcb40065e84a"
    sa-east-1      = "ami-03dde0d83f69a5982"
  }
}


// AMIs are for FGTVM AWS(BYOL) - 7.0.2
variable "fgtvmbyolami" {
  type = map(any)
  default = {
    us-west-2      = "ami-05558fc4d58e0311d"
    us-west-1      = "ami-02b8386b83b22a768"
    us-east-1      = "ami-03b05077372374ac2"
    us-east-2      = "ami-0d64f9d41d2c347fe"
    ap-east-1      = "ami-0aebd5b952425a493"
    ap-south-1     = "ami-015b6108d837a11bb"
    ap-northeast-3 = "ami-09eabd6630c92b02f"
    ap-northeast-2 = "ami-0575bff848509c6d8"
    ap-southeast-1 = "ami-0c36d980e164c3372"
    ap-southeast-2 = "ami-06217cfb67db81bd7"
    ap-northeast-1 = "ami-046d2f9510157fe5a"
    ca-central-1   = "ami-014a19c8175403554"
    eu-central-1   = "ami-090da6c908c1127f6"
    eu-west-1      = "ami-082aa757173803c84"
    eu-west-2      = "ami-0ab723f14117aa285"
    eu-south-1     = "ami-0472705b9d0a4e155"
    eu-west-3      = "ami-0b4e3a514d31d3a79"
    eu-north-1     = "ami-0a48ff95e49c70174"
    me-south-1     = "ami-03a43777cd244fca4"
    sa-east-1      = "ami-094f94451eda5df8b"
  }
}



variable "size" {
  default = "c5n.xlarge"
}

variable "adminsport" {
  default = "8443"
}

variable "bootstrap-fgtvm" {
  // Change to your own path
  type    = string
  default = "customdata-fgt.tpl"
}

// license file for the active fgt
variable "license" {
  // Change to your own byol license file, license.lic
  type    = string
  default = ""
}

variable "fortinet_tags" {
  type = map(string)
  default = {
    publisher : "Fortinet",
    template : "GitHub Actions Infra As Code Demo AWS",
  }
}
