#!/bin/bash

circuit="$1"

HOST1=`echo $circuit | cut -d : -f 1`
host1=`echo $circuit | cut -d : -f 2-`
PORT1=`echo $host1 | cut -d - -f 1`
port1=`echo $host1 | cut -d - -f 2-`
HOST2=`echo $port1 | cut -d : -f 1`
PORT2=`echo $port1 | cut -d : -f 2-`

########################################################################


sshpass -f sshpass.txt ssh "${HOST1}" << EOF
  show int ${PORT1}
  show int ${PORT1} phy detail | inc Ethernet
  show int ${PORT1} phy detail | inc Current State
  show int ${PORT1} phy detail | inc -------------
  show int ${PORT1} phy detail | inc PHY
  show int ${PORT1} phy detail | inc Interface
  show int ${PORT1} phy detail | inc MAC
  show int ${PORT1} phy detail | inc PCS
EOF
