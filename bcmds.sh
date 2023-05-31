#!/bin/bash
#cmds for bulk diagnose

FILE=$1
  while read -r line; do netresort force_close -rt $line --reason 'ticket not closing' ; done < alist.txt
