output "fabric_connection_id" {
  value = module.equinix-fabric-connection-aws.fabric_connection_uuid
}

output "fabric_connection_name" {
  value = module.equinix-fabric-connection-aws.fabric_connection_name
}

output "fabric_connection_status" {
  value = module.equinix-fabric-connection-aws.fabric_connection_status
}

output "fabric_connection_provider_status" {
  value = module.equinix-fabric-connection-aws.fabric_connection_provider_status
}

output "aws_direct_connect_id" {
  value = module.equinix-fabric-connection-aws.aws_dx_id
}

output "aws_vpc_id" {
  value = aws_vpc.this.id
}
