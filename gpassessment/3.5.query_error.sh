#!/bin/bash

SHELL_NM=$0
CURDIR=`pwd`
LOGDIR=$CURDIR"/"log
LOGFILE=$LOGDIR"/"$SHELL_NM".log"
mkdir -p $LOGDIR

psql -ec "
select dtl_msg error_aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa, count(*)
from   public.sql_history a
where  event_time >='20131001'::timestamp
and   state_cd <> '00000'
and   dtl_msg not like '%column % does not exist%'
and   dtl_msg not like '%syntax error at or near%'
and   dtl_msg not like '%current transaction is aborted, commands ignored until end of transaction block%'
and   dtl_msg not like '%there is no transaction in progress%'
and   dtl_msg not like '%relation % does not exist%'
and   dtl_msg not like '%permission denied for schema%'
and   dtl_msg not like '%syntax error at end of input%'
and   dtl_msg not like '%nonstandard use of % literal%'
and   dtl_msg not like '%permission denied for schema%'
and   dtl_msg not like '%subquery in FROM must have an alias%'
and   dtl_msg not like '%unterminated quoted identifier at or near %'
and   dtl_msg not like '%permission denied for schema%'
and   dtl_msg not like '%operator does not exist: <> integer%'
and   dtl_msg not like '%Any temporary tables for this session%'
and   dtl_msg not like '%value too long for type%'
and   dtl_msg not like '%unterminated quoted string at or nea%'
and   dtl_msg not like '%column%hastype%unknown%'
and   dtl_msg not like '%must appear in the GROUP BY clause or be used in an aggregate function%'
and   dtl_msg not like '%does not exist%'
and   dtl_msg not like '%invalid input syntax %'
group by 1
having count(*) > 5
order by 2 desc
limit 100

" | tee  $LOGFILE


