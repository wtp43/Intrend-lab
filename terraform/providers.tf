# terraform/providers.tf
terraform {
  required_providers {
    talos = {
      source  = "siderolabs/talos"
      version = ">=0.6.0"
    }
    proxmox = {
      source  = "bpg/proxmox"
      version = ">=0.66.1"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = ">=2.32.0"
    }
    helm = {
      source  = "hashicorp/helm"
      version = ">=2.16.0"
    }
  }
}

provider "helm" {
  kubernetes {
    config_path = "output/kube-config.yaml"
  }
}

provider "proxmox" {
  endpoint = var.proxmox.endpoint
  insecure = var.proxmox.insecure

  username = "${var.proxmox.username}@pam"
  password = var.proxmox.password

  # api_token = var.proxmox.api_token
  ssh {
    agent = true
    # username = var.proxmox.username
  }
}

provider "kubernetes" {
  host                   = module.talos.kube_config.kubernetes_client_configuration.host
  client_certificate     = base64decode(module.talos.kube_config.kubernetes_client_configuration.client_certificate)
  client_key             = base64decode(module.talos.kube_config.kubernetes_client_configuration.client_key)
  cluster_ca_certificate = base64decode(module.talos.kube_config.kubernetes_client_configuration.ca_certificate)
}
