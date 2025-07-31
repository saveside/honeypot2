data "template_file" "tailscale_cloudinit_control-planes" {
  for_each = {
    for k, v in var.control_planes : k => v
    if v.cloud_type == "hetzner"
  }
  template = file("${path.module}/templates/cloudinit.yaml.tmpl")

  vars = {
    TS_AUTHKEY    = var.tailscale_auth_key
    TS_HOSTNAME   = each.value.name
    node_password = var.node_password
  }
}

data "template_file" "tailscale_cloudinit_workers" {
  for_each = {
    for k, v in var.workers : k => v
    if v.cloud_type == "hetzner"
  }
  template = file("${path.module}/templates/cloudinit.yaml.tmpl")
  
  vars = {
    TS_AUTHKEY    = var.tailscale_auth_key
    TS_HOSTNAME   = each.value.name
    node_password = var.node_password
  }
}
