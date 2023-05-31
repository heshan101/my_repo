#!/bin/bash

read -p "Enter task number: " task
read -p "Enter duration: " duration
read -p "Enter device & port: " interface

looperino start --task $task --duration $duration --type Terminjector $interface
#looperino start --task $1 --duration $2 --type Terminjector $3
