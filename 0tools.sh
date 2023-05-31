#!/bin/bash

#for i in ***** ; do feature install $i --persist & done

FILE=$1
	while read -r line; do feature install $line & done < 0tool_list.txt