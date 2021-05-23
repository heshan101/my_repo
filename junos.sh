#!/bin/bash

circuit="$1"
#echo $circuit

HOST1=`echo $circuit | cut -d : -f 1`
PORT1=`echo $circuit | cut -d : -f 2-`

if [[ "${HOST1}:${PORT1}" == *"dr"* ]] && [[ "${HOST1}:${PORT1}" == *"/"* ]] ; then
  sshpass -f sshpass.txt ssh "${HOST1}" << EOF
    show interfaces ${PORT1}
EOF
fi
