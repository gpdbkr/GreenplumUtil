CREATE OR REPLACE FUNCTION public.udf_template_src() RETURNS text AS 
$$
DECLARE
		v_target_tb		varchar(64);
		v_del_cnt		integer :=0 ;
		v_ins_cnt		integer :=0 ;
		v_up_cnt		integer :=0 ;
		
		v_min_ts		timestamp;
		v_max_ts		timestamp;
		v_start_ts		timestamp;
		v_end_ts		timestamp;
		
		v_result 		text;
		v_err_msg		text;
		v_cdc_row_cnt    	integer	:=0 ;
BEGIN

v_start_ts	:= clock_timestamp();
v_target_tb	:= 'public.template_src';

set random_page_cost = 1;
set enable_nestloop = on;

SELECT  MIN(z_cdc_ts), MAX(z_cdc_ts) INTO v_min_ts, v_max_ts
  FROM	public.template_src_stg;

DELETE FROM public.template_src a
 USING public.template_src_stg b
 where a.id                        = b.id                       
   AND b.z_cud_fg = 'DELETE'
   AND b.z_cdc_ts >= v_min_ts
   AND b.z_cdc_ts <= v_max_ts;
   
GET DIAGNOSTICS v_del_cnt = ROW_COUNT;

INSERT INTO public.template_src_stg
(
  id
, z_cdc_ts
, c3
, c2
, c1
)
WITH tmp AS
(	 
     SELECT *
       FROM (
	         SELECT
                     id
                   , z_cdc_ts
                   , c3
                   , c2
                   , c1
                   , z_cdc_ts
                   , z_cud_fg
 		   , row_number() over (partition by id
	       	                           order by z_cdc_ts desc) rnk
	      from public.template_src_stg a
             where a.z_cud_fg in ('INSERT','DELETE')
               and a.z_cdc_ts >= v_min_ts
	       and a.z_cdc_ts <= v_max_ts
             ) a
     where z_cud_fg = 'INSERT'
       and rnk = 1
)
select
       a.id
     , a.z_cdc_ts
     , a.c3
     , a.c2
     , a.c1
  from tmp a 
  left outer join public.template_src b 
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
              , max(z_cdc_ts                 ) z_cdc_ts                 
              , max(c3                       ) c3                       
              , max(c2                       ) c2                       
              , max(c1                       ) c1                       
          from (
		select 
			
                    id                       
                      , last_value (z_cdc_tsc3c2c1)
		              over (partition by id
			                order by case when z_cdc_tsc3c2c1
				                   is not null then 1 else 0 end asc
				               , z_cdc_ts rows between unbounded preceding
                                                                   and unbounded following) z_cdc_tsc3c2c1											   
                   from public.template_src_stg
                  where z_cud_fg in ('UPDATE','INSERT')
		    AND z_cdc_ts >= v_min_ts
		    AND z_cdc_ts <= v_max_ts 
	         ) a
            group by id
        ) tmp
)
update template_src a 
   set
        z_cdc_ts                  = coalesce (b.z_cdc_ts, a.z_cdc_ts)
      , c3                        = coalesce (b.c3, a.c3)
      , c2                        = coalesce (b.c2, a.c2)
      , c1                        = coalesce (b.c1, a.c1)
  from tmp b 
 where a.id                        = b.id                       
   and (
        a.z_cdc_ts                  <> b.z_cdc_ts                 
     or a.c3                        <> b.c3                       
     or a.c2                        <> b.c2                       
     or a.c1                        <> b.c1                       
       )
;

GET DIAGNOSTICS v_up_cnt = ROW_COUNT;

v_end_ts    :=  clock_timestamp();

delete from public.template_src_stg
 where z_cdc_ts >= v_min_ts
   and z_cdc_ts <= v_max_ts
;

GET DIAGNOSTICS v_cdc_row_cnt = ROW_COUNT;

INSERT INTO public.cdc_log (target_tb, start_ts, end_ts, stag_rows, ins_cnt, del_cnt, up_cnt)
VALUES (v_target_tb, v_start_ts, v_end_ts, v_cdc_row_cnt, v_ins_cnt, v_del_cnt, v_up_cnt);

v_result    := 'Start: '||to_char(v_start_ts, 'yyyy-mm-dd hh24:mi:ss')||', '||
                 'End: '||to_char(v_end_ts,   'yyyy-mm-dd hh24:mi:ss') ||', '||
                'Rows: '||trim(to_char(v_cc_row_cnt,  '999,999,999,999'))||', '||
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
