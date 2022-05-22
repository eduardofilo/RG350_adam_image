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
    result=$(dialog --stdout --nocancel --title "Select model" --menu "$TEXT" 0 0 0 1 "RG280V" 2 "RG280M v1.1 (without HDMI)" 3 "RG350/P" 4 "RG350M" 5 "PocketGo2 v2" 6 "RG300X" 7 "RG280M v1.0 (with HDMI)")

    case $result in
      1)
        DIR="rg280v"
        ;;

      2)
        DIR="rg280m-v1.1"
        ;;

      3)
        DIR="rg350"
        ;;

      4)
        DIR="rg350m"
        ;;

      5)
        DIR="pocketgo2v2"
        ;;

      6)
        DIR="rg300x"
        ;;

      7)
        DIR="rg280m-v1.0"
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
