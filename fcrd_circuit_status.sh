#!/bin/bash
#cmds for bulk diagnose

FILE=$1
  while read LINE; do
    echo "$LINE"
    echo "$LINE" | sed "s/:/ /g" | awk '{ system("fcr --device=" $1 "  --commands=\"show interface " $2 "\"") }'
    echo "$LINE" | sed "s/:/ /g" | awk '{ system("fcr --device=" $1 "  --commands=\"show trans " $2 "\"") }'
      done < $FILE
