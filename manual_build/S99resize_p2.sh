#!/bin/sh

set +e

if [ -f /media/data/.resize_me ] ; then
    DEVICE=mmcblk0
    PART_NUM=2

    DEVICE_SIZE=`cat /sys/block/${DEVICE}/size`
    START=`partx /dev/${DEVICE} -n ${PART_NUM} -g -o start`
    SIZE=$((${DEVICE_SIZE} - ${START}))
    
    rm /media/data/.resize_me
    sync
    /bin/umount /dev/${DEVICE}p${PART_NUM}
    (echo d
    echo 2
    echo n
    echo
    echo
    echo
    echo
    echo w
    ) | fdisk /dev/${DEVICE}
    /usr/sbin/e2fsck -f -y /dev/${DEVICE}p${PART_NUM}
    /usr/sbin/partx -u /dev/${DEVICE}
    /usr/sbin/resizepart /dev/${DEVICE} ${PART_NUM} ${SIZE}
    /usr/sbin/resize2fs -p /dev/${DEVICE}p${PART_NUM}
    /bin/umount /dev/${DEVICE}p${PART_NUM}
    /usr/sbin/e2fsck -f -y /dev/${DEVICE}p${PART_NUM}
    /bin/mount /dev/${DEVICE}p${PART_NUM} -o nosuid,nodev /media/data
    sync
fi
exit 0
