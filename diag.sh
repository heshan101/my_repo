#!/bin/bash

circuit="$1"

HOST1=`echo $circuit | cut -d : -f 1`
host1=`echo $circuit | cut -d : -f 2-`
PORT1=`echo $host1 | cut -d - -f 1`
port1=`echo $host1 | cut -d - -f 2-`
HOST2=`echo $port1 | cut -d : -f 1`
PORT2=`echo $port1 | cut -d : -f 2-`

########################################################################

  # GALAXY 

IFS='.'     # period (.) is set as delimiter
read -ra GNODE1 <<< "$HOST1" # host is read into an array as tokens separated by IFS
IFS=' '     # reset to default value after usage

IFS='.'     # period (.) is set as delimiter
read -ra GNODE2 <<< "$HOST2" # host is read into an array as tokens separated by IFS
IFS=' '     # reset to default value after usage

IFS='/'     # forward-slash (/) is set as delimiter
read -ra GPORT1 <<< "$PORT1" # port is read into an array as tokens separated by IFS
IFS=' '     # reset to default value after usage

IFS='/'     # forward-slash (/) is set as delimiter
read -ra GPORT2 <<< "$PORT2" # port is read into an array as tokens separated by IFS
IFS=' '     # reset to default value after usage

########################################################################

# A-END
echo ""
echo "    HOSTNAME / PORT : $HOST1:$PORT1"
echo ""

if [[ "${HOST1}" == *"ma"* ]] ; then
  ssh "${HOST1}" << EOF
    sh int ${PORT1} | inc protocol
    sh int ${PORT1} | inc link status
    sh int ${PORT1} | inc error
    sh lldp neighbor ${PORT1}
    sh int ${PORT1}
    sh int ${PORT1} transceiver detail
EOF

elif [[ "${HOST1}:${PORT1}" == *"Ethernet"* ]] && [[ "${HOST1}:${PORT1}" == *"/"* ]] ; then
  ssh "${HOST1}" << EOF
    sh int ${PORT1} | inc protocol
    sh int ${PORT1} | inc link status
    sh int ${PORT1} | inc error
    sh lldp neighbor ${PORT1}
    sh int ${PORT1}
    sh int ${PORT1}-4 transceiver detail
EOF

elif [[ "${HOST1}:${PORT1}" == *"Ethernet"* ]] ; then
  ssh "${HOST1}" << EOF
    sh int ${PORT1} | inc protocol
    sh int ${PORT1} | inc link status
    sh int ${PORT1} | inc error
    sh lldp neighbor ${PORT1}
    sh int ${PORT1}
    sh int ${PORT1} transceiver detail
EOF

elif [[ "${HOST1}:" == *"fsw"* ]] && [[ "${GPORT1[0]:3}" -ge 100 ]] ; then
  fboss -H ${GNODE1[0]}-lc${GPORT1[0]:3}.${GNODE1[1]}.${GNODE1[2]}.${GNODE1[3]} port details ${GPORT1[0]}/${GPORT1[1]}/${GPORT1[2]} | egrep 'Interface Flaps|Time Interval:|Ingress|Egress|Errors|rsw|fsw|Name|ID|Description|Admin State|Link State|Speed|Vendor|Serial|Temperature|Channel|Tx Bias\(mA\) |Rx Power\(mW\) '
  fboss -H ${GNODE1[0]}-lc${GPORT1[0]:3}.${GNODE1[1]}.${GNODE1[2]}.${GNODE1[3]} port trans show ${GPORT1[0]}/${GPORT1[1]}/${GPORT1[2]} | egrep 'Interface Flaps|Time Interval:|Ingress|Egress|Errors|rsw|fsw|Name|ID|Description|Admin State|Link State|Speed|Vendor|Serial|Temperature|Channel|Tx Bias\(mA\) |Rx Power\(mW\) '

