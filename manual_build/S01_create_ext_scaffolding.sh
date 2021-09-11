#!/bin/sh

# External SD scaffolding
if mount|grep -q /media/sdcard
then
    for dir in apps backups bios bios/PlayStation cheats/PlayStation roms   \
        OpenBOR OpenBOR/Paks
    do
      if [ ! -d "/media/sdcard/${dir}" ]; then
        mkdir -p "/media/sdcard/${dir}"
      fi
    done

    for dir in roms/ARCADE roms/CPS roms/FBA roms/DAPHNE roms/FC    \
        roms/SFC roms/VB roms/SG1000 roms/SMS roms/MD roms/SEGACD   \
        roms/32X roms/A2600 roms/A5200 roms/A7800 roms/INTELLI      \
        roms/COLECO roms/NEOGEO roms/PCE roms/PCECD roms/PS roms/GB \
        roms/GBC roms/GBA roms/GW roms/GG roms/LYNX roms/NGP        \
        roms/WSC roms/POKEMINI roms/SUPERVISION roms/ZX             \
        roms/AMSTRAD roms/C64 roms/MSX roms/AMIGA roms/DOOM/DOOM    \
        roms/DOOM/DOOM2 roms/QUAKE roms/DOSBOX roms/SCUMMVM         \
        roms/PICO8 roms/TIC80
    do
      if [ ! -d "/media/sdcard/${dir}/.previews" ]; then
        mkdir -p "/media/sdcard/${dir}/.previews"
      fi
    done
fi
