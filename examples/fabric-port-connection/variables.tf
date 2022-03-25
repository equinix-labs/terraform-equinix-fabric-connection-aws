variable "port_name" {
  type        = string
  description = <<EOF
  Name of the [Equinix Fabric port](https://docs.equinix.com/en-us/Content/Interconnection/Fabric/ports/Fabric-port-details.htm)
  from which the connection would originate.
  EOF
}

variable "aws_account_id" {
  type = string
  description = "Your [AWS account ID](https://docs.aws.amazon.com/general/latest/gr/acct-identifiers.html)."
}
