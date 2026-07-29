# Terraform/OpenTofu Modules: RouterOS

This is a fork of [mirceanton's routeros modules repo](https://github.com/mirceanton/terraform-modules-routeros) that I have customized for my network.

A collection of reusable [OpenTofu](https://opentofu.org/) / [Terraform](https://www.terraform.io/) modules for configuring [MikroTik RouterOS](https://mikrotik.com/) devices using the [`routeros`](https://registry.terraform.io/providers/terraform-routeros/routeros/latest) provider.

## Modules

| Module                                        | Description                                                                   |
| --------------------------------------------- | ----------------------------------------------------------------------------- |
| [base](modules/base/)                         | System identity, NTP, certificates, IP services, bridge/VLANs, bonding, users |
| [firewall](modules/firewall/)                 | Firewall filter rules, NAT rules, and interface lists                         |
| [dhcp-server](modules/dhcp-server/)           | DHCP server with pools, networks, static leases, and DNS records              |
| [dns-server](modules/dns-server/)             | DNS server, static DNS records, and ad-blocking                               |
| [pppoe-client](modules/pppoe-client/)         | PPPoE client interface configuration                                          |
| [capsman](modules/capsman/)                   | CAPsMAN wireless controller (WiFi channels, security, provisioning)           |
| [cloud](modules/cloud/)                       | MikroTik IP Cloud (DDNS, public IP detection)                                 |
| [wireguard-server](modules/wireguard-server/) | WireGuard server interface and IP address                                     |
| [wireguard-peers](modules/wireguard-peers/)   | WireGuard peer management with auto-generated keys                            |

## Usage

### From Git

```hcl
module "base" {
  source = "git::https://github.com/unknownblunders/terraform-routeros-modules.git//modules/base?ref=v1.0.0"

  hostname = "my-router"
  # ...
}
```

## License

[mirceanton's original repo](https://github.com/mirceanton/terraform-modules-routeros) used the MIT license. All of my changes are also MIT licensed. See [LICENSE](LICENSE).

Checkout the git log and git blame to see what changes I've made.
