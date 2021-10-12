#!/bin/bash

# BEGIN PARAMETER ZONE
SD_DEV=/dev/mmcblk0
SD_P1=${SD_DEV}p1
SD_P2=${SD_DEV}p2
ODBETA_VERSION=2021-10-03
INSTALL_ODBETA_MODS=false
ZERO_FILL=true
MAKE_PGv1=true
COMP=xz     # gz or xz
# END PARAMETER ZONE


DIRECTORY=$(pwd)
ODBETA_DIST_FILE=gcw0-update-${ODBETA_VERSION}.opk
ODBETA_BASE_URL=http://od.abstraction.se/opendingux/latest

# Check if we're root and re-execute if we're not.
rootcheck () {
    if [ $(id -u) != "0" ]
    then
        sudo "$0" "$@"
        if [ ${MAKE_PGv1} = true ] ; then
            sudo chown $(id -u):$(id -g) ${DIRECTORY}/../releases/adam_v${1}_PGv1.img.${COMP}
        fi
        sudo chown $(id -u):$(id -g) ${DIRECTORY}/../releases/adam_v${1}.img.${COMP}
        exit $?
    fi
}

if [ $# -ne 1 ] ; then
    echo -e "usage: ./build.sh <v>\n  <v>: version; e.g. 1.1"
    exit 1
fi

rootcheck "${@}"

cd ${DIRECTORY}

echo "## Unmounting P1 and P2"
umount ${SD_P1} 2> /dev/null
umount ${SD_P2} 2> /dev/null
sleep 1

echo "## Checking and fixing P2"
e2fsck -f -y ${SD_P2} > /dev/null

echo "## Remounting P1 and P2"
mkdir ${DIRECTORY}/mnt_p1
mount -t vfat ${SD_P1} ${DIRECTORY}/mnt_p1
mkdir ${DIRECTORY}/mnt_p2
mount -t ext4 ${SD_P2} ${DIRECTORY}/mnt_p2
sleep 1

echo "## P1 cleaning"
rm ${DIRECTORY}/mnt_p1/modules.squashfs.bak 2> /dev/null
rm ${DIRECTORY}/mnt_p1/rootfs.squashfs.bak 2> /dev/null
rm ${DIRECTORY}/mnt_p1/rootfs.squashfs.bak.sha1 2> /dev/null
rm ${DIRECTORY}/mnt_p1/uzImage.bak 2> /dev/null
rm ${DIRECTORY}/mnt_p1/uzImage.bak.sha1 2> /dev/null
rm ${DIRECTORY}/mnt_p1/uzImage.bin 2> /dev/null
rm ${DIRECTORY}/mnt_p1/uzImage.bin.sha1 2> /dev/null
rm -rf ${DIRECTORY}/mnt_p1/.Trash* 2> /dev/null
rm -rf ${DIRECTORY}/mnt_p1/System\ Volume\ Information 2> /dev/null
rm -rf ${DIRECTORY}/mnt_p1/rg280m 2> /dev/null && sync
rm -rf ${DIRECTORY}/mnt_p1/rg280v 2> /dev/null && sync
rm -rf ${DIRECTORY}/mnt_p1/rg350 2> /dev/null && sync
rm -rf ${DIRECTORY}/mnt_p1/rg350m 2> /dev/null && sync
rm -rf ${DIRECTORY}/mnt_p1/pocketgo2v2 2> /dev/null && sync
rm -rf ${DIRECTORY}/mnt_p1/rg300x 2> /dev/null && sync
rm ${DIRECTORY}/mnt_p1/select_kernel.bat 2> /dev/null && sync
rm ${DIRECTORY}/mnt_p1/select_kernel.sh 2> /dev/null && sync

echo "## P2 cleaning"
rm ${DIRECTORY}/mnt_p2/local/home/screenshots/* 2> /dev/null
rm ${DIRECTORY}/mnt_p2/local/home/.ash_history 2> /dev/null
rm ${DIRECTORY}/mnt_p2/local/home/.python_history 2> /dev/null
rm -rf ${DIRECTORY}/mnt_p2/local/home/.cache 2> /dev/null
rm ${DIRECTORY}/mnt_p2/local/home/.gmenu2x/sections/applications/RA_* 2> /dev/null
rm ${DIRECTORY}/mnt_p2/local/home/.gmenu2x/sections/applications/gcw0-update* 2> /dev/null
rm -rf ${DIRECTORY}/mnt_p2/local/home/.retroarch/autoconfig 2> /dev/null
rm -rf ${DIRECTORY}/mnt_p2/local/home/.retroarch/downloads 2> /dev/null
rm -rf ${DIRECTORY}/mnt_p2/local/home/.retroarch/logs 2> /dev/null
rm -rf ${DIRECTORY}/mnt_p2/local/home/.retroarch/overlay 2> /dev/null
rm -rf ${DIRECTORY}/mnt_p2/local/home/.retroarch/playlists 2> /dev/null
rm -rf ${DIRECTORY}/mnt_p2/local/home/.retroarch/records 2> /dev/null
rm -rf ${DIRECTORY}/mnt_p2/local/home/.retroarch/records_config 2> /dev/null
rm -rf ${DIRECTORY}/mnt_p2/local/home/.retroarch/saves 2> /dev/null
mkdir ${DIRECTORY}/mnt_p2/local/home/.retroarch/saves
chown 1000:100 ${DIRECTORY}/mnt_p2/local/home/.retroarch/saves
rm -rf ${DIRECTORY}/mnt_p2/local/home/.retroarch/screenshots 2> /dev/null
rm -rf ${DIRECTORY}/mnt_p2/local/home/.retroarch/shaders 2> /dev/null
rm -rf ${DIRECTORY}/mnt_p2/local/home/.retroarch/states 2> /dev/null
rm -rf ${DIRECTORY}/mnt_p2/local/home/.retroarch/thumbnails 2> /dev/null
rm ${DIRECTORY}/mnt_p2/local/home/.retroarch/*.lpl 2> /dev/null
rm ${DIRECTORY}/mnt_p2/local/home/.gpsp/*.sav 2> /dev/null
rm ${DIRECTORY}/mnt_p2/local/home/.vbemu/sram/* 2> /dev/null
rm ${DIRECTORY}/mnt_p2/local/share/xmame/xmame84/nvram/* 2> /dev/null
rm ${DIRECTORY}/mnt_p2/local/share/xmame/xmame69/nvram/* 2> /dev/null
rm ${DIRECTORY}/mnt_p2/local/share/xmame/xmame52/nvram/* 2> /dev/null
rm ${DIRECTORY}/mnt_p2/local/share/xmame/xmame52/nvram/* 2> /dev/null
rm ${DIRECTORY}/mnt_p2/local/share/xmame/sm_bridge/*.pyc 2> /dev/null
rm -rf ${DIRECTORY}/mnt_p2/local/home/.sm64-port 2> /dev/null
rm -rf ${DIRECTORY}/mnt_p2/local/home/.simplemenu/rom_preferences/* 2> /dev/null
rm -rf ${DIRECTORY}/mnt_p2/lost+found 2> /dev/null
rm ${DIRECTORY}/mnt_p2/local/home/.fba/configs/* 2> /dev/null
rm ${DIRECTORY}/mnt_p2/local/home/.scummvmrc 2> /dev/null
rm ${DIRECTORY}/mnt_p2/local/home/.local/share/scummvm/saves/* 2> /dev/null

echo "## Putting up version file flag"
echo ${1} > ${DIRECTORY}/mnt_p2/adam_version.txt

echo "## Installing directory scaffolding script"
cp ${DIRECTORY}/S01_create_ext_scaffolding.sh ${DIRECTORY}/mnt_p2/local/etc/init.d
chown 0:0 ${DIRECTORY}/mnt_p2/local/etc/shadow

echo "## Installing Py Backup config"
cp ${DIRECTORY}/config.ini ${DIRECTORY}/mnt_p2/local/home/.py_backup/
chown 1000:100 ${DIRECTORY}/mnt_p2/local/home/.py_backup/config.ini

echo "## Installing SimpleMenu alias"
cp ${DIRECTORY}/alias.txt ${DIRECTORY}/mnt_p2/local/home/.simplemenu/
chown 1000:100 ${DIRECTORY}/mnt_p2/local/home/.simplemenu/alias.txt

echo "## Settings etc files"
cp ${DIRECTORY}/shadow_with_pwd ${DIRECTORY}/mnt_p2/local/etc/shadow
chown 0:0 ${DIRECTORY}/mnt_p2/local/etc/shadow
chmod 600 ${DIRECTORY}/mnt_p2/local/etc/shadow
cp ${DIRECTORY}/brightness.state ${DIRECTORY}/mnt_p2/local/etc/
chown 0:0 ${DIRECTORY}/mnt_p2/local/etc/brightness.state
chmod 644 ${DIRECTORY}/mnt_p2/local/etc/brightness.state
cp ${DIRECTORY}/usb.conf ${DIRECTORY}/mnt_p2/local/etc/
chown 0:0 ${DIRECTORY}/mnt_p2/local/etc/usb.conf
chmod 644 ${DIRECTORY}/mnt_p2/local/etc/usb.conf
cp ${DIRECTORY}/volume.state ${DIRECTORY}/mnt_p2/local/etc/
chown 0:0 ${DIRECTORY}/mnt_p2/local/etc/volume.state
chmod 755 ${DIRECTORY}/mnt_p2/local/etc/volume.state

echo "## Setting up first boot"
if [ ${INSTALL_ODBETA_MODS} = true ] ; then
    touch ${DIRECTORY}/mnt_p2/.resize_me
fi
cp ${DIRECTORY}/.autostart ${DIRECTORY}/mnt_p2/local/home/
chown 1000:100 ${DIRECTORY}/mnt_p2/local/home/.autostart
cp ${DIRECTORY}/last_state.sav ${DIRECTORY}/mnt_p2/local/home/.simplemenu
chown 1000:100 ${DIRECTORY}/mnt_p2/local/home/.simplemenu/last_state.sav
sync
sleep 1

echo "## Unmounting P2"
umount ${SD_P2}
sleep 1

if [ ${ZERO_FILL} = true ] ; then
    echo "## Filling P2 with 0xFF"
    zerofree -v -f 0xFF ${SD_P2}
fi

if [ ! -f ${DIRECTORY}/select_kernel/${ODBETA_DIST_FILE} ] ; then
    echo "## Downloading ODBeta distribution"
    ODBETA_DIST_URL=${ODBETA_BASE_URL}/${ODBETA_DIST_FILE}
    wget -q -P ${DIRECTORY}/select_kernel ${ODBETA_DIST_URL}
    status=$?
    [ ! ${status} -eq 0 ] && echo "@@ ERROR: Problem downloading ODBeta distribution" && exit 1
fi
if [ -d ${DIRECTORY}/select_kernel/squashfs-root ] ; then
    rm -rf ${DIRECTORY}/select_kernel/squashfs-root
fi
cd ${DIRECTORY}/select_kernel
unsquashfs ${DIRECTORY}/select_kernel/${ODBETA_DIST_FILE} > /dev/null

if [ ${INSTALL_ODBETA_MODS} = true ] ; then
    echo "## Installing script S99resize_p2.sh in rootfs.squashfs"
    cd ${DIRECTORY}/select_kernel/squashfs-root/gcw0
    unsquashfs rootfs.squashfs > /dev/null
    cp ${DIRECTORY}/S99resize_p2.sh ${DIRECTORY}/select_kernel/squashfs-root/gcw0/squashfs-root/etc/init.d
    mksquashfs squashfs-root rootfs.squashfs -noappend -comp zstd > /dev/null
fi

cd ${DIRECTORY}

cp ${DIRECTORY}/select_kernel/squashfs-root/gcw0/rootfs.squashfs ${DIRECTORY}/mnt_p1
cp ${DIRECTORY}/select_kernel/squashfs-root/gcw0/mininit-syspart ${DIRECTORY}/mnt_p1
cp ${DIRECTORY}/select_kernel/squashfs-root/gcw0/mininit-syspart.sha1 ${DIRECTORY}/mnt_p1
cp ${DIRECTORY}/select_kernel/squashfs-root/gcw0/modules.squashfs ${DIRECTORY}/mnt_p1
cp ${DIRECTORY}/select_kernel/squashfs-root/gcw0/modules.squashfs.sha1 ${DIRECTORY}/mnt_p1

if [ ${MAKE_PGv1} = true ] ; then
    echo "## Building P1 for PlayGo/PG2 v1 image"
    cat ${DIRECTORY}/select_kernel/squashfs-root/gcw0/uzImage.bin ${DIRECTORY}/select_kernel/squashfs-root/gcw0/pocketgo2.dtb > ${DIRECTORY}/mnt_p1/uzImage.bin
    sha1sum ${DIRECTORY}/mnt_p1/uzImage.bin | awk '{ print $1 }' > ${DIRECTORY}/mnt_p1/uzImage.bin.sha1

    if [ ${ZERO_FILL} = true ] ; then
        echo "## Filling P1 with zeros"
        dd if=/dev/zero of=${DIRECTORY}/mnt_p1/zero.txt status=progress 2> /dev/null && sync
        rm ${DIRECTORY}/mnt_p1/zero.txt && sync
    fi

    echo "## Unmounting P1"
    umount ${SD_P1}

    echo "## Flashing bootloader for PlayGo/PG2 v1 image"
    dd if=${DIRECTORY}/select_kernel/squashfs-root/gcw0/ubiboot-v20_mddr_512mb.bin of=${SD_DEV} bs=512 seek=1 count=16 conv=notrunc 2>/dev/null
    sync
    sleep 1

    echo "## Making card dump for PlayGo/PG2 v1 image"
    if [ ${COMP} = "gz" ] ; then
        dd if=${SD_DEV} bs=2M count=1600 status=progress | gzip -9 - > ${DIRECTORY}/../releases/adam_v${1}_PGv1.img.gz
    else
        dd if=${SD_DEV} bs=2M count=1600 status=progress | xz -z -f -9 > ${DIRECTORY}/../releases/adam_v${1}_PGv1.img.xz
    fi
    sync

    echo "## Remounting P1"
    mount -t vfat ${SD_P1} ${DIRECTORY}/mnt_p1
    sleep 1
fi

echo "## Building P1 for main image"
rm ${DIRECTORY}/mnt_p1/uzImage.bin 2> /dev/null
rm ${DIRECTORY}/mnt_p1/uzImage.bin.sha1 2> /dev/null
cp ${DIRECTORY}/select_kernel/select_kernel.bat ${DIRECTORY}/mnt_p1
cp ${DIRECTORY}/select_kernel/select_kernel.sh ${DIRECTORY}/mnt_p1
mkdir ${DIRECTORY}/mnt_p1/rg280m
mkdir ${DIRECTORY}/mnt_p1/rg280v
mkdir ${DIRECTORY}/mnt_p1/rg350
mkdir ${DIRECTORY}/mnt_p1/rg350m
mkdir ${DIRECTORY}/mnt_p1/pocketgo2v2
mkdir ${DIRECTORY}/mnt_p1/rg300x
cat ${DIRECTORY}/select_kernel/squashfs-root/gcw0/uzImage.bin ${DIRECTORY}/select_kernel/squashfs-root/gcw0/rg280m.dtb > ${DIRECTORY}/mnt_p1/rg280m/uzImage.bin
sha1sum ${DIRECTORY}/mnt_p1/rg280m/uzImage.bin | awk '{ print $1 }'>${DIRECTORY}/mnt_p1/rg280m/uzImage.bin.sha1
cat ${DIRECTORY}/select_kernel/squashfs-root/gcw0/uzImage.bin ${DIRECTORY}/select_kernel/squashfs-root/gcw0/rg280v.dtb > ${DIRECTORY}/mnt_p1/rg280v/uzImage.bin
sha1sum ${DIRECTORY}/mnt_p1/rg280v/uzImage.bin | awk '{ print $1 }'>${DIRECTORY}/mnt_p1/rg280v/uzImage.bin.sha1
cat ${DIRECTORY}/select_kernel/squashfs-root/gcw0/uzImage.bin ${DIRECTORY}/select_kernel/squashfs-root/gcw0/rg350.dtb > ${DIRECTORY}/mnt_p1/rg350/uzImage.bin
sha1sum ${DIRECTORY}/mnt_p1/rg350/uzImage.bin | awk '{ print $1 }'>${DIRECTORY}/mnt_p1/rg350/uzImage.bin.sha1
cat ${DIRECTORY}/select_kernel/squashfs-root/gcw0/uzImage.bin ${DIRECTORY}/select_kernel/squashfs-root/gcw0/rg350m.dtb > ${DIRECTORY}/mnt_p1/rg350m/uzImage.bin
sha1sum ${DIRECTORY}/mnt_p1/rg350m/uzImage.bin | awk '{ print $1 }'>${DIRECTORY}/mnt_p1/rg350m/uzImage.bin.sha1
cat ${DIRECTORY}/select_kernel/squashfs-root/gcw0/uzImage.bin ${DIRECTORY}/select_kernel/squashfs-root/gcw0/pocketgo2v2.dtb > ${DIRECTORY}/mnt_p1/pocketgo2v2/uzImage.bin
sha1sum ${DIRECTORY}/mnt_p1/pocketgo2v2/uzImage.bin | awk '{ print $1 }'>${DIRECTORY}/mnt_p1/pocketgo2v2/uzImage.bin.sha1
cat ${DIRECTORY}/select_kernel/squashfs-root/gcw0/uzImage.bin ${DIRECTORY}/select_kernel/squashfs-root/gcw0/rg300x.dtb > ${DIRECTORY}/mnt_p1/rg300x/uzImage.bin
sha1sum ${DIRECTORY}/mnt_p1/rg300x/uzImage.bin | awk '{ print $1 }'>${DIRECTORY}/mnt_p1/rg300x/uzImage.bin.sha1

if [ ${ZERO_FILL} = true ] ; then
    echo "## Filling P1 with zeros"
    dd if=/dev/zero of=${DIRECTORY}/mnt_p1/zero.txt status=progress 2> /dev/null && sync
    rm ${DIRECTORY}/mnt_p1/zero.txt && sync
fi

echo "## Unmounting P1"
umount ${SD_P1}
sleep 1

echo "## Flashing bootloader for main image"
dd if=${DIRECTORY}/select_kernel/squashfs-root/gcw0/ubiboot-rg350.bin of=${SD_DEV} bs=512 seek=1 count=16 conv=notrunc 2>/dev/null
sync
sleep 1

echo "## Making card dump for main image"
if [ ${COMP} = "gz" ] ; then
    dd if=${SD_DEV} bs=2M count=1600 status=progress | gzip -9 - > ${DIRECTORY}/../releases/adam_v${1}.img.gz
else
    dd if=${SD_DEV} bs=2M count=1600 status=progress | xz -z -f -9 > ${DIRECTORY}/../releases/adam_v${1}.img.xz
fi

rm -rf ${DIRECTORY}/select_kernel/squashfs-root

echo "## Remounting P1 and P2"
mount -t vfat ${SD_P1} ${DIRECTORY}/mnt_p1
mount -t ext4 ${SD_P2} ${DIRECTORY}/mnt_p2
sleep 1

echo "## Installing RG280V kernel"
cp ${DIRECTORY}/mnt_p1/rg280v/* ${DIRECTORY}/mnt_p1
sync

echo "## Erasing .resize_me and changing shadow"
rm ${DIRECTORY}/mnt_p2/.resize_me 2> /dev/null
cp ${DIRECTORY}/shadow_without_pwd ${DIRECTORY}/mnt_p2/local/etc/shadow
chown 0:0 ${DIRECTORY}/mnt_p2/local/etc/shadow
chmod 600 ${DIRECTORY}/mnt_p2/local/etc/shadow
sync
sleep 1

echo "## Final unmount"
umount ${SD_P1}
umount ${SD_P2}
rmdir ${DIRECTORY}/mnt_p1
rmdir ${DIRECTORY}/mnt_p2
