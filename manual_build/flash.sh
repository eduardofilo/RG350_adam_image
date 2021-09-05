#!/bin/bash

# BEGIN PARAMETER ZONE
SD_DEV=/dev/mmcblk0
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

rootcheck "${@}"

echo "Unmounting P1 and P2"
umount ${SD_DEV}p* 2> /dev/null

echo "Flashing"
gunzip ../releases/adam_v${1}.img.gz -c | dd of=${SD_DEV} bs=2M status=progress conv=fsync
sync
sleep 2

echo "Remounting P1 and P2"
mkdir ${DIRECTORY}/mnt_p1
mount -t vfat ${SD_DEV}p1 ${DIRECTORY}/mnt_p1
mkdir ${DIRECTORY}/mnt_p2
mount -t ext4 ${SD_DEV}p2 ${DIRECTORY}/mnt_p2
sync
sleep 1

echo "Installing RG280V kernel"
cp ${DIRECTORY}/mnt_p1/rg280v/* ${DIRECTORY}/mnt_p1
sync

echo "Erasing .resize_me and changing shadow"
rm ${DIRECTORY}/mnt_p2/.resize_me
cp ${DIRECTORY}/shadow_without_pwd ${DIRECTORY}/mnt_p2/local/etc/shadow
chown 0:0 ${DIRECTORY}/mnt_p2/local/etc/shadow
chmod 600 ${DIRECTORY}/mnt_p2/local/etc/shadow
sync
sleep 1

echo "Final unmount"
umount ${SD_DEV}p*
rmdir ${DIRECTORY}/mnt_p1
rmdir ${DIRECTORY}/mnt_p2
