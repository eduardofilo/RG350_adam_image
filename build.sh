#!/bin/bash

# BEGIN PARAMETER ZONE
ODBETA_ARTIFACT_ID=201765446    # ID of `update-gcw0` artifact in last workflow execution of `opendingux`
                                # branch in https://github.com/OpenDingux/buildroot repository
ODBETA_VERSION=2022-04-03       # ODbeta version to install. It should correspond with former artifact
GITHUB_ACCOUNT=PUT_HERE_YOUR_GITHUB_ACCOUNT
GITHUB_TOKEN=PUT_HERE_A_GITHUB_TOKEN
MAKE_PGv1=true                  # Build image for GCW-Zero and PocketGo2 v1
MAKE_RG=true                    # Build image for RG350 and derived
COMP=xz                         # gz or xz
P1_SIZE_SECTOR=819168           # Size of partition 1 in sectors (819168 sectors= ~400M)
SIZE_M=3200                     # Final image size in MiB
# END PARAMETER ZONE

# Deprecated
INSTALL_ODBETA_MODS=false

# Constants of convenience
DIRECTORY=$(cd $(dirname "${BASH_SOURCE[0]}") && pwd)
VERSION=$(cat ${DIRECTORY}/v)
ODBETA_DIST_FILE=gcw0-update-${ODBETA_VERSION}.opk
ODBETA_BASE_URL=http://od.abstraction.se/opendingux/latest
SECTOR_SIZE=512
P1_OFFSET_SECTOR=32


# Check if we're root and re-execute if we're not.
rootcheck () {
    if [ $(id -u) != "0" ]
    then
        sudo "$0" "$@"
        sudo chown -R $(id -u):$(id -g) "${DIRECTORY}/releases"
        sudo chown -R $(id -u):$(id -g) "${DIRECTORY}/select_kernel"
        sudo chown -R $(id -u):$(id -g) "${DIRECTORY}/retroarch/build_odb"
        sudo chown -R $(id -u):$(id -g) "${DIRECTORY}/retroarch/releases"
        exit $?
    fi
}

rootcheck "${@}"

# Calculations
mega="$(echo '2^20' | bc)"
p1_start_sector=${P1_OFFSET_SECTOR}
p1_size_sector=${P1_SIZE_SECTOR}
p2_start_sector=$((${P1_OFFSET_SECTOR}+${P1_SIZE_SECTOR}))
img_size_sector=$((${SIZE_M}*${mega}/${SECTOR_SIZE}))
p2_size_sector=$((${img_size_sector}-${p2_start_sector}))

if [ ! -f "${DIRECTORY}/select_kernel/${ODBETA_DIST_FILE}" ] ; then
    [ ${GITHUB_ACCOUNT} == "PUT_HERE_YOUR_GITHUB_ACCOUNT" ] && echo "@@ ERROR: Problem downloading ODBeta distribution. You have to put your github id in GITHUB_ACCOUNT parameter" && exit 1
    [ ${GITHUB_TOKEN} == "PUT_HERE_A_GITHUB_TOKEN" ] && echo "@@ ERROR: Problem downloading ODBeta distribution. You have to put a github token in GITHUB_TOKEN parameter" && exit 1
    echo "## Downloading ODBeta distribution"
    curl -L -H "Accept: application/vnd.github.v3+json" -u "${GITHUB_ACCOUNT}:${GITHUB_TOKEN}" -o "${DIRECTORY}/select_kernel/update-gcw0.zip" https://api.github.com/repos/OpenDingux/buildroot/actions/artifacts/${ODBETA_ARTIFACT_ID}/zip
    status=$?
    [ ! ${status} -eq 0 ] && echo "@@ ERROR: Problem downloading ODBeta distribution" && exit 1
    sync
    unzip -q -d "${DIRECTORY}/select_kernel" "${DIRECTORY}/select_kernel/update-gcw0.zip"
    rm "${DIRECTORY}/select_kernel/update-gcw0.zip"
fi
if [ -d "${DIRECTORY}/select_kernel/squashfs-root" ] ; then
    rm -rf "${DIRECTORY}/select_kernel/squashfs-root"
fi

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
losetup -P ${DEVICE} "${DIRECTORY}/sd_int.img"
sleep 1

echo "## Creating filesystems"
mkfs.vfat -F 32 ${DEVICE}p1
mkfs.ext4 -F -O ^64bit -O ^metadata_csum -O uninit_bg -L '' -q ${DEVICE}p2
sync
sleep 1

echo "## Mounting P1"
mkdir "${DIRECTORY}/mnt_p1"
mount -t vfat ${DEVICE}p1 "${DIRECTORY}/mnt_p1"
sleep 1

