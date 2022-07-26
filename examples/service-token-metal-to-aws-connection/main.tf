// Interacting with Equinix Metal requires an API auth token in addition to the Equinix API
// credentials. See provider docs for further details
// https://registry.terraform.io/providers/equinix/equinix/latest/docs
provider "equinix" {
  client_id     = var.equinix_provider_client_id
  client_secret = var.equinix_provider_client_secret
  auth_token    = var.equinix_provider_auth_token
}

provider "aws" { 
  region = var.aws_region
}

## Retrieve an existing equinix metal project
## If you prefer you can use resource equinix_metal_project instead to create a fresh project
data "equinix_metal_project" "this" {
  project_id = var.metal_project_id
}

locals {
  connection_name = format("conn-metal-aws-%s", lower(var.fabric_destination_metro_code))
}

# Create a new VLAN in Frankfurt
resource "equinix_metal_vlan" "this" {
  description = format("VLAN in %s", var.fabric_destination_metro_code)
  metro       = var.fabric_destination_metro_code
  project_id  = data.equinix_metal_project.this.project_id
}

## Request a connection service token in Equinix Metal
resource "equinix_metal_connection" "this" {
    name               = local.connection_name
    project_id         = data.equinix_metal_project.this.project_id
    metro              = var.fabric_destination_metro_code
    redundancy         = var.redundancy_type == "SINGLE" ? "primary" : "redundant"
    type               = "shared"
    service_token_type = "a_side"
    description        = format("connection to AWS in %s", var.fabric_destination_metro_code)
    speed              = format("%dMbps", var.fabric_speed)
    vlans              = [equinix_metal_vlan.this.vxlan]
}

## Create an AWS VPC
resource "aws_vpc" "this" {
  cidr_block = "10.0.0.0/16"
}

## Configure the Equinix Fabric connection from Equinix Metal to AWS using the metal connection service token
module "equinix-fabric-connection-aws-primary" {
  source = "equinix-labs/fabric-connection-aws/equinix"
  
  fabric_notification_users     = var.fabric_notification_users
  fabric_connection_name        = local.connection_name
  fabric_destination_metro_code = var.fabric_destination_metro_code
  fabric_speed                  = var.fabric_speed
  fabric_service_token_id       = equinix_metal_connection.this.service_tokens.0.id
  
  aws_account_id = var.aws_account_id

  aws_dx_create_vgw = true
  aws_vpc_id        = aws_vpc.this.id // If not specified 'Default' VPC will be used

  ## BGP and Direct Connect private virtual interface config
  aws_dx_create_vif           = true
  # aws_dx_vif_address_family   = // If unspecified, default value "ipv4" will be used
  aws_dx_vif_amazon_address   = "169.254.0.1/30" // If unspecified, default value "169.254.0.1/30" will be used
  aws_dx_vif_customer_address = "169.254.0.2/30" // If unspecified, default value "169.254.0.2/30" will be used
  # aws_dx_vif_customer_asn     = // If unspecified, default value "65000" will be used
  # aws_dx_mtu_size             = // If unspecified, default value 1500 will be used
  aws_dx_bgp_auth_key         = random_password.this.result
}

## If redundancy_type is REDUNDANT, configure a secondary Equinix Fabric connection from Equinix Metal to AWS using the metal connection service token
module "equinix-fabric-connection-aws-secondary" {
  source = "equinix-labs/fabric-connection-aws/equinix"

  count = var.redundancy_type == "REDUNDANT" ? 1 : 0

  fabric_notification_users     = var.fabric_notification_users
  fabric_connection_name        = format("%s-SEC", local.connection_name)
  fabric_destination_metro_code = var.fabric_destination_metro_code
  fabric_speed                  = var.fabric_speed
  fabric_service_token_id       = equinix_metal_connection.this.service_tokens.1.id
  
  aws_account_id = var.aws_account_id

  aws_dx_create_vgw = false
  aws_dx_vgw_id     = module.equinix-fabric-connection-aws-primary.aws_vgw_id // we use vgw created in module.equinix-fabric-connection-aws-primary
  aws_vpc_id        = aws_vpc.this.id // If not specified 'Default' VPC will be used

  ## BGP and Direct Connect private virtual interface config
  aws_dx_create_vif           = true
  # aws_dx_vif_address_family   = // If unspecified, default value "ipv4" will be used
  aws_dx_vif_amazon_address   = "169.254.10.1/30" // since we use same vgw for primary connection, value must be different from module.equinix-fabric-connection-aws-primary
  aws_dx_vif_customer_address = "169.254.10.2/30" // since we use same vgw for primary connection, value must be different from module.equinix-fabric-connection-aws-primary
  # aws_dx_vif_customer_asn     = // If unspecified, default value "65000" will be used
  # aws_dx_mtu_size             = // If unspecified, default value 1500 will be used
  aws_dx_bgp_auth_key         = random_password.this.result
}

## Optionally we use an auto-generated password to enable authentication (shared key) between the two BGP peers
resource "random_password" "this" {
  length           = 12
  special          = true
  override_special = "$%&*()-_=+[]{}<>:?"
}
