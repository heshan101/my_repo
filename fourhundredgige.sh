#!/bin/bash

circuit="$1"

HOST1=`echo $circuit | cut -d : -f 1`
host1=`echo $circuit | cut -d : -f 2-`
PORT1=`echo $host1 | cut -d - -f 1`
port1=`echo $host1 | cut -d - -f 2-`
HOST2=`echo $port1 | cut -d : -f 1`
PORT2=`echo $port1 | cut -d : -f 2-`

########################################################################

# A-END
echo ""
echo "    HOSTNAME / PORT : $HOST1:$PORT1"
echo ""

sshpass -f sshpass.txt ssh ${HOST1} "show interfaces ${PORT1}"

# Z-END
echo ""
echo "    HOSTNAME / PORT : $HOST2:$PORT2"
echo ""

if [[ "$HOST2" == *"fa"* ]] || [[ "${HOST2}" == *"rsw"* ]] || [[ "${HOST2}" == *"rtsw"* ]] || [[ "${HOST2}" == *"ssw"* ]] || [[ "${HOST2}" == *"fsw"* ]] ; then
  fboss -H ${HOST2} port details ${PORT2} | egrep "Interface Flaps|Time Interval:|Ingress|Egress|Errors|rsw|fsw|Name|ID|Description|Admin State|Link State|Speed|Vendor|Serial|Temperature|Channel|Tx Bias\(mA\) |Rx Power\(mW\) "
  fboss -H ${HOST2} port trans show ${PORT2} | egrep "Interface Flaps|Time Interval:|Ingress|Egress|Errors|rsw|fsw|Name|ID|Description|Admin State|Link State|Speed|Vendor|Serial|Temperature|Channel|Tx Bias\(mA\) |Rx Power\(mW\) "

fi
