#!/bin/sh


HOST_LIST=`cat hostfile`
SFILE=$1
TFILE=$2
for host in ${HOST_LIST}
do
scp $SFILE ${host}:$TFILE
done

