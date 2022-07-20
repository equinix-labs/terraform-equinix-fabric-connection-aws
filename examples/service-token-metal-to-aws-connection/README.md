# Complete Equinix Metal connection (a-side) to AWS

~> Equinix Metal connection with automated `a_side` service token is not generally available and may not be enabled yet for your organization.

This example demonstrates usage of the Equinix Connection AWS module to establish an Equinix Fabric L2 Connection from Equinix Metal (a-side) to AWS Direct Connect using an [A-Side Token](https://docs.equinix.com/en-us/Content/Interconnection/Fabric/service%20tokens/Fabric-Service-Tokens.htm).
It will:

- Use an existing Equinix Metal project.
- Create a new Equinix Metal VLAN in selected metro Silicon Valley (SV).
- Request an Equinix Metal shared redundant connection in SV.
- Attach the Equinix Metal VLAN to the Virtual Circuit created for the Equinix Metal connection.
- Create an AWS VPC.
- Provision two Equinix Fabric l2 connection for AWS service profile with specified bandwidth and private peering.
- Approve AWS connection request.
- Create AWS private virtual interface.
- Create AWS virtual gateway and attach to the new VPC.

## Usage

To provision this example, you should clone the github repository and run terraform from within this directory:

```bash
git clone https://github.com/equinix-labs/terraform-equinix-fabric-connection-aws.git
cd terraform-equinix-fabric-connection-aws/examples/service-token-metal-to-aws-connection
terraform init
terraform apply
```

Note that this example may create resources which cost money. Run 'terraform destroy' when you don't need these resources.

## Variables

See <https://registry.terraform.io/modules/equinix-labs/fabric-connection-aws/equinix/latest/examples/service-token-metal-to-aws-connection?tab=inputs> for a description of all variables.

## Outputs

See <https://registry.terraform.io/modules/equinix-labs/fabric-connection-aws/equinix/latest/examples/service-token-metal-to-aws-connection?tab=outputs> for a description of all outputs.
