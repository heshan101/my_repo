#!/bin/bash

HOST1=${1%-*}
HOST2=${1#*-}
  
echo "$HOST1:$PORT" | sed "s/:/ /g" | awk '{ system("fcr --device=" $1 "  --commands=\"show interface " $2 "\"") }'
  echo "$HOST1" | sed "s/:/ /g" | awk '{ system("fcr --device=" $1 "  --commands=\"show trans " $2 "\"") }'
  echo "$HOST2" | sed "s/:/ /g" | awk '{ system("fcr --device=" $1 "  --commands=\"show interface " $2 "\"") }'
  echo "$HOST2" | sed "s/:/ /g" | awk '{ system("fcr --device=" $1 "  --commands=\"show trans " $2 "\"") }'

