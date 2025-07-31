cluster_name = "honeypot"
controlplane_url = "queenbee.savew.dev"
main_domain = "savew.dev"
kubernetes_version = "v1.33.3"

control_planes = {
  1 = {
    name        = "queenbee"
    cloud_type  = "hetzner",
    server_type = "cpx21",
    location    = "fsn1",
    image       = "306178397",
  }
}

workers = {
  1 = {
    name        = "honeypie"
    cloud_type  = "hetzner",
    server_type = "cax21",
    location    = "fsn1",
    image       = "306202035",
  },
  2 = {
    name        = "honeybee"
    cloud_type  = "hetzner",
    server_type = "cax21",
    location    = "nbg1",
    image       = "306202035",
  }
}



