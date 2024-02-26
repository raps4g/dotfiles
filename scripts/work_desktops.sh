#!/bin/bash

source $HOME/.config/bspwm/desktops
source $HOME/.config/bspwm/desktops_work

case "$1" in
    add)
        DESKTOPS=$DESKTOPS\ $WORK_DESKTOPS
        echo WORKING=yes > $HOME/.config/bspwm/working
    ;;
    remove) 
        echo WORKING=no > $HOME/.config/bspwm/working
    ;;
esac

bspc monitor $MAIN_MONITOR -d $DESKTOPS 
if ! xrandr -q | grep $SECONDARY_MONITOR | grep disconnected ; then
    bspc monitor $SECONDARY_MONITOR -d $DESKTOPS
fi
