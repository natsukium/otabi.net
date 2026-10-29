terraform {
  required_providers {
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "~> 5.0"
    }
  }
}

provider "cloudflare" {}

variable "zone_id" {}

variable "account_id" {}

variable "project_name" {
  default = "otabi-net"
}

variable "domain" {
  default = "otabi.net"
}

moved {
  from = cloudflare_record.apex
  to   = cloudflare_dns_record.apex
}

resource "cloudflare_dns_record" "apex" {
  zone_id = var.zone_id
  type    = "CNAME"
  name    = "otabi.net"
  content = cloudflare_pages_project.otabi_net.subdomain
  proxied = true
  ttl     = 1
}

resource "cloudflare_pages_domain" "apex" {
  account_id   = var.account_id
  project_name = var.project_name
  name         = var.domain
}

resource "cloudflare_pages_project" "otabi_net" {
  account_id        = var.account_id
  name              = var.project_name
  production_branch = "main"
  source = {
    type = "github"
    config = {
      owner                          = "natsukium"
      repo_name                      = "otabi.net"
      production_branch              = "main"
      preview_deployment_setting     = "all"
      production_deployments_enabled = true
      preview_branch_includes        = ["*"]
    }
  }
  build_config = {
    build_command   = "npm run build"
    destination_dir = "/dist"
    root_dir        = "/"
  }
}
