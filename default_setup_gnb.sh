#!/bin/bash

### check for privileged execution ###
if [[ $(/usr/bin/id -u) -ne 0 ]]; then
    echo "Not running as root"
    exit 1
fi

gnb_ip_addr=$(ip -4 addr show eth0 | grep -oP "(?<=inet ).*(?=/)")

if [[ -z "$1" ]]; then
  echo "CN ip address not provided"
  exit 1
else
  cn_ip_addr="$1"
fi

if [[ -z "$2" ]]; then
  gnb_conf_file="/root/openairinterface5g/targets/PROJECTS/GENERIC-NR-5GC/CONF/gnb.sa.band78.fr1.106PRB.usrpb210.conf"
else
  gnb_conf_file="$2"
fi

sed '\s^GNB_IPV4_ADDRESS_FOR_NG_AMF +=\s+"\b(?:(?:2(?:[0-4][0-9]|5[0-5])|[0-1]?[0-9]?[0-9])\.){3}(?:(?:2([0-4][0-9]|5[0-5])|[0-1]?[0-9]?[0-9]))\b/[0-9]+";$/          GNB_IPV4_ADDRESS_FOR_NG_AMF         = "'+"$gnb_ip_addr"+'\/24";/' "$gnb_conf_file"
sed '\s^GNB_IPV4_ADDRESS_FOR_NGU +=\s+"\b(?:(?:2(?:[0-4][0-9]|5[0-5])|[0-1]?[0-9]?[0-9])\.){3}(?:(?:2([0-4][0-9]|5[0-5])|[0-1]?[0-9]?[0-9]))\b/[0-9]+";$/          GNB_IPV4_ADDRESS_FOR_NGU            = "'+"$gnb_ip_addr"+'\/24";/' "$gnb_conf_file"

ip route add 192.168.70.128/26 via "$cn_ip_addr" dev eth0

echo "gNB setup complete"
exit 0