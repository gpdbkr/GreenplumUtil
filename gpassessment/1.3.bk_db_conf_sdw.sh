#!/bin/bash

SHELL_NM=$0
CURDIR=`pwd`
CONFDIR=$CURDIR"/"conf
mkdir -p $CONFDIR

HOSTNM=`head -2 ./log/1.1.segment_config.sh.log.sum | tail -1 | awk -F"|" '{print $1}'`

CONFPATH=`head -2 ./log/1.1.segment_config.sh.log.sum | tail -1 | awk -F"|" '{print $2}'
`
echo $HOSTNM
echo $CONFPATH
scp $HOSTNM:$CONFPATH/postgresql.conf $CONFDIR"/"$HOSTNM"_"postgresql.conf
scp $HOSTNM:$CONFPATH/pg_hba.conf $CONFDIR"/"$HOSTNM"_"pg_hba.conf

