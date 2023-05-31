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


tcvrid=$(fboss -H ${HOST1} port state show ${PORT1} | grep "${PORT1}" | awk -F ' ' '{print $6}')
#echo $tcvrid


hard_reset=$(echo "$(($tcvrid+1))")
#echo $hard_reset


if [[ "${HOST1}:${PORT1}" == *"Ethernet"* ]] && [[ "${HOST1}:${PORT1}" == *"/"* ]] ; then
  sshpass -f sshpass.txt ssh "${HOST1}" << EOF
    conf t
    int ${PORT1}
    shut
    no shut
    end
EOF


elif [[ "$HOST1" == [[*"fa"*]] || [[*"rsw"*]] || [[*"rtsw"*]] || [[*"ssw"*]] || [[*"fsw"*]] ]]; then
  ssh netops@${HOST1} << EOF
    sudo wedge_qsfp_util -qsfp_hard_reset $hard_reset
EOF

fi
