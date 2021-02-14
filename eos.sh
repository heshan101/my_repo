#!/bin/bash
#Creted by Heshan Abeywickrema
#Purpose: To get all relevant link health information 
#EG: <hostname>:Ethernetx/x/x
#Platform: Arista 7300

str="$1"

IFS=':'     # colon (:) is set as delimiter

read -ra LINK <<< "$str" # str is read into an array as tokens separated by IFS
#echo "${LINK[0]}"
#echo "${LINK[1]}"

IFS=' '     # reset to default value after usage

ssh "${LINK[0]}" << EOF
  sh int ${LINK[1]} | inc protocol
  sh int ${LINK[1]} | inc link status
  sh int ${LINK[1]} | inc error
  sh lldp neighbor ${LINK[1]}
  sh int ${LINK[1]}
  sh int ${LINK[1]}-4 transceiver detail
  clear counters ${LINK[1]}
EOF

