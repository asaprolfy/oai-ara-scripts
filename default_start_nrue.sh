#!/bin/bash

### check for privileged execution ###
if [[ $(/usr/bin/id -u) -ne 0 ]]; then
    echo "Not running as root"
    exit 1
fi

if [[ -z "$1" ]]; then
  log_file="./nrue_log.txt"
else
  log_file="$1"
fi

if [[ -f "$log_file" ]]; then
  rm "$log_file"
elif [[ -d "$log_file" ]]; then
  rm -r "$log_file"
fi

if [[ ! -f "$log_file" ]]; then
  touch "$log_file"
  chmod 744 "$log_file"
fi

if [[ -z "$2" ]]; then
  nrue_conf_file="/root/openairinterface5g/targets/PROJECTS/GENERIC-NR-5GC/CONF/ue.conf"
else
  nrue_conf_file="$2"
fi

uhd_find_devices

#cd /root/openairinterface5g || exit && \
#source oaienv && \
#cd cmake_targets/ran_build/build || exit && \
#./nr-uesoftmodem -O "$nrue_conf_file" -r 106 --numerology 1 --band 78 -C 3604800000 --ue-fo-compensation \
#                 --sa -E --ue-txgain 0 --usrp-args "serial=8000170" --nokrnmod 1 \
#                 > "$log_file" &

source araenv && \
cd ~/openairinterface5g || exit && \
cd cmake_targets/ran_build/build || exit && \
./nr-uesoftmodem -O "$nrue_conf_file" -r 106 --numerology 1 --band 78 -C 3604800000 --ue-fo-compensation \
                 --sa -E --ue-txgain 0 --usrp-args "serial=8000170" --nokrnmod 1 \
                 >> "$log_file" &

echo "nrue process begun"
exit 0