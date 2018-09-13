#!/bin/bash

###############################################################################
#Coded by : Lefsec
#Version : V 0.1
#description : Script Tmux for sysadmin
#use : ./script <DOMU>
###############################################################################

echo "[***Welcome `whoami`***]";

if [[ $# != 0 ]]; then
    DOMU=$1
    SESSION=$1

tmux -2 new-session -d -s $SESSION

tmux split-window -h


tmux send-keys "ssh $DOMU" C-m
tmux send-keys "sudo htop" C-m


tmux select-pane -t 1
tmux send-keys "ssh $DOMU" C-m
tmux send-keys "tail -f /data/www/client/logs/*access.log" C-m

tmux split-window -v
tmux send-keys "ssh $DOMU" C-m
tmux send-keys "sudo tail -f /var/log/apache2/access.log | egrep -o '^[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}'" C-m 

tmux split-window -v
tmux send-keys "ssh $DOMU" C-m
tmux send-keys "sudo ps aux | grep --color cron" C-m
if [ $(ssh $DOMU "sudo ps aux | grep mysql |wc -l") -ne 0 ]; then
    tmux send-keys "echo 'SELECT * FROM information_schema.processlist ORDER BY TIME;' | sudo mysql | grep -v 'information_schema.processlist'" C-m
fi

tmux split-window -v
tmux send-keys "ssh $DOMU" C-m

tmux select-window -t $SESSION:1

tmux -2 attach-session -t $SESSION

echo "[***Bye `whoami`***]";

else
    echo "./script <DOMU>"
fi
