select coalesce(a.target_tb, 'Total') target_tb
     , to_char(max(a.end_ts) - min(a.start_ts), 'hh24:mi:ss') elapsed
     , extract ('epoch' from max(a.end_ts) - min(a.start_ts))::int elapsed_sec
	 , (sum(a.stag_rows) / extract ('epoch' from max(a.end_ts) - min(a.start_ts))::int tps
	 , sum(a.stag_rows)  stg_all
	 , sum(a.ins_cnt)    stg_ins
	 , sum(a.del_cnt)    stg_del
	 , sum(a.up_cnt)     stg_up
	 , sum(a.ins_cnt)    tg_int
	 , sum(a.del_cnt)    tg_del
	 , sum(a.up_cnt)     tg_up
from   public.cdc_log_check   a
     , public.cdc_log 	      b
where  a.target_tb = b.target_tb 
  and  a.start_ts = b.start_ts
group by a.target_tb 
order by 1; 
		  