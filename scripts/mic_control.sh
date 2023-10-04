#!/bin/bash

mic_volume_step=1
max_mic_volume=100
timeout=1000

function get_mic_volume {
    pactl get-source-volume @DEFAULT_SOURCE@ | grep -Po '[0-9]{1,3}(?=%)' | head -1
}

function get_mute {
    pactl get-source-mute @DEFAULT_SOURCE@ | grep -Po '(?<=Mute: )(yes|no)'
}

function get_mic_volume_icon {
    mic_volume=$(get_mic_volume)
    mute=$(get_mute)
    if [ "$mic_volume" -eq 0 ] || [ "$mute" == "yes" ] ; then
        mic_volume_icon=""
        urgency=critical
    else
        mic_volume_icon=""
        urgency=normal
    fi
}

function show_mic_volume_notif {
    get_mic_volume_icon
    bar_value=$( bc -l <<< "scale=0; ${mic_volume}*100/${max_mic_volume}" )
    tag=mic_volume_notif
    summ=" "
    body_icon="<span font='Font Awesome 5 Free Solid 12'>$mic_volume_icon </span>"
    body_text="<span font='Ubuntu Light 12'>$mic_volume%</span>"
    body="$body_icon $body_text"
    notify-send -t $timeout -h string:x-dunst-stack-tag:$tag\
        -u $urgency -h int:value:$bar_value "$summ" "$body" 
}

case $1 in
    up)
    pactl set-source-mute @DEFAULT_SOURCE@ 0
    mic_volume=$(get_mic_volume)
    if [ $(( "$mic_volume" + "$mic_volume_step" )) -gt $max_mic_volume ]; then
        pactl set-source-volume @DEFAULT_SOURCE@ $max_mic_volume%
    else
        pactl set-source-volume @DEFAULT_SOURCE@ +$mic_volume_step%
    fi
    show_mic_volume_notif
    ;;

    down)
    pactl set-source-volume @DEFAULT_SOURCE@ -$mic_volume_step%
    show_mic_volume_notif
    ;;

    mute)
    pactl set-source-mute @DEFAULT_SOURCE@ toggle
    show_mic_volume_notif
    ;;
esac
