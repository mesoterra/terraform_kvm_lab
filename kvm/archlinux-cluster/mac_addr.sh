#!/usr/bin/env bash

hostname="$(cat | tr -d '{"}' | awk -F':' '{print $2}')"

mac_addr="$(echo $hostname|md5sum|sed 's/^\(..\)\(..\)\(..\)\(..\)\(..\).*$/02:\1:\2:\3:\4:\5/')"

echo "{\"mac_addr\":\"$mac_addr\"}"
