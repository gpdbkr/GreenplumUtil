#!/bin/bash

if [ $# -ne 2 ]; then
   echo "Usage: `basename $0` <interval seconds> <repeate count> "
   echo "Example for run : `basename $0` 2 5 "
   exit
fi

/data/dba/utilities/run_sys_rsc.sh $1 $2 >> /data/dba/utilities/statlog/sys.`/bin/date '+%Y%m%d'`.txt &
 
#* * * * * /bin/bash /data/dba/utilities/cron_sys_rsc.sh 5 11 & 