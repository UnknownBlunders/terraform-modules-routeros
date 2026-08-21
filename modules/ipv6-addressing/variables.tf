variable "enable_gua" {
  type        = bool
  default     = true
  description = "Whether to allow DNS requests from remote hosts (clients on the network). Set to false to restrict DNS to the router itself."
}

variable "advertise_ula" {
  type        = bool
  default     = true
  description = "Whether to allow DNS requests from remote hosts (clients on the network). Set to false to restrict DNS to the router itself."
}

variable "wan_interface" {
    type = string
    default = "ether1"
    description = "The name of the WAN interface"
}

variable "lan_interface" {
    type = string
    description = "The interface to assign the address to. Also, the interface to advertise the addresses on. Should be a VLAN name."
}

variable "core_network" {
    type = bool
    default = false
    description = "Is this a core network that won't go away? Only one network should have this enabled. This is used as a variable to specify whether the router should get it's address and default route from this dchp_client resource"
}

variable "mac_suffix" {
    type = string
    description = "the suffix for the virtual MAC address the Router uses to get another /64 from ATT"
}

variable "ula_subnet" {
    type = string
    description = "The last bits of the network portion of this ULA. Will be prefixed by the ula base"
}

variable "ula_base" {
    type = string
    description = "The first bits of the network portion of this ULA. Should be shared across all ULAs, but should be randomly chosen."
}

variable "wan_interface_list" {
    type = string
    default = "WAN"
    description = "The name of the firewall interface list that the new macvlan interfaces should be added to. Defaults to WAN"
}
