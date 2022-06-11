#!/bin/sh

# External SD scaffolding

if mount|grep -q /media/sdcard
then
    ## Special directories
    for dir in apps backups bios/PlayStation cheats/PlayStation     \
        OpenBOR/Paks roms states
    do
        if [ ! -d "/media/sdcard/${dir}" ]; then
            mkdir -p "/media/sdcard/${dir}"
        fi
    done

    ## ROMs directories
    for dir in 32X A2600 A5200 A7800 AMIGA AMSTRAD ARCADE           \
        BBCMICRO C64 COLECO CPS DAPHNE DOOM/DOOM DOOM/DOOM2 DOSBOX  \
        FBA FC FDS GB GBA GBC GG GW INTELLI LYNX MD MSX NEOGEO NGP  \
        PCE PCECD PICO8 POKEMINI PS QUAKE/dopa QUAKE/hipnotic       \
        QUAKE/id1 QUAKE/rogue QUAKE2/baseq2 QUAKE2/rogue            \
        QUAKE2/xatrix QUAKE2/zaero SCUMMVM SEGACD SFC SG1000 SGB    \
        SMS SUPERVISION TIC80 VB WSC ZX
    do
        if [ ! -d "/media/sdcard/roms/${dir}/.previews" ]; then
            mkdir -p "/media/sdcard/roms/${dir}/.previews"
        fi
    done

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

    ## Quake fbl's
    pak="exec=pak0.pak"
    for dir2 in QUAKE/id1 QUAKE/hipnotic QUAKE/rogue QUAKE/dopa     \
        QUAKE2/baseq2 QUAKE2/rogue QUAKE2/xatrix QUAKE2/zaero
    do
        dir="/media/sdcard/roms/${dir2}"
        count=`ls -1 ${dir}/*.fbl 2>/dev/null | wc -l`
        if [ $count -eq 0 ] && [ -e "${dir}/pak0.pak" ]; then
            case ${dir2} in
                QUAKE/id1)      echo "$pak" > "${dir}/Quake.fbl" ;;
                QUAKE/hipnotic) echo "$pak" > "${dir}/Mission pack 1.fbl" ;;
                QUAKE/rogue)    echo "$pak" > "${dir}/Mission pack 2.fbl" ;;
                QUAKE/dopa)     echo "$pak" > "${dir}/Episode 5. Dimension of the Past.fbl" ;;
                QUAKE2/baseq2)  echo "$pak" > "${dir}/Quake II.fbl" ;;
                QUAKE2/rogue)   echo "$pak" > "${dir}/Ground Zero.fbl" ;;
                QUAKE2/xatrix)  echo "$pak" > "${dir}/The Reckoning.fbl" ;;
                QUAKE2/zaero)   echo "$pak" > "${dir}/Zaero.fbl" ;;
            esac
        fi
    done
fi
