#!/bin/bash

sleep 10

BASE_DOMAIN="domain.tld"

echo ${hostname} > /etc/hostname
hostname -F /etc/hostname

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

rm -f /etc/network/interfaces.d/*cloud-init
systemctl restart networking

echo 'en_US.UTF-8 UTF-8' > /etc/locale.gen
locale-gen

apt-get -y update
apt-get -y upgrade

apt-get -y install vim rsync python3 isc-dhcp-server

if [[ -z $(systemctl is-enabled isc-dhcp-server | tail -n1 | grep enabled) ]] ; then
  systemctl enable isc-dhcp-server
fi

mkdir /root/.ssh
chmod 700 /root/.ssh
curl -s -o /root/.ssh/authorized_keys "http://scripts.$BASE_DOMAIN/general/jenkins_ssh_key.pub"
chmod 600 /root/.ssh/authorized_keys

echo "
default-lease-time 3600;
max-lease-time 72000;
authoritative;
log-facility local7;
option rfc3442-classless-static-routes code 121 = array of integer 8;
option ms-classless-static-routes code 249 = array of integer 8;
subnet SUBNETHERE netmask NETMASKHERE {
    authoritative;
    range STARTIPRANGEHERE ENDIPRANGEHERE; 
    option domain-name-servers MAMESERVERHERE;
    option domain-name "lan";
    option routers ROUTER/GATEWAYHERE;
    option rfc3442-classless-static-routes 24, INTRANET_RANGE_OCT1, INTRANET_RANGE_OCT2, INTRANET_RANGE_OCT3, GATEWAY_OCT1, GATEWAY_OCT2, GATEWAY_OCT3, GATEWAY_OCT4, THIS_DHCP_OC1, THIS_DHCP_OCT2, THIS_DHCP_OCT3, THIS_DHCP_OCT4;
    option ms-classless-static-routes 24, INTRANET_RANGE_OCT1, INTRANET_RANGE_OCT2, INTRANET_RANGE_OCT3, THIS_DHCP_OC1, THIS_DHCP_OCT2, THIS_DHCP_OCT3, THIS_DHCP_OCT4, GATEWAY_OCT1, GATEWAY_OCT2, GATEWAY_OCT3, GATEWAY_OCT4;
    option broadcast-address THIS_DHCP_SERVER_IP;
    default-lease-time 600;
    max-lease-time 7200;
    host HOSTHERE { hardware ethernet MACHERE; fixed-address RESERVEDIPHERE; }
    host HOSTHERE { hardware ethernet MACHERE; fixed-address RESERVEDIPHERE; }
}
" > /etc/dhcp/dhcpd.conf

echo 'INTERFACES="ens3"' >> /etc/default/isc-dhcp-server

touch /forcefsck

curl -s -X POST -u ${token} "http://jenkins.$BASE_DOMAIN/job/New%20Server%20Configuration/buildWithParameters?ansible_hosts_to_update=${hostname}&ansible_hosts_to_reboot=${hostname}"
