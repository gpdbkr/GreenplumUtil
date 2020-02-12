#!/bin/bash

SHELL_NM=$0
CURDIR=`pwd`
LOGDIR=$CURDIR"/"log
LOGFILE=$LOGDIR"/"$SHELL_NM".log"
mkdir -p $LOGDIR

gpstate -c > $LOGFILE 2>&1
cat $LOGFILE |  grep Primary |  awk '{print $8"|"$9"|"$10"|"$11"|"$12"|"$13}' | tee $LOGFILE".sum"
