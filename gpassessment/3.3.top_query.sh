#!/bin/bash

SHELL_NM=$0
CURDIR=`pwd`
LOGDIR=$CURDIR"/"log
LOGFILE=$LOGDIR"/"$SHELL_NM".log"
mkdir -p $LOGDIR

psql -ec "

select event_time, user_name
      , gp_session_id, gp_command_count, round(elapsed_ms/1000/60, 0) min, debug_query_string
from   public.sql_history
where  event_time >= '20141201'::timestamp
--and  event_time < '20131101'::timestamp
and    elapsed_ms >= 1*60*1000
order by elapsed_ms desc
limit 50

" | tee  $LOGFILE


