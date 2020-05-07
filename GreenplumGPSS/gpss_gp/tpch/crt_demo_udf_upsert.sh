psql -e << +

drop function gpss_test.udf_sync_gpss_test_tb_demo_cud_upsert();

create or replace function gpss_test.udf_sync_gpss_test_tb_demo_cud_upsert()
returns text as
\$\$

declare
  v_del_cnt integer := 0;
  v_ins_cnt integer := 0;
  v_up_cnt integer := 0;

  v_min_ts timestamp;
  v_max_ts timestamp;
  v_start_ts timestamp;
  v_end_ts timestamp;

  v_result text;
  v_err_msg text;
  v_cdc_del_cnt integer := 0;

begin

  v_start_ts := clock_timestamp();

  select min(gpss_ts), max(gpss_ts) into v_min_ts, v_max_ts
  from gpss_test.tb_demo_cud_stg
  ;


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
             and gpss_ts >= v_min_ts
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
          select id,c1,c2,c3,gpss_ts,gpss_fg,row_number() over (partition by id order by gpss_ts desc) rnk
            from gpss_test.tb_demo_cud_stg a
           where a.gpss_fg in ('U','I','D')
             and gpss_ts>= v_min_ts
             and gpss_ts <= v_max_ts
         ) a
   where rnk=1
     and gpss_fg ='U'
  )
  update gpss_test.tb_demo_cud_target a
  set
      c1 = b.c1,
      c2 = b.c2,
      c3 = b.c3,
      gpss_ts = b.gpss_ts
  from tmp b
  where a.id = b.id;

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


+
