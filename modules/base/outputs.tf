# =================================================================================================
# Bridge Outputs
# =================================================================================================
output "bridge_name" {
  description = "The name of the bridge interface."
  value       = routeros_interface_bridge.bridge.name
}

output "bridge_id" {
  description = "The resource ID of the bridge interface."
  value       = routeros_interface_bridge.bridge.id
}

# =================================================================================================
# VLAN Outputs
# =================================================================================================
output "vlan_ids" {
  description = "Map of VLAN names to their VLAN IDs."
  value = {
    for k, v in routeros_interface_vlan.vlans : v.name => v.vlan_id
  }
}

output "vlan_interfaces" {
  description = "Map of VLAN names to their interface details (name, VLAN ID, MTU, address)."
  value = {
    for k, v in routeros_interface_vlan.vlans : v.name => {
      name    = v.name
      vlan_id = v.vlan_id
      mtu     = v.mtu
      address = try(routeros_ip_address.vlan_addresses[k].address, null)
    }
  }
}

output "vlan_addresses" {
  description = "Map of VLAN names to the static IP address (in CIDR notation) assigned to their interface. Only includes VLANs that declared an 'address'."
  value = {
    for k, v in routeros_ip_address.vlan_addresses : var.vlans[k].name => v.address
  }
}

# =================================================================================================
# Certificate Outputs
# =================================================================================================
output "certificate_name" {
  description = "The name of the device TLS certificate."
  value       = routeros_system_certificate.webfig.name
}

output "certificate_common_name" {
  description = "The Common Name (CN) of the device TLS certificate."
  value       = routeros_system_certificate.webfig.common_name
}

output "certificate_fingerprint" {
  description = "The fingerprint of the device TLS certificate."
  value       = routeros_system_certificate.webfig.fingerprint
}

output "ca_certificate_name" {
  description = "The name of the root CA certificate."
  value       = routeros_system_certificate.local-root-ca-cert.name
}

# =================================================================================================
# System Outputs
# =================================================================================================
output "hostname" {
  description = "The configured hostname (system identity) of the device."
  value       = routeros_system_identity.identity.name
}
