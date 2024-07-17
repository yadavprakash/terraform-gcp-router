provider "google" {
  project = "testing-gcp-ops"
  region  = "asia-northeast1"
  zone    = "asia-northeast1-a"
}

#---------------------------------------------------------------------------------
# vpc module call.
#---------------------------------------------------------------------------------
module "vpc" {
  source                                    = "git::git@github.com:yadavprakash/terraform-gcp-vpc.git?ref=v1.0.0"
  name                                      = "dev"
  environment                               = "test"
  label_order                               = ["name", "environment"]
  mtu                                       = 1460
  routing_mode                              = "REGIONAL"
  network_firewall_policy_enforcement_order = "AFTER_CLASSIC_FIREWALL"
  delete_default_routes_on_create           = false
}

#---------------------------------------------------------------------------------
# cloud_router module call.
#---------------------------------------------------------------------------------
module "cloud_router" {
  source      = "../../"
  name        = "dev"
  environment = "test"
  network     = module.vpc.vpc_id
  region      = "asia-northeast1"
  nats = [
    {
      name                               = "my-nat-gateway"
      source_subnetwork_ip_ranges_to_nat = "ALL_SUBNETWORKS_ALL_IP_RANGES"
    }
  ]
}

