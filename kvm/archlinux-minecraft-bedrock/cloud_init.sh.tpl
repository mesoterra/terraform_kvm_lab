#!/usr/bin/bash

BASE_DOMAIN="domain.tld"
sleep 10
curl -s -o /root/pre-config.sh "http://scripts.$BASE_DOMAIN/arch-linux/pre-config.sh"
chmod 700 /root/pre-config.sh

echo "zip unzip" > /root/extra-packages.txt

echo "minecraft-bedrock-server;minecraft-bedrock-server.tar.gz;https://aur.archlinux.org/cgit/aur.git/snapshot/minecraft-bedrock-server.tar.gz" > /root/aur-packages.txt

echo "#! /usr/bin/env bash
sed -i 's/^server-name=.*$/server-name=Bedrock Minecraft/g; s/^difficulty=.*$/difficulty=peaceful/g; s/^allow-list=.*$/allow-list=true/g' /opt/minecraft-bedrock-server/server.properties
systemctl enable minecraft-bedrock-server
touch /opt/minecraft-bedrock-server/allowlist.json
echo '[
  {
    \"xuid\":\"NUMBERHERE\",
    \"name\":\"USERNAMEHERE\"
  }
]' > /opt/minecraft-bedrock-server/allowlist.json
systemctl start minecraft-bedrock-server" > /root/additional_commands.sh

# token is a jenkins 'username:token' value.
/root/pre-config.sh ${hostname} ${disk_name} ${token}
