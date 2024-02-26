#!/bin/bash
# Import monitors and desktops
source $HOME/.config/bspwm/monitors
source $HOME/.config/bspwm/desktops
AUTORANDR_LAST_PROFILE=$(cat $HOME/.config/autorandr/lastprofile)
n_desktops=$(echo $DESKTOPS | wc -w)

# Moves nodes between monitors to its corresponding desktop
# move_nodes() [source monitor] [target monitor]
move_nodes() {
    for (( i=1; i<=$n_desktops; i++ ))
    do
        source_desktop=$(bspc query -D -m $1 | head -n $i | tail -n 1)
        target_desktop=$(bspc query -D -m $2 | head -n $i | tail -n 1)
        for node in $(bspc query -N -d $source_desktop)
        do
            if [[ ! $(xprop -id $node WM_NAME 2>&1 | grep BadWindow) ]]; then
                bspc node $node -d $target_desktop
            fi
        done
    done
}

backup_nodes() {
    monitor=$1
    backup_file=$HOME/.config/autorandr/nodes_state
    cat /dev/null > $backup_file
    for (( i=1; i<=$n_desktops; i++ ))
    do
        desktop=$(bspc query -D -m $1 | head -n $i | tail -n 1)
        for node in $(bspc query -N -d $desktop)
        do
            if [[ ! $(xprop -id $node WM_NAME 2>&1 | grep BadWindow) ]]; then
                wm_pid=$(xprop -id $node _NET_WM_PID | sed -E 's/(.*=\s*)//')
                echo $node,$wm_pid,$i >> $backup_file 
            fi
        done
    done
}

restore_nodes() {
    monitor=$1
    backup_file=$HOME/.config/autorandr/nodes_state
    while read line; do
        IFS=','
        read -ra values <<< "$line"
        node=${values[0]}
        wm_pid=${values[1]}
        i_desktop=${values[2]}
        curr_wm_pid=$(xprop -id $node _NET_WM_PID | sed -E 's/(.*=\s*)//')
        if [[ $curr_wm_pid == $wm_pid ]]; then
            target_desktop=$(bspc query -D -m $monitor | head -n $i_desktop | tail -n 1)
            echo $node
            echo $target_desktop
            bspc node $node -d $target_desktop
        fi
    done <$backup_file
}

# Deletes desktops from the specified monitor
# remove_desktops [monitor]
remove_desktops() {
    for desktop in $(bspc query -D -m $1)
    do
        bspc desktop $desktop -r
    done
    bspc monitor $1 -r
}
