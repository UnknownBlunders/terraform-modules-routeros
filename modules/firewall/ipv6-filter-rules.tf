# --- IPv6 Filter Rules ---------------------------------------------------------
# Manages RouterOS IPv6 firewall filter rules with deterministic ordering.
#
# Rule ordering mechanism (identical to the IPv4 filter-rules.tf)
#
# NAT not needed here like it is in IPv4 firewall


locals {
  ipv6_filter_rules_ordered = [
    for k, v in var.ipv6_filter_rules : merge(v, {
      key      = k
      sort_key = format("%04d-%s", v.order, k)
    })
  ]

  ipv6_filter_rules_map = {
    for rule in local.ipv6_filter_rules_ordered :
    rule.sort_key => rule
  }
}

resource "routeros_ipv6_firewall_filter" "this" {
  for_each = local.ipv6_filter_rules_map

  comment = coalesce(each.value.comment, "Managed by Terraform - ${each.value.key}")
  chain   = each.value.chain
  action  = each.value.action

  connection_state   = each.value.connection_state
  in_interface       = each.value.in_interface
  out_interface      = each.value.out_interface
  in_interface_list  = each.value.in_interface_list
  out_interface_list = each.value.out_interface_list
  protocol           = each.value.protocol
  dst_port           = each.value.dst_port
  src_port           = each.value.src_port
  src_address        = each.value.src_address
  dst_address        = each.value.dst_address
  src_address_list   = each.value.src_address_list
  dst_address_list   = each.value.dst_address_list
  icmp_options       = each.value.icmp_options
  jump_target        = each.value.jump_target
  log                = each.value.log
  log_prefix         = each.value.log_prefix

  depends_on = [routeros_interface_list.this, routeros_ipv6_firewall_addr_list.this]

  lifecycle {
    create_before_destroy = true
  }
}

# Reorder IPv6 filter rules on the router to match the sorted sequence.
resource "routeros_move_items" "ipv6_filter_rules" {
  count = length(var.ipv6_filter_rules) > 0 ? 1 : 0

  resource_path = "/ipv6/firewall/filter"
  sequence      = [for idx in sort(keys(local.ipv6_filter_rules_map)) : routeros_ipv6_firewall_filter.this[idx].id]

  depends_on = [routeros_ipv6_firewall_filter.this]
}
