#!/bin/bash

SHELL_NM=$0
CURDIR=`pwd`
LOGDIR=$CURDIR"/"log
LOGFILE=$LOGDIR"/"$SHELL_NM".log"
mkdir -p $LOGDIR

psql -AXtf ./query/skew_base.sql > ./query/skew_all.sql
nohup psql -ef ./query/skew_all.sql > $LOGFILE 2>&1 &

