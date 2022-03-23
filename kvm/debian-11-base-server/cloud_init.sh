#!/bin/bash

sleep 10

# this script assumes that jenkins and the script server are subdomains of the same domain.
BASE_DOMAIN="domain.tld"

echo ${hostname} > /etc/hostname
hostname -F /etc/hostname

# this is because I am lazy and don't want to pull apart my home network to set it up to handle network routes the correct way. Debian doesn't like my home dhcp/network route setup.
echo "# This file describes the network interfaces available on your system
# and how to activate them. For more information, see interfaces(5).

source /etc/network/interfaces.d/*

# The loopback network interface
auto lo
iface lo inet loopback

# The primary network interface
auto ens3
allow-hotplug ens3
iface ens3 inet static
	address ${static_ip}
	netmask ${netmask}
	gateway ${gateway}
	dns-nameservers ${nameserver}" > /etc/network/interfaces

#rm -f /etc/network/interfaces.d/*cloud-init
systemctl restart networking

echo 'en_US.UTF-8 UTF-8' > /etc/locale.gen
locale-gen

apt-get -y update
apt-get -y upgrade

apt-get -y install vim rsync python3

mkdir /root/.ssh
chmod 700 /root/.ssh
curl -s -o /root/.ssh/authorized_keys "http://scripts.$BASE_DOMAIN/general/jenkins_ssh_key.pub"
chmod 600 /root/.ssh/authorized_keys

touch /forcefsck

curl -s -X POST -u ${token} "http://jenkins.$BASE_DOMAIN/job/New%20Server%20Configuration/buildWithParameters?ansible_hosts_to_update=${hostname}&ansible_hosts_to_reboot=${hostname}"
