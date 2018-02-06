#!/bin/bash
echo killing blueman-applet...
killall blueman-applet -9
sleep 2
echo restarting bluetooth service...
sudo systemctrl restart bluetooth.service
sleep 2
echo starting blueman-applet...
(blueman-applet &)

