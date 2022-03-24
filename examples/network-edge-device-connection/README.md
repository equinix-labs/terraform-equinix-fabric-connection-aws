# Network Edge Device Connection Example

This example demonstrates usage of the Equinix Connection module to establish a non-redundant Equinix Fabric L2 Connection from a Equinix Network Edge device to AWS Direct Connect. It will:

- Create Equinix Fabric l2 connection with 200 Mbps bandwidth
- Approve AWS connection request
- Create AWS private virtual interface
- Create AWS virtual gateway
- Create AWS VPC
- Configure bgp session from AWS VIF to your Network Edge device

## Usage

```bash
terraform init
terraform apply
```
