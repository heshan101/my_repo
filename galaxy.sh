#!/bin/bash

circuit="$1"

GHOST1=`echo $circuit | cut -d : -f 1`
ghost1=`echo $circuit | cut -d : -f 2-`
GPORT1=`echo $ghost1 | cut -d - -f 1`
gport1=`echo $ghost1 | cut -d - -f 2-`
GHOST2=`echo $gport1 | cut -d : -f 1`
GPORT2=`echo $gport1 | cut -d : -f 2-`


IFS='.'     # period (.) is set as delimiter
read -ra GNODE <<< "$GHOST1" # host is read into an array as tokens separated by IFS
IFS=' '     # reset to default value after usage


IFS='/'     # forward-slash (/) is set as delimiter
read -ra GPORT <<< "$GPORT1" # host is read into an array as tokens separated by IFS
#echo "${PORT[0]:3}"
IFS=' '     # reset to default value after usage

if [[ "${GHOST1}:" == *"fsw"* ]] && [[ "${GPORT[0]:3}" -ge 100 ]] ; then

  fboss -H ${GNODE[0]}-lc${GPORT[0]:3}.${GNODE[1]}.${GNODE[2]}.${GNODE[3]} port details ${GPORT[0]}/${GPORT[1]}/${GPORT[2]} | egrep 'Interface Flaps|Time Interval:|Ingress|Egress|Errors|rsw|fsw|Name|ID|Description|Admin State|Link State|Speed|Vendor|Serial|Temperature|Channel|Tx Bias\(mA\) |Rx Power\(mW\) '
  fboss -H ${GNODE[0]}-lc${GPORT[0]:3}.${GNODE[1]}.${GNODE[2]}.${GNODE[3]} port trans show ${GPORT[0]}/${GPORT[1]}/${GPORT[2]} | egrep 'Interface Flaps|Time Interval:|Ingress|Egress|Errors|rsw|fsw|Name|ID|Description|Admin State|Link State|Speed|Vendor|Serial|Temperature|Channel|Tx Bias\(mA\) |Rx Power\(mW\) '
  fboss -H ${GNODE[0]}-lc${GPORT[0]:3}.${GNODE[1]}.${GNODE[2]}.${GNODE[3]} port stats clear ${GPORT[0]}/${GPORT[1]}/${GPORT[2]}
fi


