# One macvlan per VLAN, each with a unique MAC so AT&T's BGW
# treats each as a distinct DHCPv6-PD client and hands out a
# separate /64.
resource "routeros_interface_macvlan" "macvlan_interface" {
  count = var.enable_gua ? 1 : 0

  name            = "macvlan-pd-${var.lan_interface}"
  interface       = var.wan_interface
  mac_address     = "02:00:00:00:00:${var.mac_suffix}"
}

# This adds the macvlan to the WAN firewall list. This ensures that this interface
# is treated like a wan interface, so the firewall allows dhcp-pd in and not much else!
resource "routeros_interface_list_member" "macvlan" {
  count = var.enable_gua ? 1 : 0

  list      = var.wan_interface_list
  interface = routeros_interface_macvlan.macvlan_interface[0].name
}

resource "routeros_ipv6_dhcp_client" "wan_pd" {
  count = var.enable_gua ? 1 : 0

  interface          = routeros_interface_macvlan.macvlan_interface[0].name
  #interface = "ether1"
  request            = ["prefix"]
  pool_name          = "pool-${var.lan_interface}"
  pool_prefix_length = 64
  use_peer_dns = false
  # Only enable this on ONE of them — they all sit on the same
  # physical WAN link, so you only need one default route, not
  # eight identical/competing ones.
  add_default_route  = var.core_network == true
}

resource "routeros_ipv6_address" "gua" {
  count = var.enable_gua ? 1 : 0

  address   = "::1/64"
  from_pool = routeros_ipv6_dhcp_client.wan_pd[0].pool_name
  interface = var.lan_interface
  advertise = true

  depends_on = [routeros_ipv6_dhcp_client.wan_pd]
}

resource "routeros_ipv6_address" "ula" {
  address   = "${var.ula_base}:${var.ula_subnet}::1/64"
  interface = var.lan_interface
  advertise = var.advertise_ula
}

resource "routeros_ipv6_neighbor_discovery" "nd" {
  interface                       = var.lan_interface
  advertise_dns                   = true
  advertise_mac_address           = true
  dns                     = split("/", routeros_ipv6_address.ula.address)[0]
  managed_address_configuration   = false
  other_configuration             = true
}
