output "router_id" {
  value       = join("", google_compute_router.router[*].id)
  description = "An identifier for the resource with format"
}

output "router_creation_timestamp" {
  value       = join("", google_compute_router.router[*].creation_timestamp)
  description = "Creation timestamp in RFC3339 text format."
}

output "router_self_link" {
  value       = join("", google_compute_router.router[*].self_link)
  description = "The URI of the created resource."
}

output "router" {
  value       = google_compute_router.router
  description = "Created Router"
}

output "nat" {
  value       = google_compute_router_nat.nats
  description = "Created NATs"
}
output "attachment" {
  value       = google_compute_interconnect_attachment.attachment
  description = "The created attachment"
}

#output "customer_router_ip_address" {
#  value       = google_compute_interconnect_attachment.attachment.customer_router_ip_address
#  description = "IPv4 address + prefix length to be configured on the customer router subinterface for this interconnect attachment."
#}

output "cloud_router_ip_address" {
  value       = join("", google_compute_interconnect_attachment.attachment[*].cloud_router_ip_address)
  description = " IPv4 address + prefix length to be configured on Cloud Router Interface for this interconnect attachment."
}

output "pairing_key" {
  value       = join("", google_compute_interconnect_attachment.attachment[*].pairing_key)
  description = " [Output only for type PARTNER. Not present for DEDICATED]. "
}

output "partner_asn" {
  value       = join("", google_compute_interconnect_attachment.attachment[*].partner_asn)
  description = "[Output only for type PARTNER. Not present for DEDICATED]. "
}

output "private_interconnect_info" {
  value       = google_compute_interconnect_attachment.attachment[*].private_interconnect_info
  description = " Information specific to an InterconnectAttachment. "
}

output "state" {
  value       = join("", google_compute_interconnect_attachment.attachment[*].state)
  description = "The current state of this attachment's functionality."
}

output "google_reference_id" {
  value       = join("", google_compute_interconnect_attachment.attachment[*].google_reference_id)
  description = "Google reference ID,"
}

output "creation_timestamp" {
  value       = join("", google_compute_interconnect_attachment.attachment[*].creation_timestamp)
  description = "Creation timestamp in RFC3339 text format."
}

output "self_link" {
  value       = join("", google_compute_interconnect_attachment.attachment[*].self_link)
  description = "The URI of the created resource."
}

output "id" {
  value = join("", google_compute_router_interface.foobar[*].id)
}