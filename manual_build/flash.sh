#!/bin/bash

if [ $# -ne 1 ] ; then
    echo "usage: ./flash.sh <v>"
    exit 1
fi

echo "Flashing"
sudo umount /dev/mmcblk0p*
gunzip ../releases/adan_v${1}.img.gz -c | sudo dd of=/dev/mmcblk0 bs=2M status=progress conv=fsync
sudo sync
sleep 2

echo "Installing RG280V kernel"
mkdir temp_mnt
sudo mount -t vfat /dev/mmcblk0p1 temp_mnt
sync
sleep 1
sudo cp temp_mnt/rg280v/* temp_mnt
sudo sync
sleep 1
sudo umount /dev/mmcblk0p1
sudo sync
sleep 1

echo "Erasing .resize_me and changing shadow"
sudo mount -t ext4 /dev/mmcblk0p2 temp_mnt
sync
sleep 1
sudo rm temp_mnt/.resize_me
sudo cp shadow_without_pwd temp_mnt/local/etc/shadow
sudo chown 0:0 temp_mnt/local/etc/shadow
sudo chmod 600 temp_mnt/local/etc/shadow
sudo sync
sleep 1
sudo umount /dev/mmcblk0p2
sudo sync
sleep 1
rmdir temp_mnt
