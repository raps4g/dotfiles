if ! [[ $(ps aux | grep "postswitch" | grep -v "grep") ]]; then
    killall picom
    killall sxhkd
    xsetroot -cursor_name left_ptr 
    xinput set-prop "MSFT0001:01 06CB:CE2D Touchpad" "libinput Natural Scrolling Enabled" 1
    xinput set-prop "MSFT0001:01 06CB:CE2D Touchpad" "libinput Tapping Enabled" 1
    picom --legacy-backends -b --config $HOME/.config/picom/picom.conf &
    nm-applet &
    xfce4-power-manager &
    sxhkd &
fi

nitrogen --force-setter=xinerama --head=0 --set-scaled $HOME/.local/share/backgrounds/white.jpg
if [ $(autorandr --current) == 'docked' ]; then 
    nitrogen --force-setter=xinerama --head=1 --set-scaled $HOME/.local/share/backgrounds/white.jpg
fi

$HOME/.config/polybar/polybar_launcher.sh
