#!/bin/bash

#dru $1 $2 >output.log 2>&1 &

drainer undrain job:"$1" --task "$2" --tail -y > output.log 2>&1 &
