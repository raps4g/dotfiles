#!/bin/bash

case $1 in 
    selection)
        scrot -q 100 -s --line mode=edge \
            $HOME/Screenshots/screenshot_%Y_%m_%d_%H_%M_%S.png \
            -e 'xclip -selection clipboard -t image/png -i $f'
        ;;

    full)
        scrot  -q 100 $HOME/Pictures/Screenshots/screenshot_%Y_%m_%d_%H_%M_%S.png \
            -e 'xclip -selection clipboard -t image/png -i $f'
        ;;
    delay)
        scrot  -q 100 -d 5 $HOME/Pictures/Screenshots/screenshot_%Y_%m_%d_%H_%M_%S.png \
            -e 'xclip -selection clipboard -t image/png -i $f'
        ;;
esac


