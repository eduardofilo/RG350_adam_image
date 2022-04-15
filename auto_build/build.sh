#!/bin/bash

# BEGIN PARAMETER ZONE
ODBETA_VERSION=2022-02-13
INSTALL_ODBETA_MODS=false
MAKE_PGv1=true
MAKE_RG=true
COMP=gz     # gz or xz
P1_SIZE_SECTOR=819168   # ~400M
SIZE_M=3200
# END PARAMETER ZONE

DIRECTORY=$(cd $(dirname "${BASH_SOURCE[0]}") && pwd)
ODBETA_DIST_FILE=gcw0-update-${ODBETA_VERSION}.opk
ODBETA_BASE_URL=http://od.abstraction.se/opendingux/latest
SECTOR_SIZE=512
P1_OFFSET_SECTOR=32


# Check if we're root and re-execute if we're not.
rootcheck () {
    if [ $(id -u) != "0" ]
    then
        sudo "$0" "$@"
        sudo chown -R $(id -u):$(id -g) ${DIRECTORY}/../releases
        sudo chown -R $(id -u):$(id -g) ${DIRECTORY}/../retroarch/build_odb
        sudo chown -R $(id -u):$(id -g) ${DIRECTORY}/../retroarch/releases
        exit $?
    fi
}

if [ $# -ne 1 ] ; then
    echo -e "usage: ./build.sh <v>\n  <v>: version; e.g. 1.1"
    exit 1
fi

rootcheck "${@}"

# Calculations
mega="$(echo '2^20' | bc)"
p1_start_sector=${P1_OFFSET_SECTOR}
p1_size_sector=${P1_SIZE_SECTOR}
p2_start_sector=$((${P1_OFFSET_SECTOR}+${P1_SIZE_SECTOR}))
img_size_sector=$((${SIZE_M}*${mega}/${SECTOR_SIZE}))
p2_size_sector=$((${img_size_sector}-${p2_start_sector}))

echo "## File creation"
dd if=/dev/zero of="${DIRECTORY}/sd_int.img" bs=1M count=${SIZE_M} status=progress conv=fsync
sync
sleep 1

echo "## Partition creation"
printf "
type=b, start=${p1_start_sector}, size=${p1_size_sector}
type=83, start=${p2_start_sector}, size=${p2_size_sector}
" | sfdisk -q "${DIRECTORY}/sd_int.img"
sync
sleep 1

echo "## Setting up loop device"
DEVICE=$(losetup -f)
losetup -P ${DEVICE} ${DIRECTORY}/sd_int.img
sleep 1

echo "## Creating filesystems"
mkfs.vfat -F 32 ${DEVICE}p1
mkfs.ext4 -F -O ^64bit -O ^metadata_csum -O uninit_bg -L '' -q ${DEVICE}p2
sync
sleep 1

echo "## Mounting P1"
mkdir ${DIRECTORY}/mnt_p1
mount -t vfat ${DEVICE}p1 ${DIRECTORY}/mnt_p1
sleep 1

if [ ! -f ${DIRECTORY}/../select_kernel/${ODBETA_DIST_FILE} ] ; then
    echo "## Downloading ODBeta distribution"
    ODBETA_DIST_URL=${ODBETA_BASE_URL}/${ODBETA_DIST_FILE}
    wget -q -P ${DIRECTORY}/../select_kernel ${ODBETA_DIST_URL}
    status=$?
    [ ! ${status} -eq 0 ] && echo "@@ ERROR: Problem downloading ODBeta distribution" && exit 1
fi
if [ -d ${DIRECTORY}/../select_kernel/squashfs-root ] ; then
    rm -rf ${DIRECTORY}/../select_kernel/squashfs-root
fi
cd ${DIRECTORY}/../select_kernel
unsquashfs ${DIRECTORY}/../select_kernel/${ODBETA_DIST_FILE} > /dev/null

if [ ${INSTALL_ODBETA_MODS} = true ] ; then
    echo "## Installing script S99resize_p2.sh in rootfs.squashfs"
    cd ${DIRECTORY}/../select_kernel/squashfs-root/gcw0
    unsquashfs rootfs.squashfs > /dev/null
    cp ${DIRECTORY}/../assets/S99resize_p2.sh ${DIRECTORY}/../select_kernel/squashfs-root/gcw0/squashfs-root/etc/init.d
    mksquashfs squashfs-root rootfs.squashfs -noappend -comp zstd > /dev/null
fi

cd ${DIRECTORY}

cp ${DIRECTORY}/../select_kernel/squashfs-root/gcw0/rootfs.squashfs ${DIRECTORY}/mnt_p1
sha1sum ${DIRECTORY}/../select_kernel/squashfs-root/gcw0/rootfs.squashfs | awk '{ print $1 }'>${DIRECTORY}/mnt_p1/rootfs.squashfs.sha1
cp ${DIRECTORY}/../select_kernel/squashfs-root/gcw0/mininit-syspart ${DIRECTORY}/mnt_p1
cp ${DIRECTORY}/../select_kernel/squashfs-root/gcw0/mininit-syspart.sha1 ${DIRECTORY}/mnt_p1
cp ${DIRECTORY}/../select_kernel/squashfs-root/gcw0/modules.squashfs ${DIRECTORY}/mnt_p1
cp ${DIRECTORY}/../select_kernel/squashfs-root/gcw0/modules.squashfs.sha1 ${DIRECTORY}/mnt_p1
mkdir ${DIRECTORY}/mnt_p1/dev
mkdir ${DIRECTORY}/mnt_p1/root

echo "## Mounting P2"
mkdir ${DIRECTORY}/mnt_p2
mount -t ext4 ${DEVICE}p2 ${DIRECTORY}/mnt_p2
sleep 1

echo "## Installing RetroArch stuff in P2"
E_BUILD_STOCK=false E_BUILD_ODBETA=true E_CONF_CSV=all ${DIRECTORY}/../retroarch/build.sh
mkdir -p ${DIRECTORY}/mnt_p2/apps
cp -f ${DIRECTORY}/../retroarch/files_odb/retroarch_rg350_odbeta.opk ${DIRECTORY}/mnt_p2/apps
mkdir -p ${DIRECTORY}/mnt_p2/local/bin
cp -f ${DIRECTORY}/../retroarch/files_odb/retroarch_rg350_odbeta ${DIRECTORY}/mnt_p2/local/bin
# Installing OPK wrappers for cores
tar -xzf ${DIRECTORY}/../retroarch/files_odb/apps_ra.tgz -C ${DIRECTORY}/mnt_p2/apps
# Installing home files
mkdir -p ${DIRECTORY}/mnt_p2/local/home/.retroarch
tar -xzf ${DIRECTORY}/../retroarch/files_odb/retroarch.tgz -C ${DIRECTORY}/mnt_p2/local/home/.retroarch
# Installing GMenu2X links
mkdir -p ${DIRECTORY}/mnt_p2/local/home/.gmenu2x/sections/retroarch
tar -xzf ${DIRECTORY}/../retroarch/files_odb/links.tgz -C ${DIRECTORY}/mnt_p2/local/home/.gmenu2x/sections/retroarch
sync

echo "## Installing Adam stuff in P2"
rm -rf ${DIRECTORY}/mnt_p2/local/home/.retroarch/system
cp -r ${DIRECTORY}/../data/* ${DIRECTORY}/mnt_p2
find ${DIRECTORY}/mnt_p2 -name .gitignore -delete
cp ${DIRECTORY}/retroarch/dosbox_pure_libretro.so ${DIRECTORY}/mnt_p2/local/home/.retroarch/cores/

echo "## Putting up version file flag"
echo ${1} > ${DIRECTORY}/mnt_p2/adam_version.txt

echo "## Setting permissions in P2"
chown -R 1000:100 ${DIRECTORY}/mnt_p2/apps
chown -R 1000:100 ${DIRECTORY}/mnt_p2/local
chown -R 0:0 ${DIRECTORY}/mnt_p2/local/etc
chown -R 0:0 ${DIRECTORY}/mnt_p2/local/var/lib

echo "## Unmounting P2"
umount ${DEVICE}p2
sync
sleep 1

if [ ! -d ${DIRECTORY}/../releases ] ; then
    mkdir ${DIRECTORY}/../releases
fi

if [ ${MAKE_PGv1} = true ] ; then
    echo "## Building P1 for PlayGo/PG2 v1 and GCW-Zero image"
    cp ${DIRECTORY}/../select_kernel/select_kernel_gcw0.bat ${DIRECTORY}/mnt_p1/select_kernel.bat
    cp ${DIRECTORY}/../select_kernel/select_kernel_gcw0.sh ${DIRECTORY}/mnt_p1/select_kernel.sh
    mkdir ${DIRECTORY}/mnt_p1/pocketgo2v1
    mkdir ${DIRECTORY}/mnt_p1/gcw0
    cat ${DIRECTORY}/../select_kernel/squashfs-root/gcw0/uzImage.bin ${DIRECTORY}/../select_kernel/squashfs-root/gcw0/pocketgo2.dtb > ${DIRECTORY}/mnt_p1/pocketgo2v1/uzImage.bin
    sha1sum ${DIRECTORY}/mnt_p1/pocketgo2v1/uzImage.bin | awk '{ print $1 }'>${DIRECTORY}/mnt_p1/pocketgo2v1/uzImage.bin.sha1
    cat ${DIRECTORY}/../select_kernel/squashfs-root/gcw0/uzImage.bin ${DIRECTORY}/../select_kernel/squashfs-root/gcw0/gcw0.dtb > ${DIRECTORY}/mnt_p1/gcw0/uzImage.bin
    sha1sum ${DIRECTORY}/mnt_p1/gcw0/uzImage.bin | awk '{ print $1 }'>${DIRECTORY}/mnt_p1/gcw0/uzImage.bin.sha1
    sync
    sleep 1

    echo "## Unmounting P1"
    umount ${DEVICE}p1
    sync
    sleep 1

    echo "## Flashing bootloader for PlayGo/PG2 v1 and GCW-Zero image"
    dd if=${DIRECTORY}/../select_kernel/squashfs-root/gcw0/ubiboot-v20_mddr_512mb.bin of=${SD_DEV} bs=512 seek=1 count=16 conv=notrunc 2>/dev/null
    sync
    sleep 1

    echo "## Compressing dump for PlayGo/PG2 v1 and GCW-Zero image"
    if [ ${COMP} = "gz" ] ; then
        gzip -9 -k ${DIRECTORY}/sd_int.img
        mv ${DIRECTORY}/sd_int.img.gz ${DIRECTORY}/../releases/adam_v${1}_PGv1.img.gz
    else
        xz -z -f -9 ${DIRECTORY}/sd_int.img > ${DIRECTORY}/../releases/adam_v${1}_PGv1.img.xz
    fi
    sync

    echo "## Remounting P1"
    mount -t vfat ${DEVICE}p1 ${DIRECTORY}/mnt_p1
    sleep 1

    rm -rf ${DIRECTORY}/mnt_p1/pocketgo2v1 2> /dev/null && sync
    rm -rf ${DIRECTORY}/mnt_p1/gcw0 2> /dev/null && sync
    rm ${DIRECTORY}/mnt_p1/select_kernel.bat 2> /dev/null && sync
    rm ${DIRECTORY}/mnt_p1/select_kernel.sh 2> /dev/null && sync
fi

if [ ${MAKE_RG} = true ] ; then
    echo "## Building P1 for RG image"
    cp ${DIRECTORY}/../select_kernel/select_kernel.bat ${DIRECTORY}/mnt_p1
    cp ${DIRECTORY}/../select_kernel/select_kernel.sh ${DIRECTORY}/mnt_p1
    mkdir ${DIRECTORY}/mnt_p1/rg280m
    mkdir ${DIRECTORY}/mnt_p1/rg280v
    mkdir ${DIRECTORY}/mnt_p1/rg350
    mkdir ${DIRECTORY}/mnt_p1/rg350m
    mkdir ${DIRECTORY}/mnt_p1/pocketgo2v2
    mkdir ${DIRECTORY}/mnt_p1/rg300x
    cat ${DIRECTORY}/../select_kernel/squashfs-root/gcw0/uzImage.bin ${DIRECTORY}/../select_kernel/squashfs-root/gcw0/rg280m.dtb > ${DIRECTORY}/mnt_p1/rg280m/uzImage.bin
    sha1sum ${DIRECTORY}/mnt_p1/rg280m/uzImage.bin | awk '{ print $1 }'>${DIRECTORY}/mnt_p1/rg280m/uzImage.bin.sha1
    cat ${DIRECTORY}/../select_kernel/squashfs-root/gcw0/uzImage.bin ${DIRECTORY}/../select_kernel/squashfs-root/gcw0/rg280v.dtb > ${DIRECTORY}/mnt_p1/rg280v/uzImage.bin
    sha1sum ${DIRECTORY}/mnt_p1/rg280v/uzImage.bin | awk '{ print $1 }'>${DIRECTORY}/mnt_p1/rg280v/uzImage.bin.sha1
    cat ${DIRECTORY}/../select_kernel/squashfs-root/gcw0/uzImage.bin ${DIRECTORY}/../select_kernel/squashfs-root/gcw0/rg350.dtb > ${DIRECTORY}/mnt_p1/rg350/uzImage.bin
    sha1sum ${DIRECTORY}/mnt_p1/rg350/uzImage.bin | awk '{ print $1 }'>${DIRECTORY}/mnt_p1/rg350/uzImage.bin.sha1
    cat ${DIRECTORY}/../select_kernel/squashfs-root/gcw0/uzImage.bin ${DIRECTORY}/../select_kernel/squashfs-root/gcw0/rg350m.dtb > ${DIRECTORY}/mnt_p1/rg350m/uzImage.bin
    sha1sum ${DIRECTORY}/mnt_p1/rg350m/uzImage.bin | awk '{ print $1 }'>${DIRECTORY}/mnt_p1/rg350m/uzImage.bin.sha1
    cat ${DIRECTORY}/../select_kernel/squashfs-root/gcw0/uzImage.bin ${DIRECTORY}/../select_kernel/squashfs-root/gcw0/pocketgo2v2.dtb > ${DIRECTORY}/mnt_p1/pocketgo2v2/uzImage.bin
    sha1sum ${DIRECTORY}/mnt_p1/pocketgo2v2/uzImage.bin | awk '{ print $1 }'>${DIRECTORY}/mnt_p1/pocketgo2v2/uzImage.bin.sha1
    cat ${DIRECTORY}/../select_kernel/squashfs-root/gcw0/uzImage.bin ${DIRECTORY}/../select_kernel/squashfs-root/gcw0/rg300x.dtb > ${DIRECTORY}/mnt_p1/rg300x/uzImage.bin
    sha1sum ${DIRECTORY}/mnt_p1/rg300x/uzImage.bin | awk '{ print $1 }'>${DIRECTORY}/mnt_p1/rg300x/uzImage.bin.sha1
    sync
    sleep 1

    echo "## Unmounting P1"
    umount ${DEVICE}p1
    sync
    sleep 1

    echo "## Flashing bootloader for RG image"
    dd if=${DIRECTORY}/../select_kernel/squashfs-root/gcw0/ubiboot-rg350.bin of=${DEVICE} bs=512 seek=1 count=16 conv=notrunc 2>/dev/null
    sync
    sleep 1

    echo "## Compressing dump for RG image"
    if [ ${COMP} = "gz" ] ; then
        gzip -9 -k ${DIRECTORY}/sd_int.img
        mv ${DIRECTORY}/sd_int.img.gz ${DIRECTORY}/../releases/adam_v${1}.img.gz
    else
        xz -z -f -9 ${DIRECTORY}/sd_int.img > ${DIRECTORY}/../releases/adam_v${1}.img.xz
    fi
    sync
fi

echo "## Final cleaning"
losetup -d ${DEVICE}
sync
sleep 1
rm -rf ${DIRECTORY}/../select_kernel/squashfs-root
if [ -f ${DIRECTORY}/sd_int.img ] ; then
    rm ${DIRECTORY}/sd_int.img
fi
rmdir ${DIRECTORY}/mnt_p1
rmdir ${DIRECTORY}/mnt_p2
