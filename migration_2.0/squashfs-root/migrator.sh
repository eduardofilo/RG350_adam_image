#!/bin/sh

ADAM_VERSION=`cat /media/data/adam_version.txt`

# Version comparison functions
verlte() {
    [  "$1" = "`echo -e "$1\n$2" | sort -n | head -n1`" ]
}

verlt() {
    [ "$1" = "$2" ] && return 1 || verlte $1 $2
}

export DIALOGOPTS="--colors --backtitle \"Adam 2.0 migrator\""
echo "screen_color = (WHITE,BLACK,ON)" > /media/data/local/home/.dialogrc

# Aviso para versiones anteriores a 10.0 ya que se han retirado los parches para esas versiones
if ! verlte ${ADAM_VERSION} "1.4.2"; then
    echo "screen_color = (WHITE,RED,ON)" > /media/data/local/home/.dialogrc
    dialog --msgbox "This migrator app should only run on Adam version 1.4.2 or earlier. The detected version of Adam is ${ADAM_VERSION}." 16 0
    rm /media/data/local/home/.dialogrc
    exit 1
fi

if ! mount|grep -q /media/sdcard; then
    echo "screen_color = (WHITE,RED,ON)" > /media/data/local/home/.dialogrc
    dialog --msgbox "Your external SD card is not detected. Review that it is FAT32 or exFAT formatted and it not have label defined." 16 0
    rm /media/data/local/home/.dialogrc
    exit 1
fi

TEXTO="This program will copy all savestates from the internal SD card of an Adam 1.4.2 or earlier installation to the external SD card from where they are maintained from Adam 2.0. The external card must be FAT32 or exFAT formatted and must not have label defined.

Select \Zb\Z3Yes\Zn and press \Zb\Z3Start\Zn to proceed with migration."

# Ask options
dialog --title "Confirmation" --yesno "${TEXTO}" 16 0
result=$?
rm /media/data/local/home/.dialogrc
case ${result} in
   1) exit 1;;
   255) exit 1;;
esac

clear
## Save states directories
for dir in fba regba pocketsnes pcsx4all_sstates pcsx4all_memcards \
    xmame52 xmame69 xmame84 vbemu beebem scummvm
do
    if [ ! -d "/media/sdcard/states/${dir}" ]; then
        mkdir -p "/media/sdcard/states/${dir}"
    fi
done

## RetroArch directories
for dir in autoconfig playlists saves states
do
    if [ ! -d "/media/sdcard/retroarch/${dir}" ]; then
        mkdir -p "/media/sdcard/retroarch/${dir}"
    fi
done

## SimpleMenu stuff
if [ ! -f "/media/sdcard/simplemenu/favorites.sav" ]; then
    mkdir -p "/media/sdcard/simplemenu"
    touch "/media/sdcard/simplemenu/favorites.sav"
fi
if [ ! -d "/media/sdcard/simplemenu/rom_preferences" ]; then
    mkdir -p "/media/sdcard/simplemenu/rom_preferences"
fi

echo "Copying FBA savestates"
cp -r /media/data/local/home/.fba/saves/* /media/sdcard/states/fba 2>/dev/null
sync
sleep 1

echo "Copying ReGBA savestates"
cp -r /media/data/local/home/.gpsp/*.s?? /media/sdcard/states/regba 2>/dev/null
sync
sleep 1

echo "Copying PocketSNES savestates"
cp -r /media/data/local/home/.pocketsnes/*.sv? /media/sdcard/states/pocketsnes 2>/dev/null
sync
sleep 1

echo "Copying PCSX4All savestates and memcards"
cp -r /media/data/local/home/.pcsx4all/sstates/* /media/sdcard/states/pcsx4all_sstates 2>/dev/null
cp -r /media/data/local/home/.pcsx4all/memcards/* /media/sdcard/states/pcsx4all_memcards 2>/dev/null
sync
sleep 1

echo "Copying xMAME savestates"
cp -r /media/data/local/share/xmame/xmame52/sta/* /media/sdcard/states/xmame52 2>/dev/null
cp -r /media/data/local/share/xmame/xmame69/sta/* /media/sdcard/states/xmame69 2>/dev/null
cp -r /media/data/local/share/xmame/xmame84/sta/* /media/sdcard/states/xmame84 2>/dev/null
sync
sleep 1

echo "Copying VBEmu savestates"
cp -r /media/data/local/home/.vbemu/sstates/* /media/sdcard/states/vbemu 2>/dev/null
sync
sleep 1

echo "Copying BeebEm savestates"
cp -r /media/data/local/home/.beebem/saves/* /media/sdcard/states/beebem 2>/dev/null
sync
sleep 1

echo "Copying ScummVM savestates"
cp -r /media/data/local/home/.scummvm/saves/* /media/sdcard/states/scummvm 2>/dev/null
sync
sleep 1

echo "Copying RA savestates, controller and playlists"
if [ -d "/media/data/local/home/.retroarch/autoconfig" ]; then
    cp -r /media/data/local/home/.retroarch/autoconfig/* /media/sdcard/retroarch/autoconfig 2>/dev/null
fi
if [ -d "/media/data/local/home/.retroarch/playlists" ]; then
    cp -r /media/data/local/home/.retroarch/playlists/* /media/sdcard/retroarch/playlists 2>/dev/null
fi
if [ -d "/media/data/local/home/.retroarch/saves" ]; then
    cp -r /media/data/local/home/.retroarch/saves/* /media/sdcard/retroarch/saves 2>/dev/null
fi
if [ -d "/media/data/local/home/.retroarch/states" ]; then
    cp -r /media/data/local/home/.retroarch/states/* /media/sdcard/retroarch/states 2>/dev/null
fi
sync
sleep 1

echo "Copying SimpleMenu favorites and rom_preferences"
cp /media/data/local/home/.simplemenu/favorites.sav /media/sdcard/simplemenu/favorites.sav
cp -r /media/data/local/home/.simplemenu/rom_preferences/* /media/sdcard/simplemenu/rom_preferences 2>/dev/null
sync
sleep 1

sleep 3

echo "screen_color = (WHITE,BLACK,ON)" > /media/data/local/home/.dialogrc
dialog --msgbox "Migration completed!\n\nNow you can flash Adam 2.0 on internal card and your game progress will be preserved." 16 0
rm /media/data/local/home/.dialogrc
