variable "kubernetes_version" {
  description = "Kubernetes version"
  type        = string
  default     = "v1.33.3"
}

variable "cluster_name" {
  description = "Cluster name"
  type        = string
  default     = "honeypot"
}

variable "controlplane_url" {
  description = "Control plane URL"
  type        = string
}

variable "main_domain" {
  description = "Control plane URL"
  type        = string
}

variable "workers" {
  description = "Worker definition"
  type = map(object({
    name        = string
    cloud_type  = string
    server_type = string
    location    = optional(string)
    image       = optional(string)
  }))
}

variable "control_planes" {
  description = "Control plane definition"
  type = map(object({
    name        = string
    cloud_type  = string
    server_type = string
    location    = optional(string)
    image       = optional(string)
  }))
}

variable "tailscale_auth_key" {
  description = "Tailscale auth key"
  sensitive   = true
  type        = string
}

variable "tailnet" {
  description = "Tailnet name"
  type        = string
}

variable "tailnet_oauth_client_id" {
  description = "OAuth client ID"
  sensitive   = true
  type        = string
}

variable "tailnet_oauth_client_secret" {
  description = "OAuth client secret"
  sensitive   = true
  type        = string
}

variable "node_password" {
  description = "Node Password"
  sensitive   = true
  type        = string
}

variable "cloudflare_api_token" {
  description = "Cloudflare API token"
  sensitive   = true
  type        = string
}

variable "cloudflare_zone_id" {
  description = "Cloudflare Zone ID"
  sensitive   = true
  type        = string
}

variable "hcloud_token" {
  description = "Hetzner Cloud token"
  sensitive   = true
  type        = string
  default     = null
}

