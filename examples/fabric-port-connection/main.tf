provider "equinix" {}

provider "aws" { region = "eu-central-1" }

module "equinix-fabric-connection-aws" {
  source = "equinix-labs/fabric-connection-aws/equinix"

  # required variables
  fabric_notification_users = ["example@equinix.com"]
  aws_account_id            = var.aws_account_id

  # optional variables
  fabric_port_name              = var.port_name
  fabric_vlan_stag              = 1010
  fabric_destination_metro_code = "FR"
}
