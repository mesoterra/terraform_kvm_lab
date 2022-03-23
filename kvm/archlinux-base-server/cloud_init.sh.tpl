#!/usr/bin/bash
sleep 10
SCRIPT_HOST='domain.tld'
curl -s -o /root/pre-config.sh "http://$SCRIPT_HOST/arch-linux/pre-config.sh"
chmod 700 /root/pre-config.sh

#echo "
#space delimited list of package names here.
#" > /root/extra-packages.txt
#
#echo "
#pkg-name;pkg-tarball-name;url_here
#" > /root/aur-packages.txt
#
#echo "
##! /usr/bin/env bash
#commands here
#" > /root/additional_commands.sh

# token is a 'user:token' auth token for jenkins.
/root/pre-config.sh ${hostname} ${disk_name} ${token} 2>&1 | tee /root/output.txt
