#!/bin/sh
source $HOME/.config/bspwm/monitors

window_id=$1
window_class=$2
window_instance=$3
consequences=$4
window_title="$(xwininfo -id "$window_id" | sed -nE 's/^xwininfo.{1,}"(.*)"$/\1/p')"

if [[ $(xprop -id "$window_id" | grep \
    -e _NET_WM_WINDOW_TYPE_DIALOG \
    -e _NET_WM_STATE_MODAL) ]]; then
    exit
fi

function get_monitor_desktop() {
    desktop_name=$1
    to_secondary=$2
    if [[ $to_secondary = 1 && $(xrandr -q | grep $SECONDARY_MONITOR\ connected) ]]; then
        desktop_num=$(bspc query -D -m $SECONDARY_MONITOR --names | grep -n $desktop_name | cut -d: -f1)
        echo "$SECONDARY_MONITOR:^$desktop_num"
    else
        monitor=$(bspc query -M -m --names)
        desktop_num=$(bspc query -D -m --names | grep -n $desktop_name | cut -d: -f1)
        echo "$monitor:^$desktop_num" 
    fi
}

function win_dimensions() {
        win_full_width=$(xrandr | grep '*' | sed -nE 's/(.{1,})x.{1,}/\1/p' |\
            awk '{ print $1 }' | paste -s -d+ | bc)
        
        win_width=$(xrandr | grep '*' | sed -nE 's/(.{1,})x.{1,}/\1/p' |\
            awk '{ print $1 }' | tail -n 1)
        
        win_height=$(xrandr | grep '*' | sed -nE 's/.{1,}x(.{1,})/\1/p' |\
            awk '{ print $1 }' | tail -n 1)
        
        rec_width=$(bc -l <<< "scale=0; ${win_width}/4")
        rec_height=$(bc -l <<< "scale=0; ${win_height}/4")
        rec_x=$(( $win_full_width - $rec_width - 50))
        rec_y=$(( $win_height - $rec_height - 50))
}

if  [[ "$window_class" = "firefox" ]]; then
#    if [[ "$window_title" =~ Private ]]
#	then
#        desktop=$(get_monitor_desktop 5 0)
#        echo desktop="$desktop"
#        echo follow=on
	if [[ "$window_title" =~ Picture-in-Picture ]]; then
        win_dimensions
        echo state=floating
        echo sticky=on
        echo rectangle=${rec_width}x${rec_height}+${rec_x}+${rec_y} 
#    else
#        desktop=$(get_monitor_desktop firefox 0)
#        echo desktop="$desktop"
#        echo follow=on
    fi
elif  [[ "$window_class" = "Nemo" || "$window_class" = "Thunar" ]]; then
    desktop=$(get_monitor_desktop 4 0)
    echo desktop="$desktop" 
    echo follow=on
elif  [[ "$window_class" = "vlc" ]]; then
    desktop=$(get_monitor_desktop 4 0)
    echo desktop="$desktop" 
    echo follow=on
elif  [[ "$window_class" = "Chromium-browser" || "$window_class" = "Brave-browser" ]]; then
    source $HOME/.config/bspwm/working
    if [[ $WORKING == 'no' ]]; then
        $HOME/scripts/work_desktops.sh add
    fi
    desktop=$(get_monitor_desktop chrome 1)
    echo desktop="$desktop" 
    echo follow=on
elif  [[ "$window_class" = "SWT" || "$window_class" = \
    "Org.gnome.Epiphany.WebApp_bcdcf0baf1263b5d9aca9" ]]; then
    source $HOME/.config/bspwm/working
    if [[ $WORKING == 'no' ]]; then
        $HOME/scripts/work_desktops.sh add
    fi
    desktop=$(get_monitor_desktop code 1)
    echo desktop="$desktop" 
    echo follow=on
elif  [[ "$window_class" = "oracle-ide-osgi-boot-OracleIdeLauncher" || \
    "$window_class" = "DBeaver" || "$window_title" = "Oracle SQL Developer" ]]; then
    source $HOME/.config/bspwm/working
    if [[ $WORKING == 'no' ]]; then
        $HOME/scripts/work_desktops.sh add
    fi
    desktop=$(get_monitor_desktop db 1)
    echo desktop="$desktop" 
    echo follow=on
fi

#echo $window_id >> ~/.config/bspwm/log 
#echo $desktop >> ~/.config/bspwm/log 
#echo $window_class >> ~/.config/bspwm/log 
#echo $window_instance >> ~/.config/bspwm/log
#echo $window_title >> ~/.config/bspwm/log
#echo   >> ~/.config/bspwm/log

