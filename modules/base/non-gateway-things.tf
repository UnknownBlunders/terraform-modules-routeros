resource "routeros_ip_dns" "server" {
  count = var.dns_servers != null ? 1 : 0

  allow_remote_requests = var.dns_allow_remote_requests
  servers               = var.dns_servers
  cache_size            = var.dns_cache_size
  cache_max_ttl         = var.dns_cache_max_ttl
}

resource "routeros_ip_route" "default_route" {
  count = var.default_route != null ? 1 : 0

  dst_address = "0.0.0.0/0"
  gateway     = var.default_route
}
