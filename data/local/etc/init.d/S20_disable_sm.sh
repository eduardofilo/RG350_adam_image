#!/bin/sh

if cat /sys/kernel/debug/gpio|grep gpio-148|grep lo > /dev/null 2>&1
then
    rm /media/data/local/home/.autostart
fi
