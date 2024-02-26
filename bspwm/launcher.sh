bspc monitor $MAIN_MONITOR -d $DESKTOPS 
nitrogen --force-setter=xinerama --head=0 --set-scaled $HOME/.local/share/backgrounds/geomwhite.png
killall polybar
MONITOR=$MAIN_MONITOR polybar main -c $HOME/.config/polybar/config.ini &

if [[ $DUAL_MONITOR == 'yes' ]]; then
    bspc monitor $SECONDARY_MONITOR -d $DESKTOPS
    nitrogen --force-setter=xinerama --head=1 --set-scaled $HOME/.local/share/backgrounds/geomwhite.png
    MONITOR=$SECONDARY_MONITOR polybar main -c $HOME/.config/polybar/config.ini &
fi

if [[ $(ps aux | grep "postswitch" | grep -v "grep") ]]; then
    exit
fi

killall picom
killall sxhkd
xsetroot -cursor_name left_ptr 
xinput set-prop "MSFT0001:01 06CB:CE2D Touchpad" "libinput Natural Scrolling Enabled" 1
xinput set-prop "MSFT0001:01 06CB:CE2D Touchpad" "libinput Tapping Enabled" 1
picom --legacy-backends -b --config $HOME/.config/picom/picom.conf &
nm-applet &
xfce4-power-manager &
sxhkd &

#if [[ $(autorandr --detected) != $(autorandr --current) ]]; then
#    autorandr --change
#fi

betterlockscreen -u $HOME/.local/share/backgrounds/geomwhite.png
