provider "equinix" {}

provider "aws" { region = "eu-central-1" }

variable "aws_account_id" {}

variable "port_name" {}

module "equinix-fabric-connection-aws" {
  source = "github.com/equinix-labs/terraform-equinix-fabric-connection-aws"

  # required variables
  fabric_notification_users = ["example@equinix.com"]
  aws_account_id            = var.aws_account_id

  # optional variables
  fabric_port_name              = var.port_name
  fabric_vlan_stag              = 1010
  fabric_destination_metro_code = "FR"
}

output "connection_details" {
  value = module.equinix-fabric-connection-aws
}
