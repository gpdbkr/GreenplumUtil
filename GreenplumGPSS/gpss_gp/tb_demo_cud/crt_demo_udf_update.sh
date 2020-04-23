psql -e << EOF

drop function if exists gpss_test.udf_sync_gpss_test_tb_demo_cud_update();

create or replace function gpss_test.udf_sync_gpss_test_tb_demo_cud_update()
returns text as
\$\$

declare
  v_del_cnt integer := 0;
  v_ins_cnt integer := 0;
  v_up_cnt  integer := 0;

  v_min_ts   timestamp;
  v_max_ts   timestamp;
  v_start_ts timestamp;
  v_end_ts   timestamp;

  v_result      text;
  v_err_msg     text;
  v_cdc_del_cnt integer := 0;

begin
  v_start_ts := clock_timestamp();

  select min(gpss_ts), max(gpss_ts)
    into v_min_ts, v_max_ts
    from gpss_test.tb_demo_cud_stg;

  delete from gpss_test.tb_demo_cud_target a
   using gpss_test.tb_demo_cud_stg b
   where a.id = b.id
     and b.gpss_fg = 'D'
     and b.gpss_ts >= v_min_ts
     and b.gpss_ts <= v_max_ts;

  get diagnostics v_del_cnt = ROW_COUNT ;

  insert into gpss_test.tb_demo_cud_target (id,c1,c2,c3,gpss_ts)
  with tmp as
  (
  select *
    from (
          select id,c1,c2,c3,gpss_ts,gpss_fg,row_number() over (partition by id order by gpss_ts desc) rnk
            from gpss_test.tb_demo_cud_stg a
           where a.gpss_fg in ('I','D')
             and gpss_ts  >= v_min_ts
             and gpss_ts <= v_max_ts
         ) a
   where gpss_fg = 'I'
     and rnk = 1
  )
  select a.id, a.c1, a.c2, a.c3, a.gpss_ts
    from tmp a
    left outer join gpss_test.tb_demo_cud_target b
      on a.id = b.id
   where b.id is null;

  get diagnostics v_ins_cnt = ROW_COUNT ;

  with tmp as
  (
  select *
    from (
          select id, max(c1) c1, max(c2) c2, max(c3) c3, max(gpss_ts) gpss_ts
            from (
                  select id
                       , last_value(c1) over (partition by id order by case when c1 is not null then 1 else 0 end asc, gpss_ts rows between unbounded preceding and unbounded following) c1
                       , last_value(c2) over (partition by id order by case when c2 is not null then 1 else 0 end asc, gpss_ts rows between unbounded preceding and unbounded following) c2
                       , last_value(c3) over (partition by id order by case when c3 is not null then 1 else 0 end asc, gpss_ts rows between unbounded preceding and unbounded following) c3
                       , last_value(gpss_ts) over (partition by id order by gpss_ts rows between unbounded preceding and unbounded following) gpss_ts
                    from gpss_test.tb_demo_cud_stg a
                   where a.gpss_fg in  ('U','I')
                     and gpss_ts >= v_min_ts
                     and gpss_ts <= v_max_ts
                 ) a
           group by id
         ) tmp
  )
  update gpss_test.tb_demo_cud_target a
  set
      c1 = coalesce(b.c1,a.c1),
      c2 = coalesce(b.c2,a.c2),
      c3 = coalesce(b.c3,a.c3),
      gpss_ts = coalesce(b.gpss_ts,a.gpss_ts)
  from tmp b
  where a.id = b.id
  and   (
               a.c1 <> b.c1
           or  a.c2 <> b.c2
           or  a.c3 <> b.c3
           or  a.gpss_ts <> b.gpss_ts
        )
  
  ;

  get diagnostics v_up_cnt = ROW_COUNT ;

  v_end_ts := clock_timestamp();

  delete from gpss_test.tb_demo_cud_stg
   where gpss_ts >= v_min_ts
     and gpss_ts <= v_max_ts;

  get diagnostics v_cdc_del_cnt = ROW_COUNT ;

  v_result := 'start: '  || to_char(v_start_ts,'yyyy-mm-dd hh24:mi:ss')   || ', ' ||
              'end: '    || to_char(v_end_ts,  'yyyy-mm-dd hh24:mi:ss')   || ', ' ||
              'rows: '   || trim(to_char(v_cdc_del_cnt,'99,999,999,999')) || ', ' ||
              'delete: ' || trim(to_char(v_del_cnt,    '99,999,999,999')) || ', ' ||
              'insert: ' || trim(to_char(v_ins_cnt,    '99,999,999,999')) || ', ' ||
              'update: ' || trim(to_char(v_up_cnt,     '99,999,999,999')) ;

  raise notice '%' , v_result;

  return v_result;

  exception
  when others then
       v_err_msg := sqlerrm;
       raise notice 'error_msg : %', v_err_msg;
       return sqlerrm;

end;
\$\$
language 'plpgsql' volatile;

EOF
