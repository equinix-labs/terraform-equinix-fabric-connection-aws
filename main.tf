locals  {
   aws_dx_id = one([
       for action_data in one(module.equinix-fabric-connection.primary_connection.actions).required_data: action_data["value"]
       if action_data["key"] == "awsConnectionId"
   ])
   aws_vgw_id = var.aws_dx_create_vgw ? aws_vpn_gateway.this[0].id : var.aws_dx_vgw_id
   aws_vpc_id = var.aws_dx_create_vgw ? data.aws_vpc.this[0].id : ""
   aws_region = data.aws_region.this.name
}

data "aws_region" "this" {}

data "aws_vpc" "this" {
  count = var.aws_dx_create_vgw ? 1 : 0

  id      = var.aws_vpc_id == "" ? null : var.aws_vpc_id
  default = var.aws_vpc_id == "" ? true : null
}

resource "random_string" "this" {
  length  = 3
  special = false
}

module "equinix-fabric-connection" {
  source = "equinix-labs/fabric-connection/equinix"
  version = "0.3.1"

  # required variables
  notification_users = var.fabric_notification_users

  # optional variables
  name = var.fabric_connection_name

  seller_profile_name       = var.fabric_speed < 1000 ? "AWS Direct Connect" : "AWS Direct Connect - High Capacity"
  seller_metro_code         = var.fabric_destination_metro_code
  seller_metro_name         = var.fabric_destination_metro_name
  seller_region             = local.aws_region
  seller_authorization_key  = var.aws_account_id

  network_edge_id           = var.network_edge_device_id
  network_edge_interface_id = var.network_edge_device_interface_id
  port_name                 = var.fabric_port_name
  vlan_stag                 = var.fabric_vlan_stag
  service_token_id          = var.fabric_service_token_id
  speed                     = var.fabric_speed
  speed_unit                = "MB"
  purchase_order_number    = var.fabric_purchase_order_number
}

resource "aws_dx_connection_confirmation" "this" {
  connection_id = local.aws_dx_id
}

resource "aws_dx_private_virtual_interface" "this" {
  count = var.aws_dx_create_vif ? 1 : 0

  name             = var.aws_dx_vif_name != "" ? var.aws_dx_vif_name : lower(format("vif-%s", random_string.this.result))
  connection_id    = aws_dx_connection_confirmation.this.id

  address_family   = var.aws_dx_vif_address_family
  bgp_asn          = var.aws_dx_vif_customer_asn
  vlan             = module.equinix-fabric-connection.primary_connection.zside_vlan_stag
  amazon_address   = var.aws_dx_vif_amazon_address
  customer_address = var.aws_dx_vif_customer_address
  mtu              = var.aws_dx_mtu_size
  bgp_auth_key     = var.aws_dx_bgp_auth_key

  vpn_gateway_id   = local.aws_vgw_id

  tags = var.aws_tags
}

resource "aws_vpn_gateway" "this" {
  count = var.aws_dx_create_vgw ? 1 : 0

  vpc_id = local.aws_vpc_id
  tags = merge(
    var.aws_tags,
    {
      Name = var.aws_vpn_gateway_name != "" ? var.aws_vpn_gateway_name : lower(format("vgw-%s", random_string.this.result))
    },
  )
}

resource "equinix_network_bgp" "this" {
  count = alltrue([var.aws_dx_create_vif, var.network_edge_device_id != "", var.network_edge_configure_bgp]) ? 1 : 0

  connection_id      = module.equinix-fabric-connection.primary_connection.uuid
  local_ip_address   = aws_dx_private_virtual_interface.this[0].customer_address
  local_asn          = var.aws_dx_vif_customer_asn
  remote_ip_address  = split("/", aws_dx_private_virtual_interface.this[0].amazon_address)[0]
  remote_asn         = aws_dx_private_virtual_interface.this[0].amazon_side_asn
  authentication_key = aws_dx_private_virtual_interface.this[0].bgp_auth_key != "" ? aws_dx_private_virtual_interface.this[0].bgp_auth_key : null
}
