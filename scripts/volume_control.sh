#!/bin/bash

volume_step=1
max_volume=125
timeout=1000

function get_volume {
    pactl get-sink-volume @DEFAULT_SINK@ | grep -Po '[0-9]{1,3}(?=%)' | head -1
}

function get_mute {
    pactl get-sink-mute @DEFAULT_SINK@ | grep -Po '(?<=Mute: )(yes|no)'
}

function get_volume_icon {
    volume=$(get_volume)
    mute=$(get_mute)
    if [ "$volume" -eq 0 ] || [ "$mute" == "yes" ] ; then
        volume_icon=""
        urgency=critical
    elif [ "$volume" -le 33 ]; then
        volume_icon=""
        urgency=normal
    elif [ "$volume" -le 66 ]; then
        volume_icon=""
        urgency=normal
    else
        volume_icon=""
        urgency=normal
    fi
}

function show_volume_notif {
    get_volume_icon
    bar_value=$( bc -l <<< "scale=0; ${volume}*100/${max_volume}" )
    tag=volume_notif
    summ=" "
    body_icon="<span font='Font Awesome 5 Free Solid 12'>$volume_icon </span>"
    body_text="<span font='Ubuntu Light 12'>$volume%</span>"
    body="$body_icon $body_text"
    notify-send -t $timeout -h string:x-dunst-stack-tag:$tag\
        -u $urgency -h int:value:$bar_value "$summ" "$body" 
}

case $1 in
    up)
    pactl set-sink-mute @DEFAULT_SINK@ 0
    volume=$(get_volume)
    if [ $(( "$volume" + "$volume_step" )) -gt $max_volume ]; then
        pactl set-sink-volume @DEFAULT_SINK@ $max_volume%
    else
        pactl set-sink-volume @DEFAULT_SINK@ +$volume_step%
    fi
    show_volume_notif
    ;;

    down)
    pactl set-sink-volume @DEFAULT_SINK@ -$volume_step%
    show_volume_notif
    ;;

    mute)
    pactl set-sink-mute @DEFAULT_SINK@ toggle
    show_volume_notif
    ;;
esac
