#! /bin/bash
#tmux select-pane -t docker-bind:0.1
#tmux send-keys -t docker-bind:0.1 'dig +timeout=11 +tries=1 test'$1'.goertzen' Enter
#sleep 10
#tmux capture-pane -t docker-bind:0.1 -pS - > dig_logs/run_$1.log
#tmux send-keys -t docker-bind:0.1 -R Enter
#tmux clear-history -t docker-bind:0.1
echo "xxxxxxxxxxxxxx ERROR SAFE2 xxxxxxxxxxxxxx"
