#!/bin/bash
#cmds for bulk diagnose
FILE=$1
while read LINE; do
  serf get name=$LINE --fields name,location
    done < $FILE
