terraform {
  required_providers {
    libvirt = {
      source = "dmacvicar/libvirt"
    }
  }
  backend "local" {
    path = "/opt/jenkins/terraform/archlinux-media-server-terraform.tfstate"
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
  lifecycle {
    prevent_destroy = true
  }
}

data "template_file" "user_data" {
  template = file("${path.module}/${var.cloudinit_script}")
  vars = {
    hostname = var.hostname
    disk_name = var.disk_name
    token = var.token
  }
  lifecycle {
    prevent_destroy = true
  }
}

resource "libvirt_volume" "vm_disk" {
  name = var.hostname
  pool = var.qcow2_storage_pool
  format = "qcow2"
  size = var.disk_size
  lifecycle {
    prevent_destroy = true
  }
}

resource "libvirt_domain" "virt_domain" {
  name = var.hostname
  memory = var.memory
  vcpu = var.vcpu
  autostart = true
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
  disk {
    file = var.install_iso
  }
  lifecycle {
    prevent_destroy = true
  }
}
