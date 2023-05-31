#!/bin/bash

# if no arguments are provided, return usage function
for arg in "$@"; do
    case $arg in
    -f | --fan)
        fboss -H $1 bmc fan
        ;;
    -p | --power)
        fboss -H $1 bmc power
        ;;
    -t | --temp)
        fboss -H $1 bmc temp
        ;;
    *)
        echo 'run "fboss -H bmc -h" for options' # run usage function if wrong argument provided
        echo './bmc.sh <hostname> -f | -p | -t'
        ;;
    esac
done
