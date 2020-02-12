#!/bin/bash

SHELL_NM=$0
CURDIR=`pwd`
LOGDIR=$CURDIR"/"log
LOGFILE=$LOGDIR"/"$SHELL_NM".log"
mkdir -p $LOGDIR

psql  -ec " select rsqname, rsqcountlimit cntlimit, rsqcountvalue cntval, rsqcostlimit costlimit, rsqcostvalue costval, rsqmemorylimit memlimit, rsqmemoryvalue memval, rsqwaiters waiters, rsqholders holders from gp_toolkit.gp_resqueue_status order by 1" | tee $LOGFILE

