provider "google" {
  project = "local-concord-408802"
  region  = "asia-northeast1"
  zone    = "asia-northeast1-a"
}

####==============================================================================
#### vpc module call.
####==============================================================================
module "vpc" {
  source                                    = "git::git@github.com:opsstation/terraform-gcp-vpc.git?ref=v1.0.0"
  name                                      = "dev"
  environment                               = "test"
  label_order                               = ["name", "environment"]
  mtu                                       = 1460
  routing_mode                              = "REGIONAL"
  network_firewall_policy_enforcement_order = "AFTER_CLASSIC_FIREWALL"
  delete_default_routes_on_create           = false
}

####==============================================================================
#### interconnect_attachment module call.
####==============================================================================
module "cloud_router" {
  source                          = "../../"
  name                            = "dev"
  environment                     = "test"
  region                          = "asia-northeast1"
  network                         = module.vpc.vpc_id
  enabled_interconnect_attachment = true
  #  interconnect = "https://googleapis.com/interconnects/example-interconnect"

  bgp = {
    asn               = "16550"
    advertised_groups = ["ALL_SUBNETS"]
  }
}