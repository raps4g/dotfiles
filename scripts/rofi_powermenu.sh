#!/bin/bash

selection=$(echo "Shutdown|Reboot|Lock|Suspend|Log out" | \
    rofi -dmenu -i -config $HOME/.config/rofi/powermenu.rasi \
    -sep \| -no-fixed-num-lines -p Action)

case $selection in
    Shutdown)
        shutdown now
        ;;
    Reboot)
        reboot
        ;;
    Lock)
        betterlockscreen -l &
        ;;
    Suspend)
        betterlockscreen -l &
        systemctl suspend
        ;;
    Log\ out)
        bspc quit &
esac
