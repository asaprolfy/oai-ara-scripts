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

#if [[ ! -f "$log_file" ]]; then
#  touch "$log_file"
#  chmod 744 "$log_file"
#fi

if [[ -f "$log_file" ]]; then
  rm "$log_file"
elif [[ -d "$log_file" ]]; then
  rm -r "$log_file"
fi

if [[ -z "$2" ]]; then
  conf_file="/root/openairinterface5g/targets/PROJECTS/GENERIC-NR-5GC/CONF/gnb.sa.band78.fr1.106PRB.usrpb210.conf"
else
  conf_file="$2"
fi

uhd_find_devices

cd /root/openairinterface5g || exit
source oaienv
cd cmake_targets/ran_build/build || exit

./nr-softmodem -O "$conf_file" --gNBs.[0].min_rxtxtime 6 --sa -E --continuous-tx \
               > "$log_file" 2>&1 &

echo "gnb process begun"
exit 0