cd "${DIRECTORY}/select_kernel"
unsquashfs "${DIRECTORY}/select_kernel/${ODBETA_DIST_FILE}" > /dev/null

if [ ${INSTALL_ODBETA_MODS} = true ] ; then
    echo "## Installing script S99resize_p2.sh in rootfs.squashfs"
    cd "${DIRECTORY}/select_kernel/squashfs-root/gcw0"
    unsquashfs rootfs.squashfs > /dev/null
    cp "${DIRECTORY}/assets/S99resize_p2.sh" "${DIRECTORY}/select_kernel/squashfs-root/gcw0/squashfs-root/etc/init.d"
    mksquashfs squashfs-root rootfs.squashfs -noappend -comp zstd > /dev/null
fi

cd "${DIRECTORY}"

cp "${DIRECTORY}/select_kernel/squashfs-root/gcw0/rootfs.squashfs" "${DIRECTORY}/mnt_p1"
sha1sum "${DIRECTORY}/select_kernel/squashfs-root/gcw0/rootfs.squashfs" | awk '{ print $1 }'>"${DIRECTORY}/mnt_p1/rootfs.squashfs.sha1"
cp "${DIRECTORY}/select_kernel/squashfs-root/gcw0/mininit-syspart" "${DIRECTORY}/mnt_p1"
cp "${DIRECTORY}/select_kernel/squashfs-root/gcw0/mininit-syspart.sha1" "${DIRECTORY}/mnt_p1"
cp "${DIRECTORY}/select_kernel/squashfs-root/gcw0/modules.squashfs" "${DIRECTORY}/mnt_p1"
cp "${DIRECTORY}/select_kernel/squashfs-root/gcw0/modules.squashfs.sha1" "${DIRECTORY}/mnt_p1"
mkdir "${DIRECTORY}/mnt_p1/dev"
mkdir "${DIRECTORY}/mnt_p1/root"

echo "## Mounting P2"
mkdir "${DIRECTORY}/mnt_p2"
mount -t ext4 ${DEVICE}p2 "${DIRECTORY}/mnt_p2"
sleep 1

echo "## Installing RetroArch stuff in P2"
E_BUILD_STOCK=false E_BUILD_ODBETA=true E_CONF_CSV=all "${DIRECTORY}/retroarch/build.sh"
mkdir -p "${DIRECTORY}/mnt_p2/apps"
cp -f "${DIRECTORY}/retroarch/files_odb/retroarch_rg350_odbeta.opk" "${DIRECTORY}/mnt_p2/apps"
mkdir -p "${DIRECTORY}/mnt_p2/local/bin"
cp -f "${DIRECTORY}/retroarch/files_odb/retroarch_rg350_odbeta" "${DIRECTORY}/mnt_p2/local/bin"
# Installing OPK wrappers for cores
tar -xzf "${DIRECTORY}/retroarch/files_odb/apps_ra.tgz" -C "${DIRECTORY}/mnt_p2/apps"
# Installing home files
mkdir -p "${DIRECTORY}/mnt_p2/local/home/.retroarch"
tar -xzf "${DIRECTORY}/retroarch/files_odb/retroarch.tgz" -C "${DIRECTORY}/mnt_p2/local/home/.retroarch"
# Installing GMenu2X links
mkdir -p "${DIRECTORY}/mnt_p2/local/home/.gmenu2x/sections/retroarch"
tar -xzf "${DIRECTORY}/retroarch/files_odb/links.tgz" -C "${DIRECTORY}/mnt_p2/local/home/.gmenu2x/sections/retroarch"
sync

