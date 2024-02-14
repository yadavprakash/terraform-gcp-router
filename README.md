# Terraform-gcp-router
# Google Cloud Infrastructure Provisioning with Terraform
## Table of Contents

## Table of Contents
- [Introduction](#introduction)
- [Usage](#usage)
- [Module Inputs](#module-inputs)
- [Module Outputs](#module-outputs)
- [Authors](#authors)
- [License](#license)

## Introduction
This project deploys a Google Cloud infrastructure using Terraform to create Router .

## Usage

To use this module, you should have Terraform installed and configured for GCP. This module provides the necessary Terraform configuration for creating GCP resources, and you can customize the inputs as needed. Below is an example of how to use this module:
# Example: _Nat_

```hcl
module "cloud_router" {
  source      = "https://github.com/opsstation/terraform-gcp-router.git"
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

```
# Example: _Interconnect_Attachment_

```hcl
module "cloud_router" {
  source                          = "https://github.com/opsstation/terraform-gcp-router.git"
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

```

# Example: _Default_

```hcl
module "cloud_router" {
  source      = "https://github.com/opsstation/terraform-gcp-router.git"
  name        = "dev"
  environment = "test"
  region      = "asia-northeast1"
  network     = module.vpc.vpc_id
  bgp = {
    asn = "65001"
  }
}

```
This example demonstrates how to create various GCP resources using the provided modules. Adjust the input values to suit your specific requirements.

## Module Inputs

- `name`: The name of the application or resource.
- `environment`: The environment in which the resource exists.
- `label_order`: The order in which labels should be applied.
- `business_unit`: The business unit associated with the application.
- `attributes`: Additional attributes to add to the labels.
- `extra_tags`: Extra tags to associate with the resource.

## Module Outputs
- This module currently does not provide any outputs.

# Examples
For detailed examples on how to use this module, please refer to the [example](https://github.com/opsstation/terraform-gcp-router/tree/master/_example) directory within this repository.

## Authors
Your Name
Replace '[License Name]' and '[Your Name]' with the appropriate license and your information. Feel free to expand this README with additional details or usage instructions as needed for your specific use case.

## License
This project is licensed under the MIT License - see the [LICENSE](https://github.com/opsstation/terraform-gcp-router/blob/master/LICENSE) file for details.



<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.6.6 |
| <a name="requirement_google"></a> [google](#requirement\_google) | >= 3.50, < 5.11.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_google"></a> [google](#provider\_google) | >= 3.50, < 5.11.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_labels"></a> [labels](#module\_labels) | git::git@github.com:opsstation/terraform-gcp-labels.git | v1.0.0 |

## Resources

| Name | Type |
|------|------|
| [google_compute_interconnect_attachment.attachment](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_interconnect_attachment) | resource |
| [google_compute_router.router](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_router) | resource |
| [google_compute_router_interface.foobar](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_router_interface) | resource |
| [google_compute_router_nat.nats](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_router_nat) | resource |
| [google_compute_router_peer.peer](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_router_peer) | resource |
| [google_client_config.current](https://registry.terraform.io/providers/hashicorp/google/latest/docs/data-sources/client_config) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_admin_enabled"></a> [admin\_enabled](#input\_admin\_enabled) | Whether the VLAN attachment is enabled or disabled | `bool` | `true` | no |
| <a name="input_bandwidth"></a> [bandwidth](#input\_bandwidth) | Provisioned bandwidth capacity for the interconnect attachment | `string` | `""` | no |
| <a name="input_bgp"></a> [bgp](#input\_bgp) | BGP information specific to this router. | <pre>object({<br>    asn               = string<br>    advertise_mode    = optional(string, "CUSTOM")<br>    advertised_groups = optional(list(string))<br>    advertised_ip_ranges = optional(list(object({<br>      range       = string<br>      description = optional(string)<br>    })), [])<br>    keepalive_interval = optional(number)<br><br>  })</pre> | `null` | no |
| <a name="input_candidate_subnets"></a> [candidate\_subnets](#input\_candidate\_subnets) | Up to 16 candidate prefixes that can be used to restrict the allocation of cloudRouterIpAddress and customerRouterIpAddress for this attachment. All prefixes must be within link-local address space (169.254.0.0/16) and must be /29 or shorter (/28, /27, etc). | `list(string)` | `null` | no |
| <a name="input_description"></a> [description](#input\_description) | An optional description of this resource | `string` | `null` | no |
| <a name="input_edge_availability_domain"></a> [edge\_availability\_domain](#input\_edge\_availability\_domain) | n/a | `string` | `"AVAILABILITY_DOMAIN_1"` | no |
| <a name="input_enabled_interconnect_attachment"></a> [enabled\_interconnect\_attachment](#input\_enabled\_interconnect\_attachment) | n/a | `bool` | `false` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | Environment (e.g. `prod`, `dev`, `staging`). | `string` | `""` | no |
| <a name="input_label_order"></a> [label\_order](#input\_label\_order) | Label order, e.g. sequence of application name and environment `name`,`environment`,'attribute' [`webserver`,`qa`,`devops`,`public`,] . | `list(any)` | <pre>[<br>  "name",<br>  "environment"<br>]</pre> | no |
| <a name="input_managedby"></a> [managedby](#input\_managedby) | ManagedBy, opsstation | `string` | `""` | no |
| <a name="input_mtu"></a> [mtu](#input\_mtu) | Maximum Transmission Unit (MTU), in bytes, of packets passing through this interconnect attachment. Currently, only 1440 and 1500 are allowed. If not specified, the value will default to 1440. | `string` | `1500` | no |
| <a name="input_name"></a> [name](#input\_name) | Name of the resource. Provided by the client when the resource is created. | `string` | `""` | no |
| <a name="input_nats"></a> [nats](#input\_nats) | NATs to deploy on this router. | <pre>list(object({<br>    name                                = string<br>    nat_ip_allocate_option              = optional(string)<br>    source_subnetwork_ip_ranges_to_nat  = optional(string)<br>    nat_ips                             = optional(list(string), [])<br>    min_ports_per_vm                    = optional(number)<br>    max_ports_per_vm                    = optional(number)<br>    udp_idle_timeout_sec                = optional(number)<br>    icmp_idle_timeout_sec               = optional(number)<br>    tcp_established_idle_timeout_sec    = optional(number)<br>    tcp_transitory_idle_timeout_sec     = optional(number)<br>    tcp_time_wait_timeout_sec           = optional(number)<br>    enable_endpoint_independent_mapping = optional(bool)<br>    enable_dynamic_port_allocation      = optional(bool)<br><br>    log_config = optional(object({<br>      enable = optional(bool, true)<br>      filter = optional(string, "ALL")<br>    }), {})<br><br>    subnetworks = optional(list(object({<br>      name                     = string<br>      source_ip_ranges_to_nat  = list(string)<br>      secondary_ip_range_names = optional(list(string))<br>    })), [])<br><br>  }))</pre> | `[]` | no |
| <a name="input_network"></a> [network](#input\_network) | A reference to the network to which this router belongs | `string` | n/a | yes |
| <a name="input_peer_asn"></a> [peer\_asn](#input\_peer\_asn) | n/a | `number` | `65513` | no |
| <a name="input_peers"></a> [peers](#input\_peers) | BGP peers for this interface. | <pre>list(object({<br>    name                      = string<br>    peer_ip_address           = string<br>    peer_asn                  = string<br>    advertised_route_priority = optional(number)<br>    bfd = object({<br>      session_initialization_mode = string<br>      min_transmit_interval       = optional(number)<br>      min_receive_interval        = optional(number)<br>      multiplier                  = optional(number)<br>    })<br>  }))</pre> | `[]` | no |
| <a name="input_region"></a> [region](#input\_region) | Region where the router resides | `string` | n/a | yes |
| <a name="input_repository"></a> [repository](#input\_repository) | Terraform current module repo | `string` | `"https://github.com/opsstation/terraform-gcp-router"` | no |
| <a name="input_type"></a> [type](#input\_type) | The type of InterconnectAttachment you wish to create | `string` | `"PARTNER"` | no |
| <a name="input_vlan_tag8021q"></a> [vlan\_tag8021q](#input\_vlan\_tag8021q) | The IEEE 802.1Q VLAN tag for this attachment, in the range 2-4094. | `string` | `null` | no |
| <a name="input_vpn_tunnel"></a> [vpn\_tunnel](#input\_vpn\_tunnel) | The name or resource link to the VPN tunnel this interface will be linked to | `string` | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_attachment"></a> [attachment](#output\_attachment) | The created attachment |
| <a name="output_cloud_router_ip_address"></a> [cloud\_router\_ip\_address](#output\_cloud\_router\_ip\_address) | IPv4 address + prefix length to be configured on Cloud Router Interface for this interconnect attachment. |
| <a name="output_creation_timestamp"></a> [creation\_timestamp](#output\_creation\_timestamp) | Creation timestamp in RFC3339 text format. |
| <a name="output_google_reference_id"></a> [google\_reference\_id](#output\_google\_reference\_id) | Google reference ID, |
| <a name="output_id"></a> [id](#output\_id) | n/a |
| <a name="output_nat"></a> [nat](#output\_nat) | Created NATs |
| <a name="output_pairing_key"></a> [pairing\_key](#output\_pairing\_key) | [Output only for type PARTNER. Not present for DEDICATED]. |
| <a name="output_partner_asn"></a> [partner\_asn](#output\_partner\_asn) | [Output only for type PARTNER. Not present for DEDICATED]. |
| <a name="output_private_interconnect_info"></a> [private\_interconnect\_info](#output\_private\_interconnect\_info) | Information specific to an InterconnectAttachment. |
| <a name="output_router"></a> [router](#output\_router) | Created Router |
| <a name="output_router_creation_timestamp"></a> [router\_creation\_timestamp](#output\_router\_creation\_timestamp) | Creation timestamp in RFC3339 text format. |
| <a name="output_router_id"></a> [router\_id](#output\_router\_id) | An identifier for the resource with format |
| <a name="output_router_self_link"></a> [router\_self\_link](#output\_router\_self\_link) | The URI of the created resource. |
| <a name="output_self_link"></a> [self\_link](#output\_self\_link) | The URI of the created resource. |
| <a name="output_state"></a> [state](#output\_state) | The current state of this attachment's functionality. |
<!-- END_TF_DOCS -->