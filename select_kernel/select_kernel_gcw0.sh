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
    result=$(dialog --stdout --nocancel --title "Select model" --menu "$TEXT" 0 0 0 1 "PocketGo2 v1" 2 "GCW-Zero")

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

status=$?

clear

if [ ${status} -eq 0 ] ; then
    dialog --msgbox "Modification completed!\n\nNow eject the card safely from your computer and insert in your ${DIR}." 16 0
else
    dialog --msgbox "ERROR\n\nCheck that you have write permissions on the boot partition of the SD." 16 0
fi

clear

exit ${status}
