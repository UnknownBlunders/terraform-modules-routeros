resource "routeros_interface_wireguard_peer" "this" {
  for_each = var.peers

  interface            = var.interface
  public_key           = data.onepassword_item.peer-key[each.key].section_map[""].field_map["client-public-key"].value
  allowed_address      = each.value.allowed_address
  comment              = each.value.comment
  endpoint_address     = each.value.endpoint_address
  endpoint_port        = each.value.endpoint_port
  persistent_keepalive = each.value.persistent_keepalive
  preshared_key        = each.value.preshared_key
  is_responder         = each.value.is_responder
  client_dns           = each.value.client_dns
  client_endpoint      = each.value.client_endpoint
}

data "onepassword_item" "peer-key" {
  for_each = var.peers

  vault = "aecurxfwrekp3fqpdjij4vnvjm"
  title = "${each.key}-wireguard"
}
