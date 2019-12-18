psql <<!
set gp_max_csv_line_length=1000000;
--set client_encoding to utf8;
create external web temp table ext_master_logs (
        event_time timestamp with time zone,
        user_name  text,
        database_name text,
        process_id text,
        thread_id text,
        remote_host text,
        remote_port text,
        session_start_time timestamp with time zone,
        transaction_id int,
        gp_session_id text,
        gp_command_count text,
        gp_segment text,
        slice_id text,
        distr_tranx_id text,
        local_tranx_id text,
        sub_tranx_id text,
        error_severity text,
        sql_state_code text,
        error_message text,
        error_detail text,
        error_hint text,
        internal_query text,
        internal_query_pos int,
        error_context text,
        debug_query_string text,
        error_cursor_pos int,
        func_name text,
        file_name text,
        file_line int,
        stack_trace text
)
EXECUTE E'cat /data/master/gpseg-1/pg_log/gpdb-${1}*.csv' ON MASTER
FORMAT 'csv' (delimiter as ',' quote as '"')
ENCODING 'utf8'
SEGMENT REJECT LIMIT 100000;

delete from dba.sql_history 
where  event_time >= '${1}'::timestamp 
and    event_time <  '${1}'::timestamp + '1 day'::interval ;

insert into dba.sql_history
     (event_time, user_name, database_name, process_id, remote_host, session_start_time, 
      gp_session_id, gp_command_count, debug_query_string, elapsed_ms, log_tp, state_cd, dtl_msg) 
select event_time
        , substr(user_name, 1, 100)  user_name
        , substr(database_name, 1, 100) database_name
        , substr(process_id, 1, 10) process_id
        , substr(remote_host, 1, 20) remote_host
        , session_start_time
        , substr(gp_session_id, 1, 20) gp_session_id
        , substr(gp_command_count, 1, 20) gp_command_count
        , substr(debug_query_string, 1, 32000) debug_query_string
        , case when strpos(error_message, 'duration') = 0 then -1
               when split_part(error_message,':',2) not like '%ms%' then -1
               when error_message like '%ms' then split_part(split_part(error_message,':',2),'ms',1)::decimal 
               else -1
          end as elasped_ms 
       , error_severity   log_tp
       , sql_state_code   state_cd
       , substr(error_message, 1, 32000) dtl_msg
from  ext_master_logs
where event_time >= '${1}'::timestamp
and   event_time <  '${1}'::timestamp + '1 day'::interval ;
!
