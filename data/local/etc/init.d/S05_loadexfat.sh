#!/bin/sh

case "$1" in
    start)
        printf "Loading exfat module and restarting udev"
        modprobe exfat
        /etc/init.d/S10udev stop
        /etc/init.d/S10udev start
        echo "done"
        ;;
    stop)
        # Nothing to do
        ;;
    *)
        echo "Usage: $0 {start|stop}"
        exit 1
        ;;
esac
