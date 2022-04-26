terraform {
  required_providers {
    proxmox = {
      source  = "Telmate/proxmox"
      version = "2.9.9"
    }
  }
}

provider "proxmox" {
  pm_api_url          = "https://proxmox.lan:8006/api2/json"
  pm_tls_insecure     = true
  pm_api_token_id     = "terraform-prov@pve!mytoken"
  pm_api_token_secret = var.proxmox_api_token_secret
  pm_parallel         = 1
}

resource "random_password" "k3s_token" {
  length  = 48
  special = false
}

resource "proxmox_vm_qemu" "k3s-master-01" {
  name        = "k3s-master-01"
  vmid        = 211
  ipconfig0   = "ip=${var.k3s_master_01}/24,gw=${var.gateway}"
  nameserver  = var.gateway
  count       = 1
  target_node = "pve"
  clone       = var.template_name
  os_type     = "cloud-init"
  agent       = 1
  memory      = var.k3s_masters_memory
  cores       = var.k3s_masters_cores
  cpu         = "host"

  network {
    model  = "virtio"
    bridge = "vmbr0"
  }

  disk {
    slot     = 0
    size     = "32G"
    type     = "scsi"
    storage  = "vm-storage"
    iothread = 1
  }

  lifecycle {
    ignore_changes = [
      network,
    ]
  }

  connection {
    type        = "ssh"
    user        = "coen"
    private_key = file("${var.ssh_private_key_path}")
    host        = self.default_ipv4_address
  }

  provisioner "file" {
    destination = "/tmp/k3s_bootstrap.sh"
    content = templatefile("k3s_bootstrap.sh.tpl",
      {
        k3s_token           = random_password.k3s_token.result,
        k3s_cluster_init_ip = var.k3s_master_01
      }
    )
  }

  provisioner "remote-exec" {
    inline = [
      "set -e",
      "chmod +x /tmp/k3s_bootstrap.sh",
      "sudo /tmp/k3s_bootstrap.sh"
    ]
  }
}

resource "proxmox_vm_qemu" "k3s-master-02" {

  depends_on = [
    proxmox_vm_qemu.k3s-master-01[0]
  ]

  name        = "k3s-master-02"
  vmid        = 212
  ipconfig0   = "ip=${var.k3s_master_02}/24,gw=${var.gateway}"
  nameserver  = var.gateway
  count       = 1
  target_node = "pve"
  clone       = var.template_name
  os_type     = "cloud-init"
  agent       = 1
  memory      = var.k3s_masters_memory
  cores       = var.k3s_masters_cores
  cpu         = "host"

  network {
    model  = "virtio"
    bridge = "vmbr0"
  }

  disk {
    slot     = 0
    size     = "32G"
    type     = "scsi"
    storage  = "vm-storage"
    iothread = 1
  }

  lifecycle {
    ignore_changes = [
      network,
    ]
  }

  connection {
    type        = "ssh"
    user        = "coen"
    private_key = file("${var.ssh_private_key_path}")
    host        = var.k3s_master_02
  }

  provisioner "file" {
    destination = "/tmp/k3s_bootstrap.sh"
    content = templatefile("k3s_bootstrap.sh.tpl",
      {
        k3s_token           = random_password.k3s_token.result,
        k3s_cluster_init_ip = var.k3s_master_01
      }
    )
  }

  provisioner "remote-exec" {
    inline = [
      "set -e",
      "chmod +x /tmp/k3s_bootstrap.sh",
      "sudo /tmp/k3s_bootstrap.sh"
    ]
  }
}

resource "proxmox_vm_qemu" "k3s-master-03" {

  depends_on = [
    proxmox_vm_qemu.k3s-master-01[0]
  ]

  name        = "k3s-master-03"
  vmid        = 213
  ipconfig0   = "ip=${var.k3s_master_03}/24,gw=${var.gateway}"
  nameserver  = var.gateway
  count       = 1
  target_node = "pve"
  clone       = var.template_name
  os_type     = "cloud-init"
  agent       = 1
  memory      = var.k3s_masters_memory
  cores       = var.k3s_masters_cores
  cpu         = "host"

  network {
    model  = "virtio"
    bridge = "vmbr0"
  }

  disk {
    slot     = 0
    size     = "32G"
    type     = "scsi"
    storage  = "vm-storage"
    iothread = 1
  }

  lifecycle {
    ignore_changes = [
      network,
    ]
  }

  connection {
    type        = "ssh"
    user        = "coen"
    private_key = file("${var.ssh_private_key_path}")
    host        = var.k3s_master_03
  }

  provisioner "file" {
    destination = "/tmp/k3s_bootstrap.sh"
    content = templatefile("k3s_bootstrap.sh.tpl",
      {
        k3s_token           = random_password.k3s_token.result,
        k3s_cluster_init_ip = var.k3s_master_01
      }
    )
  }

  provisioner "remote-exec" {
    inline = [
      "set -e",
      "chmod +x /tmp/k3s_bootstrap.sh",
      "sudo /tmp/k3s_bootstrap.sh"
    ]
  }
}
