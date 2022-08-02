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

data "tfe_outputs" "network" {
  organization = "40net-cloud"
  workspace = "github-actions-infra-as-code-demo-azure-network"
}

variable "test" {
  type        = list(string)
  description = ""

  default = [
    "172.16.140.5",
    "172.16.140.69"
  ]
}

##############################################################################################################

output "test" {
  sensitive = true
  value = split("/", data.tfe_outputs.network.values.vnet_subnet[0])[1]
}

output "test2" {
  value = data.terraform_remote_state.vnet_subnet_id.outputs["vnet_subnet"][1]
}

output "test3" {
  value = var.test[0]
}

##############################################################################################################