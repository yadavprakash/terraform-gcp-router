provider "google" {
  project = "testing-gcp-ops"
  region  = "asia-northeast1"
  zone    = "asia-northeast1-a"
}

#-----------------------------------------------------------------------------
# vpc module call.
#-----------------------------------------------------------------------------
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

#---------------------------------------------------------------------------------
# router module call.
#---------------------------------------------------------------------------------
module "cloud_router" {
  source      = "../../"
  name        = "dev"
  environment = "test"
  region      = "asia-northeast1"
  network     = module.vpc.vpc_id
  bgp = {
    asn = "65001"
  }
}