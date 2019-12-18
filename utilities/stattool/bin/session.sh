#!/bin/bash
. /data/dba/.bashrc
i=0
while [ $i -lt $2 ]
do
psql -At -c "select to_char(now(), 'yyyy-mm-dd hh24:mi:ss'), count(*) t_cnt from pg_stat_activity  where state = 'idle' ;"
sleep $1
i=`expr $i + 1`
#echo $i
done