elif [[ "$HOST1" == *"fa"* ]] || [[ "${HOST1}" == *"rsw"* ]] || [[ "${HOST1}" == *"ssw"* ]] || [[ "${HOST1}" == *"fsw"* ]] ; then
  fboss -H ${HOST1} port details ${PORT1} | egrep "Interface Flaps|Time Interval:|Ingress|Egress|Errors|rsw|fsw|Name|ID|Description|Admin State|Link State|Speed|Vendor|Serial|Temperature|Channel|Tx Bias\(mA\) |Rx Power\(mW\) "
  fboss -H ${HOST1} port trans show ${PORT1} | egrep "Interface Flaps|Time Interval:|Ingress|Egress|Errors|rsw|fsw|Name|ID|Description|Admin State|Link State|Speed|Vendor|Serial|Temperature|Channel|Tx Bias\(mA\) |Rx Power\(mW\) "
fi


########################################################################

echo ""
echo ""
echo ""

# Z-END
echo "    HOSTNAME / PORT : $HOST2:$PORT2"
echo ""

if [[ "${HOST2}:${PORT2}" == *"ma"* ]] ; then
  ssh "${HOST2}" << EOF
    sh int ${PORT2} | inc protocol
    sh int ${PORT2} | inc link status
    sh int ${PORT2} | inc error
    sh lldp neighbor ${PORT2}
    sh int ${PORT2}
    sh int ${PORT2} transceiver detail
EOF

elif [[ "${HOST2}:${PORT2}" == *"Ethernet"* ]] && [[ "${HOST2}:${PORT2}" == *"/"* ]] ; then
  ssh "${HOST2}" << EOF
    sh int ${PORT2} | inc protocol
    sh int ${PORT2} | inc link status
    sh int ${PORT2} | inc error
    sh lldp neighbor ${PORT2}
    sh int ${PORT2}
    sh int ${PORT2}-4 transceiver detail
EOF

elif [[ "${HOST2}:${PORT2}" == *"Ethernet"* ]] ; then
  ssh "${HOST2}" << EOF
    sh int ${PORT2} | inc protocol
    sh int ${PORT2} | inc link status
    sh int ${PORT2} | inc error
    sh lldp neighbor ${PORT2}
    sh int ${PORT2}
    sh int ${PORT2} transceiver detail
EOF

elif [[ "${HOST2}" == *"fsw"* ]] && [[ "${GPORT2[0]:3}" -ge 100 ]] ; then
 fboss -H ${GNODE2[0]}-lc${GPORT2[0]:3}.${GNODE2[1]}.${GNODE2[2]}.${GNODE2[3]} port details ${GPORT2[0]}/${GPORT2[1]}/${GPORT2[2]} | egrep 'Interface Flaps|Time Interval:|Ingress|Egress|Errors|rsw|fsw|Name|ID|Description|Admin State|Link State|Speed|Vendor|Serial|Temperature|Channel|Tx Bias\(mA\) |Rx Power\(mW\) '
  fboss -H ${GNODE2[0]}-lc${GPORT2[0]:3}.${GNODE2[1]}.${GNODE2[2]}.${GNODE2[3]} port trans show ${GPORT2[0]}/${GPORT2[1]}/${GPORT2[2]} | egrep 'Interface Flaps|Time Interval:|Ingress|Egress|Errors|rsw|fsw|Name|ID|Description|Admin State|Link State|Speed|Vendor|Serial|Temperature|Channel|Tx Bias\(mA\) |Rx Power\(mW\) '

elif [[ "$HOST2" == *"fa"* ]] || [[ "${HOST2}" == *"rsw"* ]] || [[ "${HOST2}" == *"ssw"* ]] || [[ "${HOST2}" == *"fsw"* ]] ; then
  fboss -H ${HOST2} port details ${PORT2} | egrep "Interface Flaps|Time Interval:|Ingress|Egress|Errors|rsw|fsw|Name|ID|Description|Admin State|Link State|Speed|Vendor|Serial|Temperature|Channel|Tx Bias\(mA\) |Rx Power\(mW\) "
  fboss -H ${HOST2} port trans show ${PORT2} | egrep "Interface Flaps|Time Interval:|Ingress|Egress|Errors|rsw|fsw|Name|ID|Description|Admin State|Link State|Speed|Vendor|Serial|Temperature|Channel|Tx Bias\(mA\) |Rx Power\(mW\) "

fi

