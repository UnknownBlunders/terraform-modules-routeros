# --- Address List Outputs ------------------------------------------------------

output "address_list_names" {
  description = "Distinct address list names created by this module."
  value       = distinct([for k, v in routeros_ip_firewall_addr_list.this : v.list])
}

output "address_list_ids" {
  description = "Map of address list entry keys (list/address) to their RouterOS resource IDs."
  value       = { for k, v in routeros_ip_firewall_addr_list.this : k => v.id }
}

# --- Interface List Outputs ----------------------------------------------------

output "interface_list_names" {
  description = "List of interface list names created by this module."
  value       = [for k, v in routeros_interface_list.this : v.name]
}

output "interface_list_ids" {
  description = "Map of interface list names to their RouterOS resource IDs."
  value       = { for k, v in routeros_interface_list.this : k => v.id }
}

# --- NAT Rule Outputs ---------------------------------------------------------

output "nat_rule_count" {
  description = "Total number of NAT rules managed by this module."
  value       = length(var.nat_rules)
}

output "nat_rule_ids" {
  description = "Map of NAT rule sort keys to their RouterOS resource IDs."
  value       = { for k, v in routeros_ip_firewall_nat.this : k => v.id }
}

# --- Filter Rule Outputs ------------------------------------------------------

output "filter_rule_count" {
  description = "Total number of filter rules managed by this module."
  value       = length(var.filter_rules)
}

output "filter_rule_ids" {
  description = "Map of filter rule sort keys to their RouterOS resource IDs."
  value       = { for k, v in routeros_ip_firewall_filter.this : k => v.id }
}

# --- IPv6 Address List Outputs -------------------------------------------------

output "ipv6_address_list_names" {
  description = "Distinct IPv6 address list names created by this module."
  value       = distinct([for k, v in routeros_ipv6_firewall_addr_list.this : v.list])
}

output "ipv6_address_list_ids" {
  description = "Map of IPv6 address list entry keys (list/address) to their RouterOS resource IDs."
  value       = { for k, v in routeros_ipv6_firewall_addr_list.this : k => v.id }
}

# --- IPv6 Filter Rule Outputs -------------------------------------------------

output "ipv6_filter_rule_count" {
  description = "Total number of IPv6 filter rules managed by this module."
  value       = length(var.ipv6_filter_rules)
}

output "ipv6_filter_rule_ids" {
  description = "Map of IPv6 filter rule sort keys to their RouterOS resource IDs."
  value       = { for k, v in routeros_ipv6_firewall_filter.this : k => v.id }
}
