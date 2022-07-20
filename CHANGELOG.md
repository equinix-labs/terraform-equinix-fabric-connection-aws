## 0.2.0 (July 20, 2022)

FEATURES:

- Support for `AWS Direct Connect- High Capacity` service profile

ENHANCEMENTS:

- New example to establish an Equinix Fabric L2 Connection from Equinix Metal to AWS Direct Connect using an A-side Service Token

BUG FIXES:

- typo `purchase_order` was `purcharse_order`

## 0.1.3 (April 26, 2022)

BUG FIXES:

- The count in the aws_vpc datasource was failing when vpc is created in the same template as it depends on an attribute that cannot be determined until it is applied.

## 0.1.2 (April 18, 2022)

BUG FIXES:

- Version of `equinix-fabric-connection` module was updated to `v0.1.1`.
- Control outputs that can access to null variables.

## 0.1.1 (March 28, 2022)

BUG FIXES:

- 'aws_vpc_id' local variable was producing an empty tuple.

## 0.1.0 (March 25, 2022)

NOTES:

Initial release.

FEATURES:

- Supported single connections from Equinix Fabric Port, Network Edge Device, Equinix Service Token to service profile AWS Direct Connect.
