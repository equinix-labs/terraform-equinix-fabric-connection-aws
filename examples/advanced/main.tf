provider "equinix" {}

provider "aws" { region = "eu-central-1" }

variable "port_name" {}

variable "aws_account_id" {}

module "equinix-fabric-connection-aws" {
  source = "github.com/equinix-labs/terraform-equinix-fabric-connection-aws"

  # required variables
  fabric_notification_users = ["example@equinix.com"]
  aws_account_id            = var.aws_account_id

  # optional variables
  fabric_port_name              = var.port_name
  fabric_vlan_stag              = 1010
  fabric_destination_metro_code = "FR"
  fabric_speed                  = 100

  aws_dx_create_private_vif           = true
  aws_dx_private_vif_amazon_address   = "169.254.0.1/30"
  aws_dx_private_vif_customer_address = "169.254.0.2/30"
  aws_dx_create_vgw                   = true
  aws_vpc_id                          = aws_vpc.this.id
}

resource "aws_vpc" "this" {
  cidr_block = "10.255.255.0/28"

  tags = {
    Name = "VPC-Example"
  }
}
