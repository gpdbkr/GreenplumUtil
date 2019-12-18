#!/bin/bash

. /data/dba/.bash_profile

## testdb
psql -AXtc "select to_char(now(),'yyyymmdd') log_dt, schema_nm, tb_nm, tb_pt_nm, tb_kb, tb_tot_kb From   dba.v_tb_pt_size;" > /data/dba/utilities/cron_tb_size.out
psql <<! 
delete from dba.tb_size where log_dt = to_char(now(), 'yyyymmdd');
\copy dba.tb_size  from '/data/dba/utilities/cron_tb_size.out' DELIMITER '|' null ''
!

#create table dba.tb_size
#(
#   log_dt       varchar(8),
#   schema_nm    varchar(32),
#   tb_nm        varchar(64),
#   tb_pt_nm     varchar(64),
#   tb_kb        numeric,
#   tb_tot_kb    numeric    
#)
#distributed by (schema_nm, tb_pt_nm)
#
#CREATE OR REPLACE VIEW dba.v_tb_pt_size AS 
# SELECT a.schemaname AS schema_nm, a.tb_nm, a.tb_pt_nm, a.tb_kb, a.tb_tot_kb
#   FROM ( SELECT st.schemaname
#                , split_part(st.relname::text, '_1_prt_'::text, 1) AS tb_nm
#                , st.relname AS tb_pt_nm, round(sum(pg_relation_size(st.relid)) / 1024::bigint::numeric) AS tb_kb
#                , round(sum(pg_total_relation_size(st.relid)) / 1024::bigint::numeric) AS tb_tot_kb
#           FROM pg_stat_all_tables st
#      JOIN pg_class cl ON cl.oid = st.relid
#     WHERE st.schemaname !~~ 'pg_temp%'::text AND st.schemaname <> 'pg_toast'::name AND cl.relkind <> 'i'::"char"
#     GROUP BY 1,2,3) a
#  ORDER BY a.schemaname, a.tb_nm, a.tb_pt_nm;
#
