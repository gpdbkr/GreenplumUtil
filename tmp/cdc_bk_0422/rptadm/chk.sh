psql pocdb << +
select a.target_tb, a.start_ts, to_char(a.end_ts - a.start_ts, 'hh24:mi:ss') elapsed
	   , a.stag_rows stg_all
	   , a.ins_cnt stg_ins
	   , a.del_cnt stg_del
	   , a.up_cnt stg_up
	   , b.ins_cnt tg_ins
	   , b.den_cnt tg_del
	   , b.up_cnt tg_up
from    public.cdc_log_check a
       ,public.cdc_log       b
where  a.target_tb = b.target_tb
and    a.start_ts  = b.start_ts
and    a.target_tb = '$1'
order by a.start_ts, a.target_tb -- desc
--limit 10
;
+











