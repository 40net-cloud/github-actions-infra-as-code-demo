##############################################################################################################
#
##############################################################################################################

data "terraform_remote_state" "vnet" {
  backend = "remote"

  config = {
    organization = "40net-cloud"
    workspaces = {
      name = "github-actions-infra-as-code-demo-azure-network"
    }
  }
}

data "terraform_remote_state" "vnet_subnet" {
  backend = "remote"

  config = {
    organization = "40net-cloud"
    workspaces = {
      name = "github-actions-infra-as-code-demo-azure-network"
    }
  }
}

data "terraform_remote_state" "vnet_subnet_id" {
  backend = "remote"

  config = {
    organization = "40net-cloud"
    workspaces = {
      name = "github-actions-infra-as-code-demo-azure-network"
    }
  }
}

data "tfe_outputs" "vnet_subnet" {
  organization = "40net-cloud"
  workspace = "github-actions-infra-as-code-demo-azure-network"
}

variable "test" {
  type        = list(string)
  description = ""

  default = [
    "172.16.136.5",
    "172.16.136.69"
  ]
}

##############################################################################################################

output "test" {
  sensitive = true
  value = data.tfe_outputs.vnet_subnet
}

output "test2" {
  value = data.terraform_remote_state.vnet_subnet_id.outputs["vnet_subnet"][1]
}

output "test3" {
  value = var.test[0]
}

##############################################################################################################