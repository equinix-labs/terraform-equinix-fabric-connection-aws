# Advanced Example

This example demonstrates usage of the Equinix Connection module to establish a non-redundant Equinix Fabric L2 Connection from a Equinix Fabric port to AWS Direct Connect. It will:

- Create Equinix Fabric l2 connection with 100 Mbps bandwidth
- Approve AWS connection request
- Create AWS private virtual interface
- Create AWS virtual gateway
- Create AWS VPC

## Usage

```bash
terraform init
terraform apply
```
