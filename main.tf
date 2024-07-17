module "labels" {
  source      = "git::git@github.com:yadavprakash/terraform-gcp-labels.git?ref=v1.0.0"
  name        = var.name
  environment = var.environment
  label_order = var.label_order
  managedby   = var.managedby
  repository  = var.repository
}

data "google_client_config" "current" {
}

#----------------------------------------------------------------------------------
# Represents a Router resource.
#----------------------------------------------------------------------------------
resource "google_compute_router" "router" {
  name    = format("%s-router", module.labels.id)
  region  = var.region
  project = data.google_client_config.current.project
  network = var.network
  dynamic "bgp" {
    for_each = var.bgp != null ? [var.bgp] : []
    content {
      asn = var.bgp.asn



      advertise_mode     = "CUSTOM"
      advertised_groups  = lookup(var.bgp, "advertised_groups", null)
      keepalive_interval = lookup(var.bgp, "keepalive_interval", null)

      dynamic "advertised_ip_ranges" {
        for_each = lookup(var.bgp, "advertised_ip_ranges", [])
        content {
          range       = advertised_ip_ranges.value.range
          description = lookup(advertised_ip_ranges.value, "description", null)
        }
      }
    }

  }
}

#-----------------------------------------------------------------------------------
# A NAT service created in a router.
#-----------------------------------------------------------------------------------
resource "google_compute_router_nat" "nats" {
  for_each = {
    for n in var.nats :
    n.name => n
  }

  name                                = each.value.name
  project                             = google_compute_router.router.project
  router                              = google_compute_router.router.name
  region                              = google_compute_router.router.region
  nat_ip_allocate_option              = coalesce(each.value.nat_ip_allocate_option, length(each.value.nat_ips) > 0 ? "MANUAL_ONLY" : "AUTO_ONLY")
  source_subnetwork_ip_ranges_to_nat  = coalesce(each.value.source_subnetwork_ip_ranges_to_nat, "ALL_SUBNETWORKS_ALL_IP_RANGES")
  nat_ips                             = each.value.nat_ips
  min_ports_per_vm                    = each.value.min_ports_per_vm
  max_ports_per_vm                    = each.value.max_ports_per_vm
  udp_idle_timeout_sec                = each.value.udp_idle_timeout_sec
  icmp_idle_timeout_sec               = each.value.icmp_idle_timeout_sec
  tcp_established_idle_timeout_sec    = each.value.tcp_established_idle_timeout_sec
  tcp_transitory_idle_timeout_sec     = each.value.tcp_transitory_idle_timeout_sec
  tcp_time_wait_timeout_sec           = each.value.tcp_time_wait_timeout_sec
  enable_endpoint_independent_mapping = each.value.enable_endpoint_independent_mapping
  enable_dynamic_port_allocation      = each.value.enable_dynamic_port_allocation

  log_config {
    enable = each.value.log_config.enable
    filter = each.value.log_config.filter
  }

  dynamic "subnetwork" {
    for_each = each.value.subnetworks
    content {
      name                     = subnetwork.value.name
      source_ip_ranges_to_nat  = subnetwork.value.source_ip_ranges_to_nat
      secondary_ip_range_names = subnetwork.value.secondary_ip_range_names
    }
  }
}
resource "google_compute_interconnect_attachment" "attachment" {
  count                    = var.enabled_interconnect_attachment ? 1 : 0
  name                     = format("%s-attachment", module.labels.id)
  edge_availability_domain = var.edge_availability_domain
  type                     = var.type
  router                   = join("", google_compute_router.router[*].id)
  mtu                      = var.mtu
  project                  = data.google_client_config.current.project
  region                   = var.region
  admin_enabled            = var.admin_enabled
  description              = var.description
  bandwidth                = var.bandwidth
  candidate_subnets        = var.candidate_subnets
  vlan_tag8021q            = var.vlan_tag8021q

}

resource "google_compute_router_interface" "foobar" {
  count = var.enabled_interconnect_attachment ? 1 : 0

  name       = format("%s-foobar-interface", module.labels.id)
  router     = join("", google_compute_router.router[*].name)
  region     = var.region
  ip_range   = join("", google_compute_interconnect_attachment.attachment[*].cloud_router_ip_address)
  vpn_tunnel = var.vpn_tunnel
  project    = data.google_client_config.current.project

}
resource "google_compute_router_peer" "peer" {
  for_each = {
    for p in var.peers :
    p.name => p
  }

  name                      = each.value.name
  project                   = google_compute_router_interface.foobar[*].project
  router                    = google_compute_router_interface.foobar[*].router
  region                    = google_compute_router_interface.foobar[*].region
  peer_ip_address           = element(split("/", google_compute_interconnect_attachment.attachment[*].customer_router_ip_address), 1)
  peer_asn                  = var.peer_asn
  advertised_route_priority = lookup(each.value, "advertised_route_priority", null)
  interface                 = google_compute_router_interface.foobar[*].name
  dynamic "bfd" {
    for_each = lookup(each.value, "bfd", null) == null ? [] : [""]
    content {
      session_initialization_mode = try(each.value.bfd.session_initialization_mode, null)
      min_receive_interval        = try(each.value.bfd.min_receive_interval, null)
      min_transmit_interval       = try(each.value.bfd.min_transmit_interval, null)
      multiplier                  = try(each.value.bfd.multiplier, null)
    }
  }
}