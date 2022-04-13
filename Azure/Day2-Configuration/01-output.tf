##############################################################################################################
#
# Fortinet
# Infrastructure As Code Demo
# GitHub Actions - Terraform Cloud
#
##############################################################################################################
#
# Output summary of deployment
#
##############################################################################################################

##############################################################################################################
# Deployment in Microsoft Azure
##############################################################################################################

terraform {
  required_version = ">= 0.12"
  required_providers {
  }

  backend "remote" {
    organization = "40net-cloud"

    workspaces {
      name = "github-actions-infra-as-code-demo-azure-configuration"
    }
  }
}

# Prefix for all resources created for this deployment in Microsoft Azure
variable "FMG_HOST" {
  description = "FortiManager Host"
}

variable "FMG_USERNAME" {
  description = "FortiManager username"
}

variable "FMG_PASSWORD" {
  description = "FortiManager password"
}

variable "FMG_PORT" {
  description = "FortiManager port"
  default     = "443"
}

variable "ARM_CLIENT_ID" {
  description = "Service Principal Client ID"
}

variable "ARM_CLIENT_SECRET" {
  description = "Service Principal Client Secret"
}

variable "ARM_SUBSCRIPTION_ID" {
  description = "Service Principal Subscription ID"
}

variable "ARM_TENANT_ID" {
  description = "Service Principal Tenant ID"
}

data "template_file" "ansible_inventory" {
  template = file("${path.module}/ansible-inventory.tpl")

  vars = {
    fmg_host     = var.FMG_HOST
    fmg_username = var.FMG_USERNAME
    fmg_password = var.FMG_PASSWORD
    fmg_port     = var.FMG_PORT
  }
}

data "template_file" "ansible_connectors" {
  template = file("${path.module}/ansible-connectors.tpl")

  vars = {
    arm_client_id      = var.ARM_CLIENT_ID
    arm_client_secret  = var.ARM_CLIENT_SECRET
    arm_subscription_id = var.ARM_SUBSCRIPTION_ID
    arm_tenant_id      = var.ARM_TENANT_ID
  }
}

output "ansible_inventory" {
  value = data.template_file.ansible_inventory.rendered
}

output "ansible_connectors" {
  value = data.template_file.ansible_connectors.rendered
}
##############################################################################################################