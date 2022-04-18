# Fabric Port Connection Example

This example demonstrates usage of the Equinix Connection AWS module to establish a non-redundant Equinix Fabric L2 Connection from a Equinix Fabric port to AWS Direct Connect. It will:

- Create Equinix Fabric l2 connection with minimun available bandwidth for AWS service profile.
- Approve AWS connection request.

## Usage

To provision this example, you should clone the github repository and run terraform from within this directory:

```bash
git clone https://github.com/equinix-labs/terraform-equinix-fabric-connection-aws.git
cd terraform-equinix-fabric-connection-aws/examples/fabric-port-connection
terraform init
terraform apply
```

Note that this example may create resources which cost money. Run 'terraform destroy' when you don't need these resources.

## Variables

See <https://registry.terraform.io/modules/equinix-labs/fabric-connection-aws/equinix/latest/examples/fabric-port-connection?tab=inputs> for a description of all variables.

## Outputs

See <https://registry.terraform.io/modules/equinix-labs/fabric-connection-aws/equinix/latest/examples/fabric-port-connection?tab=outputs> for a description of all outputs.
