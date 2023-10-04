#!/bin/bash

brightness_step=5
timeout=1000

function get_brightness {
    brightnessctl -m | awk -F, '{print substr($4, 0, length($4)-1)}'
}

function show_brightness_notif {
    brightness=$(get_brightness)
    brightness_icon=""
    tag=brightness_notif
    summ=" "
    body_icon="<span font='Font Awesome 6 Free Solid 12'>$brightness_icon</span>"
    body_text="<span font='Ubuntu Light 12'>$brightness%</span>"
    body="$body_icon $body_text"
    notify-send -t $timeout -h string:x-dunst-stack-tag:$tag\
        -h int:value:$brightness "$summ" "$body"
}

case $1 in
    up)
    brightnessctl set $brightness_step%+ 
    show_brightness_notif
    ;;

    down)
    brightnessctl set $brightness_step%- 
    show_brightness_notif
    ;;
esac

