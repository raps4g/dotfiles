source $HOME/.config/bspwm/monitors
source $HOME/.config/bspwm/desktops
source $HOME/.config/bspwm/desktops_work
source $HOME/.config/bspwm/working
export DESKTOPS MAIN_MONITOR SECONDARY_MONITOR WORK_DESKTOPS

if [[ $WORKING == 'yes' ]]; then
    DESKTOPS=$DESKTOPS\ $WORK_DESKTOPS    
fi
killall polybar
if ! xrandr -q | grep $SECONDARY_MONITOR | grep disconnected ; then
    bspc monitor $SECONDARY_MONITOR -d $DESKTOPS
    nitrogen --force-setter=xinerama --head=1 --set-scaled $HOME/.local/share/backgrounds/catppuccinsky.jpeg
    MONITOR=$SECONDARY_MONITOR polybar main -c $HOME/.config/polybar/config.ini &
fi
bspc monitor $MAIN_MONITOR -d $DESKTOPS 
nitrogen --force-setter=xinerama --head=0 --set-scaled $HOME/.local/share/backgrounds/catppuccinsky.jpeg
MONITOR=$MAIN_MONITOR polybar main -c $HOME/.config/polybar/config.ini &


if [[ $(ps aux | grep "postswitch" | grep -v "grep") ]]; then
    exit
fi

killall picom
killall sxhkd
xsetroot -cursor_name left_ptr 
xinput set-prop "MSFT0001:01 06CB:CE2D Touchpad" "libinput Natural Scrolling Enabled" 1
xinput set-prop "MSFT0001:01 06CB:CE2D Touchpad" "libinput Tapping Enabled" 1
picom --legacy-backends -b --config $HOME/.config/picom/picom.conf &
sxhkd &

source $HOME/.config/bspwm/onetime_launch.sh

#if [[ $(autorandr --detected) != $(autorandr --current) ]]; then
#    autorandr --change
#fi

betterlockscreen -u $HOME/.local/share/backgrounds/catppuccinsky.jpeg
