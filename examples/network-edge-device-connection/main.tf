provider "equinix" {}

provider "aws" { region = "eu-central-1" }

module "equinix-fabric-connection-aws" {
  source = "github.com/equinix-labs/terraform-equinix-fabric-connection-aws"

  # required variables
  fabric_notification_users = ["example@equinix.com"]
  aws_account_id            = var.aws_account_id

  # optional variables
  network_edge_device_id        = var.device_id
  network_edge_configure_bgp    = true

  fabric_destination_metro_code = "FR"
  fabric_speed                  = 200

  aws_dx_create_vif = true
  aws_dx_create_vgw = true
  aws_vpc_id        = "" // If not specified 'Default' VPC will be used
}
