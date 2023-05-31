#!/bin/bash

sshpass -f sshpass.txt ssh "$1" << EOF
  show logging system | gzip > /mnt/flash/$1-log-sys-$(date +%Y:%m:%d_%H:%M).gz
  bash sudo dmesg -T | gzip > /mnt/flash/$1-dmesg-$(date +%Y:%m:%d_%H:%M).gz
  bash sudo cat /var/log/agents/* | gzip > /mnt/flash/$1-agent-log-$(date +%Y:%d:%m_%H:%M).gz
  show tech-support | gzip > /mnt/flash/$1-tech-support-$(date +%Y:%d:%m_%H:%M).gz
EOF
