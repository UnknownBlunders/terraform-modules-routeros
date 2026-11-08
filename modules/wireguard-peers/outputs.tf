output "peer_count" {
  description = "The total number of WireGuard peers managed by this module."
  value       = length(var.peers)
}

output "peer_names" {
  description = "A list of all peer names managed by this module."
  value       = keys(var.peers)
}
