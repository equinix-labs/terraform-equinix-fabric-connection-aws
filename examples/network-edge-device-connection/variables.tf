variable "device_id" {
  type = string
  description = <<EOF
  The ID of the (Network Edge virtual device](https://github.com/equinix/terraform-provider-equinix/tree/master/examples/edge-networking)
  from which the connection would originate.
  EOF
}

variable "aws_account_id" {
  type = string
  description = "Your [AWS account ID](https://docs.aws.amazon.com/general/latest/gr/acct-identifiers.html)."
}
