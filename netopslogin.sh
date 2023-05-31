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

IFS='/'     # forward-slash (/) is set as delimiter
read -ra GPORT1 <<< "$PORT1" # port is read into an array as tokens separated by IFS
IFS=' '     # reset to default value after usage

########################################################################

# A-END
echo ""
echo "    HOSTNAME / PORT : $HOST1:$PORT1"
echo ""

if [[ "${HOST1}:" == *"fsw"* ]] && [[ "${GPORT1[0]:3}" -ge 100 ]] ; then
  echo "${PORT1}"
  ssh netops@${GNODE1[0]}-lc${GPORT1[0]:3}.${GNODE1[1]}.${GNODE1[2]}.${GNODE1[3]}
elif [[ "$HOST1" == *"fa"* ]] || [[ "${HOST1}" == *"rsw"* ]] || [[ "${HOST1}" == *"ssw"* ]] || [[ "${HOST1}" == *"fsw"* ]] ; then
  echo "${PORT1}"
  ssh netops@${HOST1}
else
  continue
fi

########################################################################

