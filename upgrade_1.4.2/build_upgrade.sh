#!/bin/bash

DIRECTORY=$(pwd)

# Check if we're root and re-execute if we're not.
rootcheck () {
    if [ $(id -u) != "0" ]
    then
        sudo "$0" "$@"
        sudo chown $(id -u):$(id -g) ${DIRECTORY}/../releases/upgrade_${1}.tgz
        exit $?
    fi
}

if [ $# -ne 1 ] ; then
    echo -e "usage: ./build_upgrade.sh <v>\n  <v>: version; e.g. 1.4.2"
    exit 1
fi

rootcheck "${@}"

rm -rf ${DIRECTORY}/root

mkdir -p ${DIRECTORY}/root/media/data/local/etc/init.d
cp ${DIRECTORY}/../manual_build/S10_create_ext_scaffolding.sh ${DIRECTORY}/root/media/data/local/etc/init.d/S10_create_ext_scaffolding.sh

mkdir -p ${DIRECTORY}/root/media/data
echo ${1} > ${DIRECTORY}/root/media/data/adam_version.txt

mkdir -p ${DIRECTORY}/root/media/data/local/home/.py_backup
cp ${DIRECTORY}/../manual_build/config.ini ${DIRECTORY}/root/media/data/local/home/.py_backup/config.ini

mkdir -p ${DIRECTORY}/root/media/data/local/home/.simplemenu
cp ${DIRECTORY}/../manual_build/simplemenu/alias_PICO-8.txt ${DIRECTORY}/root/media/data/local/home/.simplemenu/alias_PICO-8.txt

mkdir -p ${DIRECTORY}/root/media/data/local/home/.simplemenu/section_groups
cp "${DIRECTORY}/../manual_build/simplemenu/home computers.ini" "${DIRECTORY}/root/media/data/local/home/.simplemenu/section_groups/home computers.ini"
cp ${DIRECTORY}/../manual_build/simplemenu/handhelds.ini ${DIRECTORY}/root/media/data/local/home/.simplemenu/section_groups/handhelds.ini
chown -R 1000:100 ${DIRECTORY}/root/media/data/local/home

# SimpleMenu 10.3
mkdir -p ${DIRECTORY}/root/media/data/apps
wget -q -P ${DIRECTORY}/root/media/data/apps https://github.com/fgl82/simplemenu/releases/download/10.3/SimpleMenu-OD-BETA.opk
chown -R 1000:100 ${DIRECTORY}/root/media/data/apps

# Previews
mkdir -p ${DIRECTORY}/root/media/data/local/home/.simplemenu/apps/.previews
cp ${DIRECTORY}/passwd.png "${DIRECTORY}/root/media/data/local/home/.simplemenu/apps/.previews/sudo -S od-passwd-config od.png"
chown -R 1000:100 ${DIRECTORY}/root/media/data/apps/.previews

# Alias file because of issue #210
cp ${DIRECTORY}/../manual_build/simplemenu/alias.txt ${DIRECTORY}/root/media/data/local/home/.simplemenu/alias.txt
chown 1000:100 ${DIRECTORY}/root/media/data/local/home/.simplemenu/alias.txt

cd ${DIRECTORY}
tar --directory=${DIRECTORY}/root/ -czvf ${DIRECTORY}/../releases/upgrade_${1}.tgz media
