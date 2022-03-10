variable "fabric_notification_users" {
  type        = list(string)
  description = "A list of email addresses used for sending connection update notifications."

  validation {
    condition     = length(var.fabric_notification_users) > 0
    error_message = "Notification list cannot be empty."
  }
}

variable "fabric_connection_name" {
  type        = string
  description = "Name of the connection resource that will be created. It will be auto-generated if not specified."
  default     = ""
}

variable "fabric_destination_metro_code" {
  type        = string
  description = <<EOF
  Destination Metro code where the connection will be created. If you do not know the code,'fabric_destination_metro_name' can be use
  instead.
  EOF
  default     = ""

  validation {
    condition = ( 
      var.fabric_destination_metro_code == "" ? true : can(regex("^[A-Z]{2}$", var.fabric_destination_metro_code))
    )
    error_message = "Valid metro code consits of two capital leters, i.e. 'FR', 'SV', 'DC'."
  }
}

variable "fabric_destination_metro_name" {
  type        = string
  description = <<EOF
  Only required in the absence of 'fabric_destination_metro_code'. Metro name where the connection will be created, i.e.
  'Frankfurt', 'Silicon Valley', 'Ashburn'. One of 'metro_code', 'metro_name' must be
  provided.
  EOF
  default     = ""
}

variable "network_edge_device_id" {
  type        = string
  description = "Unique identifier of the Network Edge virtual device from which the connection would originate."
  default     = ""
}

variable "network_edge_device_interface_id" {
  type        = number
  description = <<EOF
  Applicable with 'network_edge_device_id', identifier of network interface on a given device, used for a connection. If not
  specified then first available interface will be selected.
  EOF
  default     = 0
}

variable "fabric_port_name" {
  type        = string
  description = <<EOF
  Name of the buyer's port from which the connection would originate. One of 'fabric_port_name',
  'network_edge_device_id' or 'fabric_service_token_id' is required.
  EOF
  default     = ""
}

variable "fabric_vlan_stag" {
  type        = number
  description = <<EOF
  S-Tag/Outer-Tag of the primary connection - a numeric character ranging from 2 - 4094. Required if
  'port_name' is specified.
  EOF
  default     = 0
}

variable "fabric_service_token_id" {
  type        = string
  description = <<EOF
  Unique Equinix Fabric key shared with you by a provider that grants you authorization to use their interconnection
  asset from which the connection would originate.
  EOF
  default     = ""
}

variable "fabric_speed" {
  type        = number
  description = <<EOF
  Speed/Bandwidth in Mbps to be allocated to the connection. If not specified, it will be used the minimum
  bandwidth available for the AWS service profile.
  EOF
  default     = 0

  validation {
    condition = contains([0, 50, 100, 200, 300, 400, 500, 1000, 2000, 5000, 10000], var.fabric_speed)
    error_message = "Valid values are (50, 100, 200, 300, 400, 500, 1000, 2000, 5000, 10000)."
  }
}

variable "fabric_purcharse_order_number" {
  type        = string
  description = "Connection's purchase order number to reflect on the invoice."
  default     = ""
}

variable "aws_account_id" {
  type        = string
  description = "Your AWS account ID. Required in Equinix Fabric as authorization key."
}

variable "aws_dx_create_private_vif" {
  type        = bool
  description = "Create a DX Private virtual Interface."
  default     = false
}

variable "aws_dx_private_vif_name" {
  type        = string
  description = "The name for the virtual interface. It will be auto-generated if not specified."
  default     = ""
}

variable "aws_dx_create_vgw" {
  type        = bool
  description = "Create a Virtual Private Gateway."
  default     = false
}

variable "aws_dx_vgw_id" {
  type        = string
  description = <<EOF
  If 'aws_dx_create_private_vif' is true but you already have an existing VGW you can left 'aws_dx_create_vgw' false
  and set your VGW id instead.
  EOF
  default     = ""
}

variable "aws_vpc_id" {
  type        = string
  description = "The VPC ID to create the VGW. Required if 'aws_dx_create_vgw' is true."
  default     = ""
}

variable "aws_vpn_gateway_name" {
  type        = string
  description = "The name for the VPC VPN Gateway. It will be auto-generated if not specified."
  default     = ""
}

variable "aws_dx_private_vif_address_family" {
  type        = string
  description = "The address family for the BGP peer. ipv4 or ipv6"
  default     = "ipv4"

  validation {
    condition = contains(["ipv4", "ipv6"], var.aws_dx_private_vif_address_family)
    error_message = "Valid values are (ipv4, ipv6)."
  }
}

variable "aws_dx_private_vif_bgp_asn" {
  type        = string
  description = "The autonomous system (AS) number for Border Gateway Protocol (BGP) configuration."
  default     = "65000"
}

variable "aws_dx_private_vif_amazon_address" {
  type        = string
  description = "The IPv4 CIDR address to use to send traffic to Amazon. Required for IPv4 BGP peers."
  default     = ""
}

variable "aws_dx_private_vif_customer_address" {
  type        = string
  description = "The IPv4 CIDR destination address to which Amazon should send traffic. Required for IPv4 BGP peers."
  default     = ""
}

variable "aws_dx_mtu_size" {
  type        = number
  description = <<EOF
  The maximum transmission unit (MTU) is the size, in bytes, of the largest permissible packet that can be passed over
  the connection. The MTU of a virtual private interface can be either 1500 or 9001 (jumbo frames). Default is 1500.
  EOF
  default     = 1500
}

variable "aws_dx_bgp_auth_key" {
  type        = string
  description = "The authentication key for BGP configuration."
  default     = ""
}

variable "aws_tags" {
  type        = map(string)
  description = "Tags for AWS resources."
  default     = {
    Terraform = "true"
  }
}
