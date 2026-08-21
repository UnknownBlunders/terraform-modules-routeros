# --- Address Lists -------------------------------------------------------------

variable "address_lists" {
  description = <<-EOT
    Map of address lists to create with their member addresses.
    Each key becomes the address list name on the router.

    Example:
    {
      wireguard-clients = {
        comment   = "WireGuard client IPs"
        addresses = ["10.10.0.2", "10.10.0.3"]
      }
      trusted-hosts = {
        comment   = "Trusted management hosts"
        addresses = ["192.168.1.10/32"]
      }
    }
  EOT
  type = map(object({
    comment   = optional(string, "")
    addresses = list(string)
  }))
  default = {}
}

# --- IPv6 Address Lists --------------------------------------------------------

variable "ipv6_address_lists" {
  description = <<-EOT
    Map of IPv6 address lists to create with their member addresses.
    Each key becomes the address list name on the router (/ipv6/firewall/address-list).

    Example:
    {
      ipv6-bogons = {
        comment   = "IPv6 martians that should never appear on WAN"
        addresses = ["::/128", "::1/128", "fc00::/7", "fe80::/10"]
      }
      trusted-hosts-v6 = {
        comment   = "Trusted management hosts"
        addresses = ["2001:db8:1::10/128"]
      }
    }
  EOT
  type = map(object({
    comment   = optional(string, "")
    addresses = list(string)
  }))
  default = {}
}

# --- Interface Lists -----------------------------------------------------------

variable "interface_lists" {
  description = <<-EOT
    Map of interface lists to create with their members.
    Each key becomes the interface list name on the router.

    Example:
    {
      WAN = {
        comment    = "All Public-Facing Interfaces"
        interfaces = ["ether1"]
      }
      LAN = {
        comment    = "All Local Interfaces"
        interfaces = ["bridge", "vlan-trusted", "vlan-iot"]
      }
    }
  EOT
  type = map(object({
    comment    = optional(string, "")
    interfaces = list(string)
  }))
  default = {}
}

# --- NAT Rules ----------------------------------------------------------------

variable "nat_rules" {
  description = <<-EOT
    Map of NAT rules to create. Rules are ordered by the 'order' field, which
    determines their placement in the RouterOS NAT chain. Lower numbers are
    evaluated first. The key is used as a human-readable identifier and is
    included in the auto-generated comment if no explicit comment is provided.

    Example:
    {
      "masquerade-wan" = {
        chain              = "srcnat"
        action             = "masquerade"
        out_interface_list = "WAN"
        order              = 100
      }
      "port-forward-web" = {
        chain        = "dstnat"
        action       = "dst-nat"
        protocol     = "tcp"
        dst_port     = "443"
        to_addresses = "192.168.1.10"
        to_ports     = "443"
        order        = 200
      }
    }
  EOT
  type = map(object({
    chain              = string
    action             = string
    order              = number
    comment            = optional(string)
    connection_rate    = optional(string)
    src_address        = optional(string)
    dst_address        = optional(string)
    src_address_list   = optional(string)
    dst_address_list   = optional(string)
    src_port           = optional(string)
    dst_port           = optional(string)
    protocol           = optional(string)
    in_interface       = optional(string)
    out_interface      = optional(string)
    in_interface_list  = optional(string)
    out_interface_list = optional(string)
    to_addresses       = optional(string)
    to_ports           = optional(string)
    log                = optional(bool)
    log_prefix         = optional(string)
  }))
  default = {}

  validation {
    condition = alltrue([
      for k, v in var.nat_rules : contains(["srcnat", "dstnat"], v.chain)
    ])
    error_message = "NAT rule chain must be one of: \"srcnat\", \"dstnat\"."
  }

  validation {
    condition = alltrue([
      for k, v in var.nat_rules : v.order >= 0
    ])
    error_message = "NAT rule order must be a non-negative number."
  }
}

# --- Filter Rules -------------------------------------------------------------

variable "filter_rules" {
  description = <<-EOT
    Map of firewall filter rules to create. Rules are ordered by the 'order'
    field, which determines their placement in the RouterOS filter chain. Lower
    numbers are evaluated first. The key is used as a human-readable identifier
    and is included in the auto-generated comment if no explicit comment is
    provided.

    Example:
    {
      "accept-established" = {
        chain            = "input"
        action           = "accept"
        connection_state = "established,related,untracked"
        order            = 100
      }
      "drop-invalid" = {
        chain            = "input"
        action           = "drop"
        connection_state = "invalid"
        order            = 200
      }
    }
  EOT
  type = map(object({
    chain              = string
    action             = string
    order              = number
    comment            = optional(string)
    connection_state   = optional(string)
    src_address        = optional(string)
    dst_address        = optional(string)
    src_address_list   = optional(string)
    dst_address_list   = optional(string)
    src_port           = optional(string)
    dst_port           = optional(string)
    protocol           = optional(string)
    in_interface       = optional(string)
    out_interface      = optional(string)
    in_interface_list  = optional(string)
    out_interface_list = optional(string)
    hw_offload         = optional(bool)
    log                = optional(bool)
    log_prefix         = optional(string)
    jump_target        = optional(string)
  }))
  default = {}

  validation {
    condition = alltrue([
      for k, v in var.filter_rules : contains(["input", "forward", "output"], v.chain)
    ])
    error_message = "Filter rule chain must be one of: \"input\", \"forward\", \"output\"."
  }

  validation {
    condition = alltrue([
      for k, v in var.filter_rules : v.order >= 0
    ])
    error_message = "Filter rule order must be a non-negative number."
  }
}

# --- IPv6 Filter Rules --------------------------------------------------------

variable "ipv6_filter_rules" {
  description = <<-EOT
    Map of IPv6 firewall filter rules to create (/ipv6/firewall/filter). Rules
    are ordered by the 'order' field, which determines their placement in the
    RouterOS filter chain. Lower numbers are evaluated first. The key is used as
    a human-readable identifier and is included in the auto-generated comment if
    no explicit comment is provided.

    Interface lists (WAN/LAN/etc.) are shared with IPv4, so the same lists can be
    referenced here. IPv6 has no NAT: inbound access is controlled entirely by
    forward-chain rules. ICMPv6 must be permitted for IPv6 to function.

    Example:
    {
      "input-accept-icmpv6" = {
        chain    = "input"
        action   = "accept"
        protocol = "icmpv6"
        order    = 130
      }
      "forward-drop-all" = {
        chain  = "forward"
        action = "drop"
        order  = 2000
      }
    }
  EOT
  type = map(object({
    chain              = string
    action             = string
    order              = number
    comment            = optional(string)
    connection_state   = optional(string)
    src_address        = optional(string)
    dst_address        = optional(string)
    src_address_list   = optional(string)
    dst_address_list   = optional(string)
    src_port           = optional(string)
    dst_port           = optional(string)
    protocol           = optional(string)
    in_interface       = optional(string)
    out_interface      = optional(string)
    in_interface_list  = optional(string)
    out_interface_list = optional(string)
    icmp_options       = optional(string)
    log                = optional(bool)
    log_prefix         = optional(string)
    jump_target        = optional(string)
  }))
  default = {}

  validation {
    condition = alltrue([
      for k, v in var.ipv6_filter_rules : contains(["input", "forward", "output"], v.chain)
    ])
    error_message = "IPv6 filter rule chain must be one of: \"input\", \"forward\", \"output\"."
  }

  validation {
    condition = alltrue([
      for k, v in var.ipv6_filter_rules : v.order >= 0
    ])
    error_message = "IPv6 filter rule order must be a non-negative number."
  }
}
