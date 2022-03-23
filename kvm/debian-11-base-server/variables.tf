###### MOSTLY STATIC CONFIGS ######
variable "mac_addr_script" {
	type = string
	description = "Mac addr script, generates the same mac every time based on the hostname."
	default = "mac_addr.sh"
}
variable "libvirt_uri" {
	type = string
	default = "qemu+ssh://root@KVMHOSTIPORURLHERE/system?keyfile=/opt/jenkins/id_rsa"
}
variable "source_pool" {
	type = string
	default = "base_images"
}
variable "source_qcow2" {
	type = string
	default = "debian-11-generic-amd64.qcow2"
}
variable "boot_order" {
	type = list
	default = [ "hd", "cdrom" ]
}
variable "network" {
	type = string
	default = "network"
}
variable "graphics_type" {
	type = string
	default = "vnc"
}
variable "qcow2_storage_pool" {
	type = string
	default = "storage"
}
variable "commoninit_storage_pool" {
	type = string
	default = "pool"
}
variable "token" {
	type = string
	default = "JENKINS_USER:JENKINS_TOKEN"
}
variable "nameserver" {
	type = string
	default = "NAMESERVERHERE"
}
variable "gateway" {
	type = string
	default = "GATEWAYHERE"
}
variable "netmask" {
	type = string
	default = "NETMASKHERE"
}
variable "cloudinit_script" {
	type = string
	description = "The name of the script used in template_file.user_data."
	default = "cloud_init.sh"
}
###### END MOSTLY STATIC CONFIGS ######

###### COMMONLY CHANGED CONFIGS ######
variable "commoninit_iso" {
	type = string
	description = "The ISO name of the cloudinit ISO."
	default = "debian-11-base-commoninit.iso"
}
variable "disk_size" {
	type = number
	description = "Disk configured in bytes."
	default = 10737418240
}
variable "memory" {
	type = string
	description = "RAM configured in MB."
	default = "2048"
}
variable "vcpu" {
	type = number
	default = 1
}
variable "hostname" {
	type = string
	default = "debian-11-base.domain.tld"
}
variable "static_ip" {
	type = string
	description = "Static IP because Debian doesn't like my DHCP setup and I don't want to fix it right now."
	default = "IPHERE"
}