echo "## Installing Adam stuff in P2"
rm -rf "${DIRECTORY}/mnt_p2/local/home/.retroarch/system"
cp -r "${DIRECTORY}/data"/* "${DIRECTORY}/mnt_p2"
find "${DIRECTORY}/mnt_p2" -name .gitignore -delete
cp "${DIRECTORY}/assets/dosbox_pure_libretro.so" "${DIRECTORY}/mnt_p2/local/home/.retroarch/cores/"

echo "## Putting up version file flag"
echo ${VERSION} > "${DIRECTORY}/mnt_p2/adam_version.txt"

echo "## Setting permissions in P2"
chown -R 1000:100 "${DIRECTORY}/mnt_p2/apps"
chown -R 1000:100 "${DIRECTORY}/mnt_p2/local"
chown -R 0:0 "${DIRECTORY}/mnt_p2/local/etc"
chown -R 0:0 "${DIRECTORY}/mnt_p2/local/var/lib"

echo "## Unmounting P2"
umount ${DEVICE}p2
sync
sleep 1

if [ ! -d "${DIRECTORY}/releases" ] ; then
    mkdir "${DIRECTORY}/releases"
fi

if [ ${MAKE_PGv1} = true ] ; then
    echo "## Building P1 for PlayGo/PG2 v1 and GCW-Zero image"
    cp "${DIRECTORY}/select_kernel/select_kernel_gcw0.bat" "${DIRECTORY}/mnt_p1/select_kernel.bat"
    cp "${DIRECTORY}/select_kernel/select_kernel_gcw0.sh" "${DIRECTORY}/mnt_p1/select_kernel.sh"
    mkdir "${DIRECTORY}/mnt_p1/pocketgo2v1"
    mkdir "${DIRECTORY}/mnt_p1/gcw0"
    cat "${DIRECTORY}/select_kernel/squashfs-root/gcw0/uzImage.bin" "${DIRECTORY}/select_kernel/squashfs-root/gcw0/pocketgo2.dtb" > "${DIRECTORY}/mnt_p1/pocketgo2v1/uzImage.bin"
    sha1sum "${DIRECTORY}/mnt_p1/pocketgo2v1/uzImage.bin" | awk '{ print $1 }'>"${DIRECTORY}/mnt_p1/pocketgo2v1/uzImage.bin.sha1"
    cat "${DIRECTORY}/select_kernel/squashfs-root/gcw0/uzImage.bin" "${DIRECTORY}/select_kernel/squashfs-root/gcw0/gcw0.dtb" > "${DIRECTORY}/mnt_p1/gcw0/uzImage.bin"
    sha1sum "${DIRECTORY}/mnt_p1/gcw0/uzImage.bin" | awk '{ print $1 }'>"${DIRECTORY}/mnt_p1/gcw0/uzImage.bin.sha1"
    sync
    sleep 1

    echo "## Unmounting P1"
    umount ${DEVICE}p1
    sync
    sleep 1

    echo "## Flashing bootloader for PlayGo/PG2 v1 and GCW-Zero image"
    dd if="${DIRECTORY}/select_kernel/squashfs-root/gcw0/ubiboot-v20_mddr_512mb.bin" of=${SD_DEV} bs=512 seek=1 count=16 conv=notrunc 2>/dev/null
    sync
    sleep 1

    echo "## Compressing dump for PlayGo/PG2 v1 and GCW-Zero image"
    if [ ${COMP} = "gz" ] ; then
        gzip -9 -k "${DIRECTORY}/sd_int.img"
        mv "${DIRECTORY}/sd_int.img.gz" "${DIRECTORY}/releases/adam_v${VERSION}_PGv1.img.gz"
    else
        xz -z -f -k -9 "${DIRECTORY}/sd_int.img"
        mv "${DIRECTORY}/sd_int.img.xz" "${DIRECTORY}/releases/adam_v${VERSION}_PGv1.img.xz"
    fi
    sync

    echo "## Remounting P1"
    mount -t vfat ${DEVICE}p1 "${DIRECTORY}/mnt_p1"
    sleep 1

    rm -rf "${DIRECTORY}/mnt_p1/pocketgo2v1" 2> /dev/null && sync
    rm -rf "${DIRECTORY}/mnt_p1/gcw0" 2> /dev/null && sync
    rm "${DIRECTORY}/mnt_p1/select_kernel.bat" 2> /dev/null && sync
    rm "${DIRECTORY}/mnt_p1/select_kernel.sh" 2> /dev/null && sync
fi

if [ ${MAKE_RG} = true ] ; then
    echo "## Building P1 for RG image"
    cp "${DIRECTORY}/select_kernel/select_kernel.bat" "${DIRECTORY}/mnt_p1"
    cp "${DIRECTORY}/select_kernel/select_kernel.sh" "${DIRECTORY}/mnt_p1"
    mkdir "${DIRECTORY}/mnt_p1/rg280m-v1.1"
    mkdir "${DIRECTORY}/mnt_p1/rg280v"
    mkdir "${DIRECTORY}/mnt_p1/rg350"
    mkdir "${DIRECTORY}/mnt_p1/rg350m"
    mkdir "${DIRECTORY}/mnt_p1/pocketgo2v2"
    mkdir "${DIRECTORY}/mnt_p1/rg300x"
    mkdir "${DIRECTORY}/mnt_p1/rg280m-v1.0"
    cat "${DIRECTORY}/select_kernel/squashfs-root/gcw0/uzImage.bin" "${DIRECTORY}/select_kernel/squashfs-root/gcw0/rg280m-v1.1.dtb" > "${DIRECTORY}/mnt_p1/rg280m-v1.1/uzImage.bin"
    sha1sum "${DIRECTORY}/mnt_p1/rg280m-v1.1/uzImage.bin" | awk '{ print $1 }'>"${DIRECTORY}/mnt_p1/rg280m-v1.1/uzImage.bin.sha1"
    cat "${DIRECTORY}/select_kernel/squashfs-root/gcw0/uzImage.bin" "${DIRECTORY}/select_kernel/squashfs-root/gcw0/rg280v.dtb" > "${DIRECTORY}/mnt_p1/rg280v/uzImage.bin"
    sha1sum "${DIRECTORY}/mnt_p1/rg280v/uzImage.bin" | awk '{ print $1 }'>"${DIRECTORY}/mnt_p1/rg280v/uzImage.bin.sha1"
    cat "${DIRECTORY}/select_kernel/squashfs-root/gcw0/uzImage.bin" "${DIRECTORY}/select_kernel/squashfs-root/gcw0/rg350.dtb" > "${DIRECTORY}/mnt_p1/rg350/uzImage.bin"
    sha1sum "${DIRECTORY}/mnt_p1/rg350/uzImage.bin" | awk '{ print $1 }'>"${DIRECTORY}/mnt_p1/rg350/uzImage.bin.sha1"
    cat "${DIRECTORY}/select_kernel/squashfs-root/gcw0/uzImage.bin" "${DIRECTORY}/select_kernel/squashfs-root/gcw0/rg350m.dtb" > "${DIRECTORY}/mnt_p1/rg350m/uzImage.bin"
    sha1sum "${DIRECTORY}/mnt_p1/rg350m/uzImage.bin" | awk '{ print $1 }'>"${DIRECTORY}/mnt_p1/rg350m/uzImage.bin.sha1"
    cat "${DIRECTORY}/select_kernel/squashfs-root/gcw0/uzImage.bin" "${DIRECTORY}/select_kernel/squashfs-root/gcw0/pocketgo2v2.dtb" > "${DIRECTORY}/mnt_p1/pocketgo2v2/uzImage.bin"
    sha1sum "${DIRECTORY}/mnt_p1/pocketgo2v2/uzImage.bin" | awk '{ print $1 }'>"${DIRECTORY}/mnt_p1/pocketgo2v2/uzImage.bin.sha1"
    cat "${DIRECTORY}/select_kernel/squashfs-root/gcw0/uzImage.bin" "${DIRECTORY}/select_kernel/squashfs-root/gcw0/rg300x.dtb" > "${DIRECTORY}/mnt_p1/rg300x/uzImage.bin"
    sha1sum "${DIRECTORY}/mnt_p1/rg300x/uzImage.bin" | awk '{ print $1 }'>"${DIRECTORY}/mnt_p1/rg300x/uzImage.bin.sha1"
    cat "${DIRECTORY}/select_kernel/squashfs-root/gcw0/uzImage.bin" "${DIRECTORY}/select_kernel/squashfs-root/gcw0/rg280m-v1.0.dtb" > "${DIRECTORY}/mnt_p1/rg280m-v1.0/uzImage.bin"
    sha1sum "${DIRECTORY}/mnt_p1/rg280m-v1.0/uzImage.bin" | awk '{ print $1 }'>"${DIRECTORY}/mnt_p1/rg280m-v1.0/uzImage.bin.sha1"
    sync
    sleep 1

    echo "## Unmounting P1"
    umount ${DEVICE}p1
    sync
    sleep 1

    echo "## Flashing bootloader for RG image"
    dd if="${DIRECTORY}/select_kernel/squashfs-root/gcw0/ubiboot-rg350.bin" of=${DEVICE} bs=512 seek=1 count=16 conv=notrunc 2>/dev/null
    sync
    sleep 1

    echo "## Compressing dump for RG image"
    if [ ${COMP} = "gz" ] ; then
        gzip -9 -k "${DIRECTORY}/sd_int.img"
        mv "${DIRECTORY}/sd_int.img.gz" "${DIRECTORY}/releases/adam_v${VERSION}.img.gz"
    else
        xz -z -f -k -9 "${DIRECTORY}/sd_int.img"
        mv "${DIRECTORY}/sd_int.img.xz" "${DIRECTORY}/releases/adam_v${VERSION}.img.xz"
    fi
    sync
fi

echo "## Final cleaning"
losetup -d ${DEVICE}
sync
sleep 1
rm -rf "${DIRECTORY}/select_kernel/squashfs-root"
if [ -f "${DIRECTORY}/sd_int.img" ] ; then
    rm "${DIRECTORY}/sd_int.img"
fi
rmdir "${DIRECTORY}/mnt_p1"
rmdir "${DIRECTORY}/mnt_p2"
