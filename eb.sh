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

if [[ "${HOST1}:${PORT1}" == *"eb"* ]] && [[ "${HOST1}:${PORT1}" == *"/"* ]] ; then
  sshpass -f sshpass.txt ssh "${HOST1}" << EOF
    sh int ${PORT1} | inc protocol
    sh int ${PORT1} | inc link status
    sh int ${PORT1} | inc error
    sh lldp neighbor ${PORT1}
    sh int ${PORT1}
    sh int ${PORT1} transceiver detail
EOF
fi

# Z-END

if [[ "${HOST2}:${PORT2}" == *"eb"* ]] && [[ "${HOST2}:${PORT2}" == *"/"* ]] ; then
  sshpass -f sshpass.txt ssh "${HOST2}" << EOF
    sh int ${PORT2} | inc protocol
    sh int ${PORT2} | inc link status
    sh int ${PORT2} | inc error
    sh lldp neighbor ${PORT2}
    sh int ${PORT2}
    sh int ${PORT2} transceiver detail
EOF
fi
