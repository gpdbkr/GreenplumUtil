#!/bin/bash

SHELL_NM=$0
CURDIR=`pwd`
LOGDIR=$CURDIR"/"log
LOGFILE=$LOGDIR"/"$SHELL_NM".log"
mkdir -p $LOGDIR

psql -ec "

select debug_query_string, user_name, sum( round(elapsed_ms/1000/60, 0)) min, count(*) cnt
from   public.sql_history
where  event_time >= '20131001'::timestamp
and    event_time <  '20131101'::timestamp
and    elapsed_ms >= 1
and    lower(debug_query_string) not in ('commit', 'begin', 'select version()', 'rollback', 'show max_identifier_length','unlisten *'
                                        , 'select 1','select 1;', 'set names ''utf8''', 'select version();' , 'set client_encoding to ''unicode'''
                                        , 'select current_date::varchar(10) as last_work_date')
and    user_name not in ('gpmon', 'gpadmin')
and    debug_query_string not like 'RELEASE%'
and    debug_query_string not like 'SAVEPOINT%'
and    debug_query_string not like 'DEALLOCATES%'
and    lower(debug_query_string) not like 'set%'
and    debug_query_string not like '%FROM pg_type WHERE oid%'
and    debug_query_string not like '%SELECT has_table_privilege%'
and    debug_query_string not like '%from information_schema.columns where%'
and    debug_query_string not like '%SELECT attname FROM pg_attribute att%' 
and    debug_query_string not like '%FROM pg_attribute%' 
group by debug_query_string, user_name
order by min desc
limit 50

" | tee  $LOGFILE


