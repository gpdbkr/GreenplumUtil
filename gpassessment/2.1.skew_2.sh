#!/bin/bash

SHELL_NM=$0
CURDIR=`pwd`
LOGDIR=$CURDIR"/"log
LOGFILE=$LOGDIR"/"$SHELL_NM".log"
mkdir -p $LOGDIR

echo "SKEW Percent : 20"
echo "Searching minimun rows : 1,000,000"
sleep 3
#read SKEW_PCT
#echo $SKEW_PCT
#read ROWS
#echo $ROWS

grep "|" $LOGDIR/2.1.skew_1.sh.log | grep -v tb_nm | awk -F"|" '$6>20 {print$0}' | awk -F"|" '$2>1000000 {print$0}' | tee $LOGFILE
