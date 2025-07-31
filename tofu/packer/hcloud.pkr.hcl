packer {
  required_plugins {
    hcloud = {
      source  = "github.com/hetznercloud/hcloud"
      version = "~> 1"
    }
  }
}

variable "server_type" {
  type    = string
  default = "cx22"
}

variable "server_location" {
  type    = string
}

variable "hcloud_token" {
  type = string
}

source "hcloud" "fedora_base" {
  token       = var.hcloud_token
  image       = "fedora-42"       # Or another Fedora image you prefer, e.g. "fedora-39"
  location    = var.server_location
  server_type = var.server_type
  ssh_username = "root"

  snapshot_name = "k0s-fedora-ready-{{timestamp}}"
  snapshot_labels = {
    type = "k0s-base"
    os   = "fedora"
  }
}

build {
  sources = ["source.hcloud.fedora_base"]

  provisioner "shell" {
    inline = [
      "dnf install -y firewalld",
      "systemctl enable --now firewalld",
      "iptables -F",
      "firewall-cmd --zone=trusted --permanent --add-interface={tailscale0,cni0,vxlan.calico,flannel.1,cali+}",
      "firewall-cmd --zone=public --permanent --add-service={dns,http,https,mdns,llmnr}",
      "sudo firewall-cmd --permanent --add-forward",
      "sudo firewall-cmd --permanent --add-masquerade",
      "firewall-cmd --reload",

      # Add kernel params for cgroup and zram
      "echo ' cgroup_enable=memory systemd.zram=0 ' >> /etc/kernel/cmdline",

      "cat <<EOF > /etc/sysctl.d/kubernetes.conf\nnet.bridge.bridge-nf-call-ip6tables = 1\nnet.bridge.bridge-nf-call-iptables = 1\nnet.ipv6.conf.all.forwarding = 1\nnet.ipv4.conf.all.src_valid_mark = 1\nnet.ipv4.ip_forward = 1\nEOF",
      "sysctl --system",

      "echo -e 'br_netfilter\\noverlay' > /etc/modules-load.d/kubernetes.conf",

      "dnf --refresh update -y",

      "dracut -fv",
      "grub2-mkconfig -o /boot/grub2/grub.cfg",
      "curl -fsSL https://tailscale.com/install.sh | sh",
      "systemctl enable --now tailscaled"
    ]
  }
}
