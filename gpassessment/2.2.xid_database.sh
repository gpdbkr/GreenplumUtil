#!/bin/bash

SHELL_NM=$0
CURDIR=`pwd`
LOGDIR=$CURDIR"/"log
LOGFILE=$LOGDIR"/"$SHELL_NM".log"
mkdir -p $LOGDIR

psql -ec "SELECT datname, datfrozenxid, age(datfrozenxid) FROM pg_database;" | tee $LOGFILE

echo "==================" >>  $LOGFILE
echo "" >>  $LOGFILE

gpconfig -s xid_warn_limit >> $LOGFILE
gpconfig -s xid_stop_limit >> $LOGFILE

#gpconfig -s xid_warn_limit | tee $LOGFILE
#gpconfig -s xid_stop_limit | tee $LOGFILE

