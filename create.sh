#/bin/bash

if [ $# -lt 3 ]; then
  echo "usage: $0 disk_name disk_path disk_size"
  exit 0
fi

cmd="targetcli"

name=$1
path=$2
size=$3

ret=`${cmd} "/backstores/fileio/ create name=${name} file_or_dev=${path} size=${size}"`
wwn=`${cmd} "/loopback/ create " |awk '{print $NF}'|head -c 20`
ret=`${cmd} "/loopback/${wwn}/luns create /backstores/fileio/${name}"`
ret=`${cmd} "/loopback/${wwn}/luns/lun0 ls"`


serial=`cat /sys/kernel/config/target/loopback/${wwn}/tpgt_1/lun/lun_0/*/wwn/vpd_unit_serial|awk '{print $NF}'`
echo ${wwn} ${serial}
