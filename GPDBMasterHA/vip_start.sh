#!/bin/bash

## get vip configure
. /usr/local/bin/vip_env.sh

ifconfig  ${VIP_INTERFACE} ${VIP}  netmask ${VIP_NETMASK} up
arping -f -w 10 -s ${VIP}  -U ${VIP_GW} -I ${ARPING_INTERFACE}
