# --- IPv6 Address Lists --------------------------------------------------------
# Manages RouterOS IPv6 firewall address lists and their entries. Address lists
# group IPv6 addresses or subnets so they can be referenced collectively in
# IPv6 firewall rules (e.g., "ipv6-bogons", "trusted-hosts-v6").

resource "routeros_ipv6_firewall_addr_list" "this" {
  for_each = local.ipv6_address_list_entries

  list    = each.value.list
  address = each.value.address
  comment = coalesce(each.value.comment, "Managed by Terraform - ${each.value.list}")
}

# --- IPv6 Address List Entries -------------------------------------------------
# Flattens the nested ipv6_address_lists variable into a map keyed by
# "list_name/address" so that each entry can be managed independently
# via for_each.

locals {
  ipv6_address_list_entries = merge([
    for list_name, list_config in var.ipv6_address_lists : {
      for address in list_config.addresses :
      "${list_name}/${address}" => {
        list    = list_name
        address = address
        comment = list_config.comment
      }
    }
  ]...)
}
