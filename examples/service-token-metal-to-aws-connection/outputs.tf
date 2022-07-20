output "connection_primary_details" {
  value = module.equinix-fabric-connection-aws-primary
}

output "connection_secondary_details" {
  value = var.redundancy_type == "REDUNDANT" ? module.equinix-fabric-connection-aws-secondary : null
}
