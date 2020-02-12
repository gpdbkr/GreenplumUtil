#!/bin/bash

## get vip config
. /usr/local/bin/vip_env.sh

ifconfig ${VIP_INTERFACE} down
