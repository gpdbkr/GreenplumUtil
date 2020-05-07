CREATE OR REPLACE FUNCTION gpss_stg.udf_sync_tpch_customer() RETURNS text AS
$$
DECLARE
        v_target_tb     varchar(64);
        v_del_cnt       integer :=0 ;
        v_ins_cnt       integer :=0 ;
        v_up_cnt        integer :=0 ;

        v_min_ts        timestamp;
        v_max_ts        timestamp;
        v_start_ts      timestamp;
        v_end_ts        timestamp;

        v_result        text;
        v_err_msg       text;
        v_cdc_row_cnt   integer :=0 ;
BEGIN

v_start_ts    := clock_timestamp();
v_target_tb   := 'tpch.customer';

set random_page_cost = 1;
set enable_nestloop = on;

SELECT MIN(gpss_ts), MAX(gpss_ts) INTO v_min_ts, v_max_ts
  FROM gpss_stg.tmp_tpch_customer;

INSERT INTO gpss_stg.stg_tpch_customer
SELECT 
       gpss.json_get_num  (d,'c_custkey')
     , gpss.json_get_text (d,'c_name')
     , gpss.json_get_text (d,'c_address')
     , gpss.json_get_num  (d,'c_nationkey')
     , gpss.json_get_text (d,'c_phone')
     , gpss.json_get_num  (d,'c_acctbal')
     , gpss.json_get_text (d,'c_mktsegment')
     , gpss.json_get_text (d,'c_comment')
     , gpss.json_get_text (m, 'gpss_fg')
     , gpss_ts
  FROM gpss_stg.tmp_tpch_customer
 WHERE gpss_ts >= v_min_ts
   AND gpss_ts <= v_max_ts 
;

DELETE FROM tpch.customer a
 USING gpss_stg.stg_tpch_customer b
 where a.c_custkey                 = b.c_custkey                
   AND b.gpss_fg = 'D'
   AND b.gpss_ts >= v_min_ts
   AND b.gpss_ts <= v_max_ts;

GET DIAGNOSTICS v_del_cnt = ROW_COUNT;

INSERT INTO tpch.customer
(
  c_custkey
, c_name
, c_address
, c_nationkey
, c_phone
, c_acctbal
, c_mktsegment
, c_comment
)
WITH tmp AS
(
     SELECT *
       FROM (
             SELECT
                     c_custkey
                   , c_name
                   , c_address
                   , c_nationkey
                   , c_phone
                   , c_acctbal
                   , c_mktsegment
                   , c_comment
                   , gpss_ts
                   , gpss_fg
                   , row_number() over (partition by c_custkey
                                            order by gpss_ts desc) rnk
               from gpss_stg.stg_tpch_customer a
              where a.gpss_fg in ('I','D')
                and a.gpss_ts >= v_min_ts
                and a.gpss_ts <= v_max_ts
             ) a
       where gpss_fg = 'I'
         and rnk = 1
)
select
       a.c_custkey
     , a.c_name
     , a.c_address
     , a.c_nationkey
     , a.c_phone
     , a.c_acctbal
     , a.c_mktsegment
     , a.c_comment
  from tmp a
  left outer join tpch.customer b
    on a.c_custkey                 = b.c_custkey                
 where b.c_custkey                 is null
;

GET DIAGNOSTICS v_ins_cnt = ROW_COUNT;

