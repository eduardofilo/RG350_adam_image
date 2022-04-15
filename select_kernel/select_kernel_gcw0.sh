#!/bin/bash

export DIALOGOPTS="--colors --backtitle \"Select Kernel\""
echo "screen_color = (RED,RED,ON)" > /tmp/dialog_err.rc

TEXT="
Choose the model of your console to adapt the Linux Kernel of OD Beta firmware.

Use \Zb\Z3Up/Down\Zn keys to select and \Zb\Z3Return\Zn to proceed."

DIR=""
while [[ $DIR == "" ]]
do
    # Ask for console model
    result=$(dialog --stdout --nocancel --title "Select model" --menu "$TEXT" 0 0 0 1 "PocketGo2 v2" 2 "GCW-Zero")

    case $result in
      1)
        DIR="pocketgo2v1"
        ;;

      2)
        DIR="gcw0"
        ;;

      *)
        DIR=""
        ;;
    esac
done

cp ${DIR}/uzImage.bin .
cp ${DIR}/uzImage.bin.sha1 .

clear

dialog --msgbox "Modification completed!\n\nNow eject the card safelly from your computer and insert in your ${DIR}." 16 0

clear
