#!/usr/bin/env bash

ticket="resortcli get status=Undiagnosed team_type=~ENS owner_fbid=504068491,628128190,100055810847608,1025965358,1032504702 --fields ticket_number --csv"

$ticket | grep [0-9] > /home/habeywickrema/ens_systemd_timers.txt
cat /home/habeywickrema/ens_systemd_timers.txt
cat /home/habeywickrema/ens_systemd_timers.txt | while read line; do netresort cmds -rt $line; done
