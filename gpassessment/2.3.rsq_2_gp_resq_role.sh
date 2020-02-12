#!/bin/bash

SHELL_NM=$0
CURDIR=`pwd`
LOGDIR=$CURDIR"/"log
LOGFILE=$LOGDIR"/"$SHELL_NM".log"
mkdir -p $LOGDIR

psql  -ec " 
select rrrsqname, rrrolname 
from    gp_toolkit.gp_resq_role
order by 1, 2
" | tee $LOGFILE

