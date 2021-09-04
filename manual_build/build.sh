#!/bin/bash

# BEGIN PARAMETER ZONE
P1_MOUNTING_POINT=/media/edumoreno/E556-AAD5
P2_MOUNTING_POINT=/media/edumoreno/07ce62be-aa5c-7740-9129-de5763f111e0
ODBETA_VERSION=2021-08-25
ZERO_FILL=true
INSTALL_ODBETA_MODS=true
# END PARAMETER ZONE


DIRECTORY=$(pwd)
ODBETA_DIST_FILE=gcw0-update-${ODBETA_VERSION}.opk
ODBETA_BASE_URL=http://od.abstraction.se/opendingux/latest


if [ $# -ne 1 ] ; then
    echo -e "usage: ./build.sh <v>\n  <v>: version; e.g. 1.1"
    exit 1
fi

if [ ! -d ${P1_MOUNTING_POINT} ] ; then
    echo -e "P1 must be mounted in ${P1_MOUNTING_POINT} and not detected, so exiting."
    exit 1
fi

if [ ! -d ${P2_MOUNTING_POINT} ] ; then
    echo -e "P2 must be mounted in ${P2_MOUNTING_POINT} and not detected, so exiting."
    exit 1
fi

if [ ${INSTALL_ODBETA_MODS} = true ] ; then
    if [ ! -f ${DIRECTORY}/select_kernel/${ODBETA_DIST_FILE} ] ; then
        echo "Downloading ODBeta distribution"
        ODBETA_DIST_URL=${ODBETA_BASE_URL}/${ODBETA_DIST_FILE}
        wget -q -P ${DIRECTORY}/select_kernel ${ODBETA_DIST_URL}
        status=$?
        [ ! ${status} -eq 0 ] && echo "@@ ERROR: Problem downloading ODBeta distribution"
    fi
    if [ -d ${DIRECTORY}/select_kernel/squashfs-root ] ; then
        sudo rm -rf ${DIRECTORY}/select_kernel/squashfs-root
    fi
    echo "Installing script S99resize_p2.sh in rootfs.squashfs"
    cd ${DIRECTORY}/select_kernel
    unsquashfs ${DIRECTORY}/select_kernel/${ODBETA_DIST_FILE} > /dev/null
    cd ${DIRECTORY}/select_kernel/squashfs-root/gcw0
    sudo unsquashfs rootfs.squashfs > /dev/null
    sudo cp ${DIRECTORY}/S99resize_p2.sh ${DIRECTORY}/select_kernel/squashfs-root/gcw0/squashfs-root/etc/init.d
    sudo mksquashfs squashfs-root rootfs.squashfs -noappend -comp zstd > /dev/null
    cp rootfs.squashfs ${P1_MOUNTING_POINT}
    cp mininit-syspart ${P1_MOUNTING_POINT}
    cp mininit-syspart.sha1 ${P1_MOUNTING_POINT}
    cp modules.squashfs ${P1_MOUNTING_POINT}
    cp modules.squashfs.sha1 ${P1_MOUNTING_POINT}
    cp ${DIRECTORY}/select_kernel/select_kernel.bat ${P1_MOUNTING_POINT}
    cp ${DIRECTORY}/select_kernel/select_kernel.sh ${P1_MOUNTING_POINT}

    echo "Generating kernels"
    cat uzImage.bin rg280m.dtb > ${P1_MOUNTING_POINT}/rg280m/uzImage.bin && sha1sum ${P1_MOUNTING_POINT}/rg280m/uzImage.bin | awk '{ print $1 }'>${P1_MOUNTING_POINT}/rg280m/uzImage.bin.sha1
    cat uzImage.bin rg280v.dtb > ${P1_MOUNTING_POINT}/rg280v/uzImage.bin && sha1sum ${P1_MOUNTING_POINT}/rg280v/uzImage.bin | awk '{ print $1 }'>${P1_MOUNTING_POINT}/rg280v/uzImage.bin.sha1
    cat uzImage.bin rg350.dtb > ${P1_MOUNTING_POINT}/rg350/uzImage.bin && sha1sum ${P1_MOUNTING_POINT}/rg350/uzImage.bin | awk '{ print $1 }'>${P1_MOUNTING_POINT}/rg350/uzImage.bin.sha1
    cat uzImage.bin rg350m.dtb > ${P1_MOUNTING_POINT}/rg350m/uzImage.bin && sha1sum ${P1_MOUNTING_POINT}/rg350m/uzImage.bin | awk '{ print $1 }'>${P1_MOUNTING_POINT}/rg350m/uzImage.bin.sha1
    cat uzImage.bin playgo.dtb > ${P1_MOUNTING_POINT}/playgo/uzImage.bin && sha1sum ${P1_MOUNTING_POINT}/playgo/uzImage.bin | awk '{ print $1 }'>${P1_MOUNTING_POINT}/playgo/uzImage.bin.sha1
    cat uzImage.bin rg300x.dtb > ${P1_MOUNTING_POINT}/rg300x/uzImage.bin && sha1sum ${P1_MOUNTING_POINT}/rg300x/uzImage.bin | awk '{ print $1 }'>${P1_MOUNTING_POINT}/rg300x/uzImage.bin.sha1

    sudo rm -rf ${DIRECTORY}/select_kernel/squashfs-root
fi

cd ${DIRECTORY}

echo "P1 cleaning"
rm ${P1_MOUNTING_POINT}/modules.squashfs.bak 2> /dev/null
rm ${P1_MOUNTING_POINT}/rootfs.squashfs.bak 2> /dev/null
rm ${P1_MOUNTING_POINT}/rootfs.squashfs.bak.sha1 2> /dev/null
rm ${P1_MOUNTING_POINT}/uzImage.bak 2> /dev/null
rm ${P1_MOUNTING_POINT}/uzImage.bak.sha1 2> /dev/null
rm ${P1_MOUNTING_POINT}/uzImage.bin 2> /dev/null
rm ${P1_MOUNTING_POINT}/uzImage.bin.sha1 2> /dev/null
rm -rf ${P1_MOUNTING_POINT}/.Trash* 2> /dev/null
rm -rf ${P1_MOUNTING_POINT}/System\ Volume\ Information 2> /dev/null

echo "P2 cleaning"
sudo rm ${P2_MOUNTING_POINT}/local/home/screenshots/* 2> /dev/null
sudo rm ${P2_MOUNTING_POINT}/local/home/.ash_history 2> /dev/null
sudo rm ${P2_MOUNTING_POINT}/local/home/.python_history 2> /dev/null
sudo rm -rf ${P2_MOUNTING_POINT}/local/home/.cache 2> /dev/null
sudo rm ${P2_MOUNTING_POINT}/local/home/.gmenu2x/sections/applications/RA_* 2> /dev/null
sudo rm ${P2_MOUNTING_POINT}/local/home/.gmenu2x/sections/applications/gcw0-update* 2> /dev/null
sudo rm -rf ${P2_MOUNTING_POINT}/local/home/.retroarch/autoconfig 2> /dev/null
sudo rm -rf ${P2_MOUNTING_POINT}/local/home/.retroarch/downloads 2> /dev/null
sudo rm -rf ${P2_MOUNTING_POINT}/local/home/.retroarch/logs 2> /dev/null
sudo rm -rf ${P2_MOUNTING_POINT}/local/home/.retroarch/overlay 2> /dev/null
sudo rm -rf ${P2_MOUNTING_POINT}/local/home/.retroarch/playlists 2> /dev/null
sudo rm -rf ${P2_MOUNTING_POINT}/local/home/.retroarch/records 2> /dev/null
sudo rm -rf ${P2_MOUNTING_POINT}/local/home/.retroarch/records_config 2> /dev/null
sudo rm -rf ${P2_MOUNTING_POINT}/local/home/.retroarch/saves 2> /dev/null
sudo rm -rf ${P2_MOUNTING_POINT}/local/home/.retroarch/screenshots 2> /dev/null
sudo rm -rf ${P2_MOUNTING_POINT}/local/home/.retroarch/shaders 2> /dev/null
sudo rm -rf ${P2_MOUNTING_POINT}/local/home/.retroarch/states 2> /dev/null
sudo rm -rf ${P2_MOUNTING_POINT}/local/home/.retroarch/thumbnails 2> /dev/null
sudo rm ${P2_MOUNTING_POINT}/local/home/.retroarch/*.lpl 2> /dev/null
sudo rm ${P2_MOUNTING_POINT}/local/home/.gpsp/*.sav 2> /dev/null
sudo rm ${P2_MOUNTING_POINT}/local/home/.vbemu/sram/* 2> /dev/null
sudo rm ${P2_MOUNTING_POINT}/local/share/xmame/xmame84/nvram/* 2> /dev/null
sudo rm ${P2_MOUNTING_POINT}/local/share/xmame/xmame69/nvram/* 2> /dev/null
sudo rm ${P2_MOUNTING_POINT}/local/share/xmame/xmame52/nvram/* 2> /dev/null
sudo rm ${P2_MOUNTING_POINT}/local/share/xmame/xmame52/nvram/* 2> /dev/null
sudo rm ${P2_MOUNTING_POINT}/local/share/xmame/sm_bridge/*.pyc 2> /dev/null
sudo rm ${P2_MOUNTING_POINT}/local/home/.sm64-port/sm64_save_file.bin 2> /dev/null

echo "Putting up version file flag"
echo ${1} | sudo tee ${P2_MOUNTING_POINT}/adam_version.txt > /dev/null

echo "Changing shadow file"
sudo cp shadow_with_pwd ${P2_MOUNTING_POINT}/local/etc/shadow
sudo chown 0:0 ${P2_MOUNTING_POINT}/local/etc/shadow
sudo chmod 600 ${P2_MOUNTING_POINT}/local/etc/shadow

echo "Setting up first boot"
sudo touch ${P2_MOUNTING_POINT}/.resize_me
sudo cp .autostart ${P2_MOUNTING_POINT}/local/home/
sudo chown 1000:100 ${P2_MOUNTING_POINT}/local/home/.autostart
sudo cp last_state.sav ${P2_MOUNTING_POINT}/local/home/.simplemenu
sudo chown 1000:100 ${P2_MOUNTING_POINT}/local/home/.simplemenu/last_state.sav

if [ ${ZERO_FILL} = true ] ; then
    echo "Filling P1 with zeros"
    dd if=/dev/zero of=${P1_MOUNTING_POINT}/zero.txt status=progress 2> /dev/null && sudo sync
    rm ${P1_MOUNTING_POINT}/zero.txt && sudo sync
    echo "Filling P2 with zeros"
    sudo dd if=/dev/zero of=${P2_MOUNTING_POINT}/zero.txt status=progress 2> /dev/null && sudo sync
    sudo rm ${P2_MOUNTING_POINT}/zero.txt && sudo sync
fi

echo "Making card dump"
sudo umount /dev/mmcblk0p*
sudo dd if=/dev/mmcblk0 bs=2M count=1600 status=progress | gzip -9 - > ${DIRECTORY}/../releases/adan_v${1}.img.gz

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
