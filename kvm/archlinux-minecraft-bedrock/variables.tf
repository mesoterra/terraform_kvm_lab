###### MOSTLY STATIC CONFIGS ######
variable "mac_addr_script" {
  type = string
  description = "Mac addr script, produces the same mac address based on the hostname."
  default = "mac_addr.sh"
}
variable "libvirt_uri" {
  type = string
  default = "qemu+ssh://root@KVMHOSTIPORURLHERE/system?keyfile=/opt/jenkins/id_rsa"
}
variable "network" {
  type = string
  default = "network"
}
variable "commoninit_storage_pool" {
  type = string
  default = "pool"
}
variable "qcow2_storage_pool" {
  type = string
  default = "storage"
}
variable "disk_name" {
  type = string
  default = "/dev/vda"
}
variable "boot_order" {
  type = list
  default = [ "hd", "cdrom" ]
}
variable "token" {
        type = string
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
  default = "arch-minecraft-bedrock-commoninit.iso"
}
variable "install_iso" {
  type = string
  description = "The ISO that will be used to install Linux."
  default = "/home/linux_iso/archlinux-2022.03.01-x86_64.iso"
}
variable "disk_size" {
  type = number
  description = "Disk size in bytes, 50G ish = 50000000000 ish"
  default = 50000000000
}
variable "memory" {
  type = string
  description = "VM RAM allotment in MB."
  default = "2048"
}
variable "vcpu" {
  type = number
  description = "Number of CPU cores to give VM."
  default = 2
}
variable "hostname" {
  type = string
  description = "The hostname to give the VM. This is used with Jenkins."
  default = "bedrock.domain.tld"
}
###### END COMMONLY CHANGED CONFIGS ######
