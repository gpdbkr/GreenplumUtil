CREATE OR REPLACE FUNCTION public.udf_cms_im_lothold_his_ic() RETURNS text AS 
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
v_target_tb	:= 'striim.cms_im_lothold_his_ic';

set random_page_cost = 1;
set enable_nestloop = on;

SELECT  MIN(z_cdc_ts), MAX(z_cdc_ts) INTO v_min_ts, v_max_ts
  FROM	striim.cms_im_lothold_his_ic_stg;

DELETE FROM striim.cms_im_lothold_his_ic a
 USING striim.cms_im_lothold_his_ic_stg b
 where a.lot_hold_id               = b.lot_hold_id              
   AND a.hold_tm                   = b.hold_tm                  
   AND b.z_cud_fg = 'DELETE'
   AND b.z_cdc_ts >= v_min_ts
   AND b.z_cdc_ts <= v_max_ts;
   
GET DIAGNOSTICS v_del_cnt = ROW_COUNT;

INSERT INTO striim.cms_im_lothold_his_ic_stg
(
  lot_hold_id
, hold_tm
, wf_cnt
, release_operator_user_id
, owner_fab_id
, hold_stat_cd
, fab_id
, crt_user_id
, crt_tm
, chg_user_id
, chg_tm
)
WITH tmp AS
(	 
     SELECT *
       FROM (
	         SELECT
                     lot_hold_id
                   , hold_tm
                   , wf_cnt
                   , release_operator_user_id
                   , owner_fab_id
                   , hold_stat_cd
                   , fab_id
                   , crt_user_id
                   , crt_tm
                   , chg_user_id
                   , chg_tm
                   , z_cdc_ts
                   , z_cud_fg
 		   , row_number() over (partition by lot_hold_id,hold_tm
	       	                           order by z_cdc_ts desc) rnk
	      from striim.cms_im_lothold_his_ic_stg a
             where a.z_cud_fg in ('INSERT','DELETE')
               and a.z_cdc_ts >= v_min_ts
	       and a.z_cdc_ts <= v_max_ts
             ) a
     where z_cud_fg = 'INSERT'
       and rnk = 1
)
select
       a.lot_hold_id
     , a.hold_tm
     , a.wf_cnt
     , a.release_operator_user_id
     , a.owner_fab_id
     , a.hold_stat_cd
     , a.fab_id
     , a.crt_user_id
     , a.crt_tm
     , a.chg_user_id
     , a.chg_tm
  from tmp a 
  left outer join striim.cms_im_lothold_his_ic b 
    on a.lot_hold_id               = b.lot_hold_id              
   and a.hold_tm                   = b.hold_tm                  
 where b.lot_hold_id               is null
   and b.hold_tm                   is null
;

GET DIAGNOSTICS v_ins_cnt = ROW_COUNT;

WITH tmp AS
(	 
     SELECT *
       FROM (
             SELECT
                lot_hold_id              
              , hold_tm                  
              , max(wf_cnt                   ) wf_cnt                   
              , max(release_operator_user_id ) release_operator_user_id 
              , max(owner_fab_id             ) owner_fab_id             
              , max(hold_stat_cd             ) hold_stat_cd             
              , max(fab_id                   ) fab_id                   
              , max(crt_user_id              ) crt_user_id              
              , max(crt_tm                   ) crt_tm                   
              , max(chg_user_id              ) chg_user_id              
              , max(chg_tm                   ) chg_tm                   
          from (
		select 
			
                    lot_hold_id              
                  , hold_tm                  
                      , last_value (wf_cntrelease_operator_user_idowner_fab_idhold_stat_cdfab_idcrt_user_idcrt_tmchg_user_idchg_tm)
		              over (partition by lot_hold_id,hold_tm
			                order by case when wf_cntrelease_operator_user_idowner_fab_idhold_stat_cdfab_idcrt_user_idcrt_tmchg_user_idchg_tm
				                   is not null then 1 else 0 end asc
				               , z_cdc_ts rows between unbounded preceding
                                                                   and unbounded following) wf_cntrelease_operator_user_idowner_fab_idhold_stat_cdfab_idcrt_user_idcrt_tmchg_user_idchg_tm											   
                   from striim.cms_im_lothold_his_ic_stg
                  where z_cud_fg in ('UPDATE','INSERT')
		    AND z_cdc_ts >= v_min_ts
		    AND z_cdc_ts <= v_max_ts 
	         ) a
            group by lot_hold_id,hold_tm
        ) tmp
)
update cms_im_lothold_his_ic a 
   set
        wf_cnt                    = coalesce (b.wf_cnt, a.wf_cnt)
      , release_operator_user_id  = coalesce (b.release_operator_user_id, a.release_operator_user_id)
      , owner_fab_id              = coalesce (b.owner_fab_id, a.owner_fab_id)
      , hold_stat_cd              = coalesce (b.hold_stat_cd, a.hold_stat_cd)
      , fab_id                    = coalesce (b.fab_id, a.fab_id)
      , crt_user_id               = coalesce (b.crt_user_id, a.crt_user_id)
      , crt_tm                    = coalesce (b.crt_tm, a.crt_tm)
      , chg_user_id               = coalesce (b.chg_user_id, a.chg_user_id)
      , chg_tm                    = coalesce (b.chg_tm, a.chg_tm)
  from tmp b 
 where a.lot_hold_id               = b.lot_hold_id              
   and a.hold_tm                   = b.hold_tm                  
   and (
        a.wf_cnt                    <> b.wf_cnt                   
     or a.release_operator_user_id  <> b.release_operator_user_id 
     or a.owner_fab_id              <> b.owner_fab_id             
     or a.hold_stat_cd              <> b.hold_stat_cd             
     or a.fab_id                    <> b.fab_id                   
     or a.crt_user_id               <> b.crt_user_id              
     or a.crt_tm                    <> b.crt_tm                   
     or a.chg_user_id               <> b.chg_user_id              
     or a.chg_tm                    <> b.chg_tm                   
       )
;

GET DIAGNOSTICS v_up_cnt = ROW_COUNT;

v_end_ts    :=  clock_timestamp();

delete from striim.cms_im_lothold_his_ic_stg
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
