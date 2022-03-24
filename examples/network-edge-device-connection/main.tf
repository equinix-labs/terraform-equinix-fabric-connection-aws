provider "equinix" {}

provider "aws" { region = "eu-central-1" }

variable "equinix_ne_device_id" {}

variable "aws_account_id" {}

module "equinix-fabric-connection-aws" {
  source = "github.com/equinix-labs/terraform-equinix-fabric-connection-aws"

  # required variables
  fabric_notification_users = ["example@equinix.com"]
  aws_account_id            = var.aws_account_id

  # optional variables
  network_edge_device_id        = var.equinix_ne_device_id
  network_edge_configure_bgp    = true

  fabric_destination_metro_code = "FR"
  fabric_speed                  = 200

  aws_dx_create_vif           = true
  aws_dx_create_vgw           = true
  aws_vpc_id                  = aws_vpc.this.id
}

resource "aws_vpc" "this" {
  cidr_block = "10.255.255.0/28"

  tags = {
    Name = "VPC-Example"
  }
}
