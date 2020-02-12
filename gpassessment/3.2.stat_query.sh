#!/bin/bash

SHELL_NM=$0
CURDIR=`pwd`
LOGDIR=$CURDIR"/"log
LOGFILE=$LOGDIR"/"$SHELL_NM".log"
mkdir -p $LOGDIR

psql -ec "

select  to_char(event_time,'YYYYMMDD') as ymd
       , case when trim(to_char(event_time,'HH24')) between '00' and '08' then '01_batch'
              when trim(to_char(event_time,'HH24')) between '09' and '12' then '02_morning'
              when trim(to_char(event_time,'HH24')) between '13' and '18' then '03_afternoon'
              else '04_etc'
         end HH
       , a.user_name
       , case when elapsed_ms <= 1000 then '01_01sec'
              when elapsed_ms <= 1*60*1000 then '02_01sec~01min'
              when elapsed_ms <= 5*60*1000 then '03_01min~05min'
              when elapsed_ms <= 10*60*1000 then '04_05min~10min'
              when elapsed_ms <= 30*60*1000 then '05_10min~30min'
              when elapsed_ms <= 60*60*1000 then '06_30min~60min'
              else '07_1hour'
         end elapsed
       , sum(1)  as cnt
       , round(sum(elapsed_ms/1000/60), 0) as elasped_min
       , round(sum(elapsed_ms/1000)/sum(1),1) as avg_elasped_s
from   (
         select event_time, user_name
                       , gp_session_id, gp_command_count, elapsed_ms, debug_query_string
         from   public.sql_history a
         where  event_time >='20110401'::timestamp
         and    elapsed_ms >= 1
         and    to_char(event_time , 'd') not in ('1', '7')
         and    substr(to_char(event_time, 'yyyymmdd'), 1, 8) not in ('20110502', '20110802', '20110811', '20110818', '20110824')
         and    lower(debug_query_string) not in ('commit', 'begin', 'select version()', 'rollback', 'show max_identifier_length','unlisten *'
                                                 , 'select 1','select 1;', 'set names \'utf8\'', 'select version();' , 'set client_encoding to \'unicode\''
                                                 , 'select current_date::varchar(10) as last_work_date')
         and    user_name not in ('gpmon', 'gpadmin')
         and    debug_query_string not like 'RELEASE%'
         and    debug_query_string not like 'SAVEPOINT%'
         and    debug_query_string not like 'DEALLOCATES%'
         and    lower(debug_query_string) not like 'set%'
         and    debug_query_string not like '%FROM pg_type WHERE oid%'
         and    debug_query_string not like '%SELECT attname FROM pg_attribute att%' 
         and    debug_query_string not like '%FROM pg_attribute%' 
        ) a
group by 1,2,3,4
order by 1,2,3,4

" | tee  $LOGFILE


