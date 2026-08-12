# =================================================================================================
# User Groups
# =================================================================================================
resource "routeros_system_user_group" "groups" {
  for_each = var.groups

  name    = each.key
  policy  = each.value.policies
  comment = each.value.comment
}


# =================================================================================================
# 1Password Password
# =================================================================================================

data "onepassword_item" "password" {
  for_each = var.users

  vault = each.value.op_vault
  title = "${var.hostname}-${var.model}-${each.value.op_item_title_suffix}"
}

# =================================================================================================
# Users
# =================================================================================================
resource "routeros_system_user" "users" {
  for_each = var.users

  name               = each.key
  group              = each.value.group
  password           = data.onepassword_item.password[each.key].password
  comment            = each.value.comment
  address            = each.value.address
  inactivity_policy  = each.value.inactivity_policy
  inactivity_timeout = each.value.inactivity_timeout

  depends_on = [routeros_system_user_group.groups]
}
