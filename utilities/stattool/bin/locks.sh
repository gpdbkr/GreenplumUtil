#!/bin/bash
. /data/dba/.bashrc
i=0
while [ $i -lt $2 ]
do
date '+%Y-%m-%d %H:%M:%S'
psql -c " SELECT pid, relname, locktype, mode, a.gp_segment_id from pg_locks a, pg_class where relation=oid and relname not like 'pg_%' order by 3;" 
sleep $1
i=`expr $i + 1`
#echo $i
done
