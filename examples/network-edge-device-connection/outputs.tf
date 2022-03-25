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

output "network_edge_bgp_state" {
  description = "Network Edge device BGP peer state."
  value       = module.equinix-fabric-connection-aws.network_edge_bgp_state
}

output "network_edge_bgp_provisioning_status" {
  description = "Network Edge device BGP peering configuration provisioning status."
  value       = module.equinix-fabric-connection-aws.network_edge_bgp_provisioning_status
}

output "aws_direct_connect_id" {
  value = module.equinix-fabric-connection-aws.aws_dx_id
}
