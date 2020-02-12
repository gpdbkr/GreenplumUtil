#!/bin/bash

SHELL_NM=$0
CURDIR=`pwd`
LOGDIR=$CURDIR"/"log
LOGFILE=$LOGDIR"/"$SHELL_NM".log"
mkdir -p $LOGDIR

psql -ec "select coalesce(datname, 'Total') database_name, sum(round(pg_database_size(datname)/1024.0/1024/1024, 1)) db_size_gb from pg_database group by rollup(datname);" | tee  $LOGFILE


