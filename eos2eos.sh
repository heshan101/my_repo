#!/bin/bash

circuit="$1"

HOST1=`echo $circuit | cut -d : -f 1`
host1=`echo $circuit | cut -d : -f 2-`
PORT1=`echo $host1 | cut -d - -f 1`
port1=`echo $host1 | cut -d - -f 2-`
HOST2=`echo $port1 | cut -d : -f 1`
PORT2=`echo $port1 | cut -d : -f 2-`



if [[ "${HOST1}:${PORT1}" == *"Ethernet"* ]] && [[ "${HOST1}:${PORT1}" == *"/"* ]] ; then
  ssh "${HOST1}" << EOF
    sh int ${PORT1} | inc protocol
    sh int ${PORT1} | inc link status
    sh int ${PORT1} | inc error
    sh lldp neighbor ${PORT1}
    sh int ${PORT1}
    sh int ${PORT1}-4 transceiver detail
    clear counters ${PORT1}
EOF

elif [[ "${HOST1}:${PORT1}" == *"Ethernet"* ]] ; then
  ssh "${HOST1}" << EOF
    sh int ${PORT1} | inc protocol
    sh int ${PORT1} | inc link status
    sh int ${PORT1} | inc error
    sh lldp neighbor ${PORT1}
    sh int ${PORT1}
    sh int ${PORT1} transceiver detail
    clear counters ${PORT1}
EOF
fi

#############################################################################################

if [[ "${HOST2}:${PORT2}" == *"Ethernet"* ]] && [[ "${HOST2}:${PORT2}" == *"/"* ]] ; then
  ssh "${HOST2}" << EOF
    sh int ${PORT2} | inc protocol
    sh int ${PORT2} | inc link status
    sh int ${PORT2} | inc error
    sh lldp neighbor ${PORT2}
    sh int ${PORT2}
    sh int ${PORT2}-4 transceiver detail
    clear counters ${PORT2}
EOF

elif [[ "${HOST2}:${PORT2}" == *"Ethernet"* ]] ; then
  ssh "${HOST2}" << EOF
    sh int ${PORT2} | inc protocol
    sh int ${PORT2} | inc link status
    sh int ${PORT2} | inc error
    sh lldp neighbor ${PORT2}
    sh int ${PORT2}
    sh int ${PORT2} transceiver detail
    clear counters ${PORT2}
EOF
fi
