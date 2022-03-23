#!/usr/bin/bash
sleep 10
BASE_DOMAIN='domain.tld'
echo "curl -s -X POST -u ${token} \"http://jenkins.$BASE_DOMAIN/job/Provisioning%20-%20Media%20Server%20Configuration/buildWithParameters?ansible_hosts_to_update=\$ip\"" > /root/arch-linux-config.sh
curl -s -o /root/pre-config.sh "http://scripts.$BASE_DOMAIN/arch-linux/pre-config.sh"
chmod 700 /root/pre-config.sh
/root/pre-config.sh ${hostname} ${disk_name} ${token}
