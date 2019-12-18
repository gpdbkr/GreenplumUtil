#!/bin/sh

HOST_LIST=`cat hostfile`
CMD=$1
for host in ${HOST_LIST}
do
ssh ${host} "$CMD"
done
