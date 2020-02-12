#!/bin/bash

SHELL_NM=$0
CURDIR=`pwd`
LOGDIR=$CURDIR"/"log
LOGFILE=$LOGDIR"/"$SHELL_NM".log"
mkdir -p $LOGDIR

psql -ec "
SELECT st.schemaname
       , round(sum(pg_relation_size(st.relid)) / 1024::bigint::numeric/ 1024) AS tb_mb
       , round(sum(pg_total_relation_size(st.relid)) / 1024::bigint::numeric/ 1024) AS tb_tot_mb
 FROM pg_stat_all_tables st
 JOIN pg_class cl ON cl.oid = st.relid
WHERE st.schemaname !~~ 'pg_temp%'::text AND st.schemaname <> 'pg_toast'::name AND cl.relkind <> 'i'::\"char\"
GROUP BY 1
ORDER BY 1
" | tee  $LOGFILE


