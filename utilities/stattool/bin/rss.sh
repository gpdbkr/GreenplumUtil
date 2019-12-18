#!/bin/bash
. /data/dba/.bashrc
i=0
while [ $i -lt $2 ]
do
date '+%Y-%m-%d %H:%M:%S'
psql -c "select a.rsqname, a.rsqcountlimit as countlimit, a.rsqcountvalue as countvalue, a.rsqwaiters as waiters, a.rsqholders as running ,a.rsqcostlimit as costlimit, a.rsqcostvalue as costvalue, b.rsqignorecostlimit as ignorecostlimit, b.rsqovercommit as overcommit from pg_resqueue_status a, pg_resqueue b where a.rsqname =b.rsqname order by 1;" 
sleep $1
i=`expr $i + 1`
#echo $i
done
