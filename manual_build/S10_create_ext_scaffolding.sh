#!/bin/sh

# External SD scaffolding
if mount|grep -q /media/sdcard
then
    for dir in apps backups bios bios/PlayStation cheats/PlayStation roms   \
        OpenBOR/Paks
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
        roms/DOOM/DOOM2 roms/DOSBOX roms/SCUMMVM roms/PICO8         \
        roms/TIC80 roms/BBCMICRO roms/FDS roms/SGB roms/QUAKE/id1   \
        roms/QUAKE/hipnotic roms/QUAKE/rogue roms/QUAKE/dopa        \
        roms/QUAKE2/baseq2 roms/QUAKE2/rogue roms/QUAKE2/xatrix     \
        roms/QUAKE2/zaero
    do
      if [ ! -d "/media/sdcard/${dir}/.previews" ]; then
        mkdir -p "/media/sdcard/${dir}/.previews"
      fi
    done
fi
