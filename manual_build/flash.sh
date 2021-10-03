#!/bin/bash

# BEGIN PARAMETER ZONE
SD_DEV=/dev/mmcblk0
SD_P1=${SD_DEV}p1
SD_P2=${SD_DEV}p2
# END PARAMETER ZONE


DIRECTORY=$(pwd)

# Check if we're root and re-execute if we're not.
rootcheck () {
    if [ $(id -u) != "0" ]
    then
        sudo "$0" "$@"
        exit $?
    fi
}

if [ $# -ne 1 ] ; then
    echo "usage: ./flash.sh <v>"
    exit 1
fi

if [ ! -b ${SD_DEV} ] ; then
    echo "Dev ${SD_DEV} not found"
    exit 1
fi

rootcheck "${@}"

echo "Unmounting P1 and P2"
umount ${SD_P1} 2> /dev/null
umount ${SD_P2} 2> /dev/null

echo "Flashing"
if [ -f ../releases/adam_v${1}.img.gz ] ; then
    gunzip ../releases/adam_v${1}.img.gz -c | dd of=${SD_DEV} bs=2M status=progress conv=fsync
else
    xzcat ../releases/adam_v${1}.img.xz | dd of=${SD_DEV} bs=2M status=progress conv=fsync
fi
sync
sleep 2

echo "Remounting P1 and P2"
mkdir ${DIRECTORY}/mnt_p1
mount -t vfat ${SD_P1} ${DIRECTORY}/mnt_p1
mkdir ${DIRECTORY}/mnt_p2
mount -t ext4 ${SD_P2} ${DIRECTORY}/mnt_p2
sync
sleep 1

echo "Installing RG280V kernel"
cp ${DIRECTORY}/mnt_p1/rg280v/* ${DIRECTORY}/mnt_p1
sync

echo "Erasing .resize_me and changing shadow"
if [ -f ${DIRECTORY}/mnt_p2/.resize_me ] ; then
    rm ${DIRECTORY}/mnt_p2/.resize_me
fi
cp ${DIRECTORY}/shadow_without_pwd ${DIRECTORY}/mnt_p2/local/etc/shadow
chown 0:0 ${DIRECTORY}/mnt_p2/local/etc/shadow
chmod 600 ${DIRECTORY}/mnt_p2/local/etc/shadow
sync
sleep 1

echo "Final unmount"
umount ${SD_P1}
umount ${SD_P2}
rmdir ${DIRECTORY}/mnt_p1
rmdir ${DIRECTORY}/mnt_p2