WITH tmp AS
(
     SELECT *
       FROM (
             SELECT
                   c_custkey                
                 , max(c_name                   ) c_name                   
                 , max(c_address                ) c_address                
                 , max(c_nationkey              ) c_nationkey              
                 , max(c_phone                  ) c_phone                  
                 , max(c_acctbal                ) c_acctbal                
                 , max(c_mktsegment             ) c_mktsegment             
                 , max(c_comment                ) c_comment                
              from (
                     select
                              c_custkey                
                            , last_value (c_name)
                                    over (partition by c_custkey
                                              order by case when c_name
                                                                 is not null then 1 else 0 end asc
                                                     , gpss_ts rows between unbounded preceding
                                                                        and unbounded following) c_name
                            , last_value (c_address)
                                    over (partition by c_custkey
                                              order by case when c_address
                                                                 is not null then 1 else 0 end asc
                                                     , gpss_ts rows between unbounded preceding
                                                                        and unbounded following) c_address
                            , last_value (c_nationkey)
                                    over (partition by c_custkey
                                              order by case when c_nationkey
                                                                 is not null then 1 else 0 end asc
                                                     , gpss_ts rows between unbounded preceding
                                                                        and unbounded following) c_nationkey
                            , last_value (c_phone)
                                    over (partition by c_custkey
                                              order by case when c_phone
                                                                 is not null then 1 else 0 end asc
                                                     , gpss_ts rows between unbounded preceding
                                                                        and unbounded following) c_phone
                            , last_value (c_acctbal)
                                    over (partition by c_custkey
                                              order by case when c_acctbal
                                                                 is not null then 1 else 0 end asc
                                                     , gpss_ts rows between unbounded preceding
                                                                        and unbounded following) c_acctbal
                            , last_value (c_mktsegment)
                                    over (partition by c_custkey
                                              order by case when c_mktsegment
                                                                 is not null then 1 else 0 end asc
                                                     , gpss_ts rows between unbounded preceding
                                                                        and unbounded following) c_mktsegment
                            , last_value (c_comment)
                                    over (partition by c_custkey
                                              order by case when c_comment
                                                                 is not null then 1 else 0 end asc
                                                     , gpss_ts rows between unbounded preceding
                                                                        and unbounded following) c_comment
                       from gpss_stg.stg_tpch_customer
                      where gpss_fg in ('U','I')
                        AND gpss_ts >= v_min_ts
                        AND gpss_ts <= v_max_ts
                    ) a
               group by c_custkey
            ) tmp
)
update tpch.customer a
   set
        c_name                    = coalesce (b.c_name, a.c_name)
      , c_address                 = coalesce (b.c_address, a.c_address)
      , c_nationkey               = coalesce (b.c_nationkey, a.c_nationkey)
      , c_phone                   = coalesce (b.c_phone, a.c_phone)
      , c_acctbal                 = coalesce (b.c_acctbal, a.c_acctbal)
      , c_mktsegment              = coalesce (b.c_mktsegment, a.c_mktsegment)
      , c_comment                 = coalesce (b.c_comment, a.c_comment)
  from tmp b
 where a.c_custkey                 = b.c_custkey                
   and (
        a.c_name                    <> b.c_name                   
     or a.c_address                 <> b.c_address                
     or a.c_nationkey               <> b.c_nationkey              
     or a.c_phone                   <> b.c_phone                  
     or a.c_acctbal                 <> b.c_acctbal                
     or a.c_mktsegment              <> b.c_mktsegment             
     or a.c_comment                 <> b.c_comment                
       )
;

GET DIAGNOSTICS v_up_cnt = ROW_COUNT;

v_end_ts    :=  clock_timestamp();

INSERT INTO gpss.gpss_udf_exec_log
(       target_tb
      , start_ts
      , end_ts
      , stg_tot_cnt
      , stg_ins_cnt
      , stg_del_cnt
      , stg_up_cnt
      , tgt_ins_cnt
      , tgt_del_cnt
      , tgt_up_cnt 
)
select v_target_tb
     , v_start_ts
     , v_end_ts
     , sum(cnt) t_cnt
     , sum(case when gpss_fg = 'I' then cnt end) stg_ins_cnt
     , sum(case when gpss_fg = 'D' then cnt end) stg_del_cnt
     , sum(case when gpss_fg = 'U' then cnt end) stg_up_cnt
     , v_ins_cnt
     , v_del_cnt
     , v_up_cnt
  from (	   
         select gpss_fg, count(*) cnt 
           from gpss_stg.stg_tpch_customer
          where gpss_ts >= v_min_ts
            and gpss_ts <= v_max_ts
          group by gpss_fg 
       ) a 
;

delete from gpss_stg.stg_tpch_customer
 where gpss_ts >= v_min_ts
   and gpss_ts <= v_max_ts
;

delete from gpss_stg.tmp_tpch_customer
 where gpss_ts >= v_min_ts
   and gpss_ts <= v_max_ts
;

GET DIAGNOSTICS v_cdc_row_cnt = ROW_COUNT;

v_result    := 'Start: '||to_char(v_start_ts, 'yyyy-mm-dd hh24:mi:ss')||', '||
                 'End: '||to_char(v_end_ts,   'yyyy-mm-dd hh24:mi:ss') ||', '||
                'Rows: '||trim(to_char(v_cdc_row_cnt, '999,999,999,999'))||', '||
              'Insert: '||trim(to_char(v_ins_cnt,     '999,999,999,999'))||', '||
              'Delete: '||trim(to_char(v_del_cnt,     '999,999,999,999'))||', '||
              'Update: '||trim(to_char(v_up_cnt,      '999,999,999,999')) ;

RAISE notice '%', v_result;

return v_result;

EXCEPTION
WHEN others THEN
     v_err_msg := sqlerrm;
     RAISE NOTICE 'ERROR_MSG : %' , v_err_msg;
return sqlerrm;

END;
$$
LANGUAGE plpgsql NO SQL;
