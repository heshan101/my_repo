#!/bin/bash

HOST1=${1%-*}
   watch "fboss -H ${HOST1/\:/ port details  } | egrep 'Interface Flaps|Time Interval:|Ingress|Egress|Errors|rsw|fsw|ssw|fa|Name|ID|Description|Admin State|Link State|Speed|Vendor|Serial|Temperature|Channel|Tx Bias\(mA\) |Rx Power\(mW\) ' ; fboss -H ${HOST1/\:/  port trans show } | egrep 'Interface Flaps|Time Interval:|Ingress|Egress|Errors|rsw|fsw|ssw|fa|Name|ID|Description|Admin State|Link State|Speed|Vendor|Serial|Temperature|Channel|Tx Bias\(mA\) |Rx Power\(mW\) '"
