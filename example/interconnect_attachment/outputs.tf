output "router_id" {
  value       = module.cloud_router.router_id
  description = "An identifier for the resource with format"
}

output "router_creation_timestamp" {
  value       = module.cloud_router.router_creation_timestamp
  description = "Creation timestamp in RFC3339 text format."
}

output "router_self_link" {
  value       = module.cloud_router.router_self_link
  description = "The URI of the created resource."
}

output "router" {
  value       = module.cloud_router.router
  description = "Created Router"
}

output "nat" {
  value       = module.cloud_router.nat
  description = "Created NATs"
}