#!/bin/bash

host="$1"

field1=`echo $host | cut -d . -f 1`
field2=`echo $host | cut -d . -f 2`
field3=`echo $host | cut -d . -f 3`
field4=`echo $host | cut -d . -f 4`

fping6 $1
fping6 $field1-oob.$field2.$field3.$field4
fping6 $field1-inband.$field2.$field3.$field4
[habeywickrema@devvm5855.atn0 ~ (main)]$
[habeywickrema@devvm5855.atn0 ~ (main)]$
[habeywickrema@devvm5855.atn0 ~ (main)]$ cat gal_config.sh
#!/bin/bash

serf set name=$1 status=PROVISIONABLE -m 'provision galaxy'

fboss-tools  galaxy configure $1
