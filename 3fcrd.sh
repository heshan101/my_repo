#!/bin/bash

echo "${1}" | sed "s/:/ /g" | awk '{ system("fcr --device=" $1 "  --commands=\"show interface " $2 "\"") }'
echo "${1}" | sed "s/:/ /g" | awk '{ system("fcr --device=" $1 "  --commands=\"show trans " $2 "\"") }'
