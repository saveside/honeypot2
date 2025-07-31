provider "hcloud" {
  token = var.hcloud_token
}

resource "hcloud_server" "control_plane" {
  for_each = {
    for k, v in var.control_planes : k => v
    if v.cloud_type == "hetzner"
  }

  name         = each.value.name
  server_type  = each.value.server_type
  location     = each.value.location
  labels       = { "type" : "k0s-control-plane" }
  image        = each.value.image

  user_data    = data.template_file.tailscale_cloudinit_control-planes[each.key].rendered

  public_net {
    ipv4_enabled = true
    ipv6_enabled = true
  }

  lifecycle {
    ignore_changes = [user_data]
  }
}

resource "hcloud_server" "worker" {
  for_each = {
    for k, v in var.workers : k => v
    if v.cloud_type == "hetzner"
  }

  name         = each.value.name
  server_type  = each.value.server_type
  location     = each.value.location
  labels       = { "type" : "k0s-worker" }
  image        = each.value.image

  user_data    = data.template_file.tailscale_cloudinit_workers[each.key].rendered

  public_net {
    ipv4_enabled = true
    ipv6_enabled = true
  }

  lifecycle {
    ignore_changes = [user_data]
  }
}

