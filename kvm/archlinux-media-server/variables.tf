###### MOSTLY STATIC CONFIGS ######
variable "mac_addr_script" {
  type = string
  description = "Mac addr script, produces the same mac address each time as long as the hostname is the same."
  default = "mac_addr.sh"
}
variable "libvirt_uri" {
  type = string
  description = "The QEMU URI for the KVM parent."
  default = "qemu+ssh://root@KVMHOSTIPORURLHERE/system?keyfile=/opt/jenkins/id_rsa"
}
variable "network" {
  type = string
  description = "The virtual network to use on the KVM parent."
  default = "network"
}
variable "commoninit_storage_pool" {
  type = string
  description = "The storage pool for the cloud init iso that configures the instance."
  default = "pool"
}
variable "qcow2_storage_pool" {
  type = string
  description = "The storage pool that the VM disk will reside in."
  default = "storage"
}
variable "disk_name" {
  type = string
  description = "The name of the VM side disk."
  default = "/dev/vda"
}
variable "boot_order" {
  type = list
  description = "The boot order of the VM, this is what allows the ISOs to first-boot."
  default = [ "hd", "cdrom" ]
}
variable "token" {
  type = string
  description = "The Jenkins API username:token."
  default = "JENKINS_USER:JENKINS_TOKEN"
}
variable "cloudinit_script" {
  type = string
  description = "The name of the script used in template_file.user_data."
  default = "cloud_init.sh.tpl"
}
###### END MOSTLY STATIC CONFIGS ######

###### COMMONLY CHANGED CONFIGS ######
variable "commoninit_iso" {
  type = string
  description = "The ISO name of the cloudinit ISO."
  default = "arch-media-server-commoninit.iso"
}
variable "install_iso" {
  type = string
  description = "The ISO that will be used to install Linux."
  default = "/home/linux_iso/archlinux-2022.03.01-x86_64.iso"
}
variable "disk_size" {
  type = number
  description = "Disk size in bytes, 10G = 10000000000"
  default = 10000000000
}
variable "memory" {
  type = string
  description = "VM RAM allotment in MB."
  default = "4096"
}
variable "vcpu" {
  type = number
  description = "Number of CPU cores to give VM."
  default = 4
}
variable "hostname" {
  type = string
  description = "The hostname to give the VM. This is used with Jenkins."
  default = "media.domain.tld"
}
###### END COMMONLY CHANGED CONFIGS ######
