#!/bin/bash
killall -q polybar
source $HOME/.config/bspwm/monitors
#while pgrep -u $UID -x polybar >/dev/null; do sleep 1; done
if [ $(autorandr --current) == 'docked' ]; then 
    MONITOR=$MAIN_MONITOR TRAY_POS=none TRAY_X_OFF=0 polybar main \
        -c $HOME/.config/polybar/config.ini &
    MONITOR=$SECONDARY_MONITOR TRAY_POS=right TRAY_X_OFF=-545 polybar main \
        -c $HOME/.config/polybar/config.ini &
else
    MONITOR=$MAIN_MONITOR TRAY_POS=right TRAY_X_OFF=-525 polybar main \
        -c $HOME/.config/polybar/config.ini &
fi
