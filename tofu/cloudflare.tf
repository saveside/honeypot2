provider "cloudflare" {
  api_token = var.cloudflare_api_token
}

resource "cloudflare_dns_record" "control_planes" {
  for_each = {
    for k, v in var.control_planes : k => v
    if v.cloud_type == "hetzner"
  }

  zone_id  = var.cloudflare_zone_id
  name     = var.controlplane_url
  content  = hcloud_server.control_plane[each.key].ipv4_address
  comment  = each.value.name
  type     = "A"
  ttl      = 3600
}

resource "cloudflare_dns_record" "control_planes_wildcard" {
  for_each = {
    for k, v in var.control_planes : k => v
    if v.cloud_type == "hetzner"
  }

  zone_id  = var.cloudflare_zone_id
  name     = "*"
  content  = hcloud_server.control_plane[each.key].ipv4_address
  comment  = each.value.name
  type     = "A"
  ttl      = 3600
}

