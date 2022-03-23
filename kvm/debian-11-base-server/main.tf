terraform {
  required_providers {
    libvirt = {
      source = "dmacvicar/libvirt"
    }
  }
  backend "local" {
    path = "/opt/jenkins/terraform/debian-11-base-terraform.tfstate"
  }
}

provider "libvirt" {
  uri = var.libvirt_uri
}

data "external" "mac_addr" {
  program = ["/usr/bin/env", "bash", "${path.module}/${var.mac_addr_script}"]
  query = {
    hostname = var.hostname
  }
}

resource "libvirt_cloudinit_disk" "commoninit" {
  name      = var.commoninit_iso
  user_data = data.template_file.user_data.rendered
  pool = var.commoninit_storage_pool
}

data "template_file" "user_data" {
  template = file("${path.module}/${var.cloudinit_script}")
  vars = {
    static_ip = var.static_ip
    netmask = var.netmask
    gateway = var.gateway
    nameserver = var.nameserver
    hostname = var.hostname
    token = var.token
  }
}

resource "libvirt_volume" "vm_disk" {
  name = var.hostname
  pool = var.qcow2_storage_pool
  format = "qcow2"
  base_volume_name = var.source_qcow2
  base_volume_pool = var.source_pool
  size = var.disk_size
}

resource "libvirt_domain" "virt_domain" {
  name = var.hostname
  memory = var.memory
  vcpu = var.vcpu
  autostart = true
  console {
    type = "pty"
    target_port = "0"
    target_type = "serial"
    source_path = "/dev/pts/4"
  }
  network_interface {
    network_name = var.network
    mac = data.external.mac_addr.result.mac_addr
  }
  cloudinit = libvirt_cloudinit_disk.commoninit.id
  boot_device {
    dev = var.boot_order
  }
  disk {
    volume_id = libvirt_volume.vm_disk.id
  }
}
