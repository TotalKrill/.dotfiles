#!/bin/sh

pid=$(niri msg -j focused-window | jq '.pid')
ppid=$(pgrep --newest --parent "$pid")
dir=$(readlink /proc/"$ppid"/cwd || echo "$HOME")
[ -d "$dir" ] && echo "$dir" || echo "$HOME"
