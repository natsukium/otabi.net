terraform {
  required_providers {
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "~>3.0"
    }
  }
}

provider "cloudflare" {}

variable "account_id" {}

variable "project_name" {
  default = "otabi-net"
}

resource "cloudflare_pages_project" "otabi_net" {
  account_id        = var.account_id
  name              = var.project_name
  production_branch = "main"
  source {
    type = "github"
    config {
      owner                         = "natsukium"
      repo_name                     = "otabi.net"
      production_branch             = "main"
      deployments_enabled           = true
      production_deployment_enabled = true
      preview_branch_includes       = ["*"]
      preview_branch_excludes       = []
    }
  }
  build_config {
    build_command   = "npm run build"
    destination_dir = "/dist"
    root_dir        = "/"
  }
  deployment_configs {
    preview {
      environment_variables = {
        NODE_VERSION = "16.12.0"
      }
    }
    production {
      environment_variables = {
        NODE_VERSION = "16.12.0"
      }
    }
  }
}

