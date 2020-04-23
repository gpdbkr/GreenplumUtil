CREATE OR REPLACE FUNCTION gpss_stg.udf_sync_gpss_test_template() RETURNS text AS
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
v_target_tb   := 'gpss_test.template';

set random_page_cost = 1;
set enable_nestloop = on;

SELECT MIN(gpss_ts), MAX(gpss_ts) INTO v_min_ts, v_max_ts
  FROM gpss_stg.gpss_test_template;

DELETE FROM gpss_test.template a
 USING gpss_stg.gpss_test_template b
 where a.id                        = b.id                       
   AND b.gpss_fg = 'D'
   AND b.gpss_ts >= v_min_ts
   AND b.gpss_ts <= v_max_ts;

GET DIAGNOSTICS v_del_cnt = ROW_COUNT;

INSERT INTO gpss_test.template
(
  id
, c1
, c2
, c3
)
WITH tmp AS
(
     SELECT *
       FROM (
             SELECT
                     id
                   , c1
                   , c2
                   , c3
                   , gpss_ts
                   , gpss_fg
                   , row_number() over (partition by id
                                            order by gpss_ts desc) rnk
               from gpss_stg.gpss_test_template a
              where a.gpss_fg in ('I','D')
                and a.gpss_ts >= v_min_ts
                and a.gpss_ts <= v_max_ts
             ) a
       where gpss_fg = 'I'
         and rnk = 1
)
select
       a.id
     , a.c1
     , a.c2
     , a.c3
  from tmp a
  left outer join gpss_test.template b
    on a.id                        = b.id                       
 where b.id                        is null
;

GET DIAGNOSTICS v_ins_cnt = ROW_COUNT;

WITH tmp AS
(
     SELECT *
       FROM (
             SELECT
                   id                       
                 , max(c1                       ) c1                       
                 , max(c2                       ) c2                       
                 , max(c3                       ) c3                       
              from (
                     select
                              id                       
                            , last_value (c1)
                                    over (partition by id
                                              order by case when c1
                                                                 is not null then 1 else 0 end asc
                                                     , gpss_ts rows between unbounded preceding
                                                                        and unbounded following) c1
                            , last_value (c2)
                                    over (partition by id
                                              order by case when c2
                                                                 is not null then 1 else 0 end asc
                                                     , gpss_ts rows between unbounded preceding
                                                                        and unbounded following) c2
                            , last_value (c3)
                                    over (partition by id
                                              order by case when c3
                                                                 is not null then 1 else 0 end asc
                                                     , gpss_ts rows between unbounded preceding
                                                                        and unbounded following) c3
                       from gpss_stg.gpss_test_template
                      where gpss_fg in ('U','I')
                        AND gpss_ts >= v_min_ts
                        AND gpss_ts <= v_max_ts
                    ) a
               group by id
            ) tmp
)
update gpss_test.template a
   set
        c1                        = coalesce (b.c1, a.c1)
      , c2                        = coalesce (b.c2, a.c2)
      , c3                        = coalesce (b.c3, a.c3)
  from tmp b
 where a.id                        = b.id                       
   and (
        a.c1                        <> b.c1                       
     or a.c2                        <> b.c2                       
     or a.c3                        <> b.c3                       
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
           from gpss_stg.gpss_test_template
          where gpss_ts >= v_min_ts
            and gpss_ts <= v_max_ts
          group by gpss_fg 
       ) a ;

delete from gpss_stg.gpss_test_template
 where gpss_ts >= v_min_ts
   and gpss_ts <= v_max_ts
;

GET DIAGNOSTICS v_cdc_row_cnt = ROW_COUNT;

--INSERT INTO public.cdc_log (target_tb, start_ts, end_ts, stag_rows, ins_cnt, del_cnt, up_cnt)
--VALUES (v_target_tb, v_start_ts, v_end_ts, v_cdc_row_cnt, v_ins_cnt, v_del_cnt, v_up_cnt);

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
