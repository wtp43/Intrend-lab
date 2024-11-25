# terraform/main.tf
module "talos" {
  source = "./talos"

  providers = {
    proxmox = proxmox
  }

  image = {
    version   = "v1.8.1"
    schematic = file("${path.module}/talos/image/schematic.yaml")
  }

  cilium = {
    install = file("${path.module}/talos/inline-manifests/cilium-install.yaml")
    values  = file("${path.module}/../k8s/infra/network/cilium/values.yaml")
  }

  cluster = {
    name            = "talos"
    endpoint        = "192.168.50.100"
    gateway         = "192.168.50.1"
    talos_version   = "v1.8.1"
    proxmox_cluster = "intrend"
  }

  nodes = {
    "ctrl-00" = {
      host_node     = "trpro"
      machine_type  = "controlplane"
      ip            = "192.168.50.100"
      mac_address   = "BC:24:11:2E:C8:00"
      vm_id         = 100
      cpu           = 4
      ram_dedicated = 8192
      datastore_id  = "sabrent-1tb"
    }
    "ctrl-01" = {
      host_node     = "m70q5"
      machine_type  = "controlplane"
      ip            = "192.168.50.101"
      mac_address   = "BC:24:11:2E:C8:01"
      vm_id         = 101
      cpu           = 4
      ram_dedicated = 6144
      datastore_id  = "local"
    }
    "ctrl-02" = {
      host_node     = "m75q2"
      machine_type  = "controlplane"
      ip            = "192.168.50.102"
      mac_address   = "BC:24:11:2E:C8:02"
      vm_id         = 102
      cpu           = 4
      ram_dedicated = 4096
      datastore_id  = "local"
    }
    "ctrl-03" = {
      host_node     = "t640"
      machine_type  = "controlplane"
      ip            = "192.168.50.103"
      mac_address   = "BC:24:11:2E:C8:03"
      vm_id         = 103
      cpu           = 4
      ram_dedicated = 4096
      datastore_id  = "sn770"
    }
    "work-00" = {
      host_node     = "trpro"
      machine_type  = "worker"
      ip            = "192.168.50.110"
      mac_address   = "BC:24:11:2E:08:00"
      vm_id         = 200
      cpu           = 52
      ram_dedicated = 131072
      datastore_id  = "sabrent-1tb"
    }
    "work-01" = {
      host_node     = "m70q5"
      machine_type  = "worker"
      ip            = "192.168.50.111"
      mac_address   = "BC:24:11:2E:08:01"
      vm_id         = 201
      cpu           = 14
      ram_dedicated = 28672
      datastore_id  = "local"
    }
    "work-02" = {
      host_node     = "m75q2"
      machine_type  = "worker"
      ip            = "192.168.50.112"
      mac_address   = "BC:24:11:2E:08:02"
      vm_id         = 202
      cpu           = 10
      ram_dedicated = 10240
      datastore_id  = "local"
    }
    "work-03" = {
      host_node     = "t640"
      machine_type  = "worker"
      ip            = "192.168.50.113"
      mac_address   = "BC:24:11:2E:08:03"
      vm_id         = 203
      cpu           = 44
      ram_dedicated = 28672
      datastore_id  = "sn770"
    }
  }
}

module "onepassword_connect" {
  depends_on = [module.talos]
  source     = "./bootstrap/onepassword-connect"
  providers = {
    kubernetes = kubernetes
    helm       = helm
  }
  onepassword = {
    connect_credentials = file("${path.module}/bootstrap/onepassword-connect/1password-credentials.b64")
    operator_token      = file("${path.module}/bootstrap/onepassword-connect/operator_token.key")
  }
}
