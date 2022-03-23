terraform {
  required_providers {
    libvirt = {
      source = "dmacvicar/libvirt"
    }
  }
  backend "local" {
    path = "/opt/jenkins/terraform/archlinux-cluster-terraform.tfstate"
  }
}

provider "libvirt" {
  uri = var.libvirt_uri
}

data "external" "mac_addr" {
  count = var.cnt
  program = ["/usr/bin/env", "bash", "${path.module}/${var.mac_addr_script}"]
  query = {
    hostname = "${var.hostname_prefix}${count.index}${var.hostname_suffix}"
  }
}

resource "libvirt_cloudinit_disk" "commoninit" {
  count = var.cnt
  name      = "${var.commoninit_iso_prefix}${count.index}${var.commoninit_iso_suffix}"
  user_data = data.template_file.user_data[count.index].rendered
  pool = var.commoninit_storage_pool
}

data "template_file" "user_data" {
  count = var.cnt
  template = file("${path.module}/${var.cloudinit_script}")
  vars = {
    hostname = "${var.hostname_prefix}${count.index}${var.hostname_suffix}"
    disk_name = var.disk_name
    token = var.token
  }
}

resource "libvirt_volume" "vm_disk" {
  count = var.cnt
  name = "${var.hostname_prefix}${count.index}${var.hostname_suffix}"
  pool = var.qcow2_storage_pool
  format = "qcow2"
  size = var.disk_size
}

resource "libvirt_domain" "virt_domain" {
  count = var.cnt
  name = "${var.hostname_prefix}${count.index}${var.hostname_suffix}"
  memory = var.memory
  vcpu = var.vcpu
  autostart = true
  network_interface {
    network_name = var.network
    mac = data.external.mac_addr[count.index].result.mac_addr
  }
  cloudinit = libvirt_cloudinit_disk.commoninit[count.index].id
  boot_device {
    dev = var.boot_order
  }
  disk {
    volume_id = libvirt_volume.vm_disk[count.index].id
  }
  disk {
    file = var.install_iso
  }
}
