#!/bin/bash
echo "Run gitlab runner"  >> ~/log.txt
echo $(date) >> ~/log.txt
sudo systemctl start gitlab-runner&

echo "Run lock"  >> ~/log.txt
echo $(date) >> ~/log.txt
sh ~/.dotfiles/hypr/swaylock.sh >> ~/log.txt

echo "stop gitlab runner"  >> ~/log.txt
echo $(date) >> ~/log.txt
sudo systemctl stop gitlab-runner&
