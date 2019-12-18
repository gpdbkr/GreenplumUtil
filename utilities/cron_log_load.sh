#!/bin/bash

yesterday=`TZ=aaa24 date +%Y-%m-%d`

if [ $# -ne 1 ]
then
     date=$yesterday
else
     date=${1}
fi
echo $date

cd /data/dba/utilities/

source ~/.bash_profile
date > /data/dba/utilities/cron_log_load.out
/data/dba/utilities/cron_log_load.sql $date >> /data/dba/utilities/cron_log_load.out 2>&1
date >> /data/dba/utilities/cron_log_load.out


