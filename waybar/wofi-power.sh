#!/bin/bash

entries="🔒 lock\n⇠ logout\n⏾ suspend\n⭮ reboot\n⏻ shutdown"

woficmd="wofi -i \
--width 250 \
--lines 6 \
--dmenu \
--cache-file /dev/null \
--prompt action \
--define single_click=true \
"
selected=$(echo -e $entries | $woficmd | awk '{print tolower($2)}')

case $selected in
  lock)
    exec swaylock;;
  logout)
    exec hyprctl dispatch exit;;
  suspend)
    exec systemctl suspend;;
  reboot)
    exec systemctl reboot;;
  shutdown)
    exec systemctl poweroff -i;;
esac