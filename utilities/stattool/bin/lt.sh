#!/bin/bash
. /data/dba/.bashrc
i=0
while [ $i -lt $2 ]
do
date '+%Y-%m-%d %H:%M:%S'
psql -c "SELECT distinct w.locktype, w.relation::regclass AS relation, w.mode, w.pid as waiting_pid, other.pid as running_pid, w.gp_segment_id FROM pg_catalog.pg_locks AS w JOIN pg_catalog.pg_stat_activity AS w_stm ON (w_stm.pid = w.pid) JOIN pg_catalog.pg_locks AS other ON ((w.DATABASE = other.DATABASE AND w.relation = other.relation) OR w.transactionid = other.transactionid) JOIN pg_catalog.pg_stat_activity AS other_stm ON (other_stm.pid = other.pid) WHERE NOT w.granted and w.pid <> other.pid;"
sleep $1
i=`expr $i + 1`
#echo $i
done
