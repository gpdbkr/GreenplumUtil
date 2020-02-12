#!/bin/bash

SHELL_NM=$0
CURDIR=`pwd`
LOGDIR=$CURDIR"/"log
LOGFILE=$LOGDIR"/"$SHELL_NM".log"
mkdir -p $LOGDIR

psql  -ec "

select
       dt
       , case when tm >= '00' and tm <= '08' then '01_batch'
              when tm >= '09' and tm <= '11' then '02_morning'
              when tm >= '13' and tm <= '18' then '03_afternoon'
              else '04_etc'
         end tm
       , round(max(cpu_user      ),0) cpu_user
       , round(max(cpu_sys       ),0) cpu_sys
       , round(min(cpu_idle       ),0) cpu_idle
       , round(max(cpu       ),0) cpu

       , round(max(mem_used     ),0) mem_used
       , round(max(swap_used     ),0) swap_used
       , round(max(load0         ),0) load0
       , round(max(load1         ),0) load1
       , round(max(load2         ),0) load2
       , round(max(disk_rb_rate_mb  ),0) disk_rb_rate_mb
       , round(max(disk_wb_rate_mb  ),0) disk_wb_rate_mb
       , round(max(net_rb_rate_mb   ),0) net_rb_rate_mb
       , round(max(net_wb_rate_mb   ),0) net_wb_rate_mb
from   (
select    to_char(ctime,'YYYYMMDD')  dt
     ,    to_char(ctime,'HH24') tm
     ,    count(1) as cnt
     ,    round(avg(mem_used/1024/1024       ),0) as mem_used
     ,    round(avg(swap_used/1024/1024      ),0) as swap_used
     ,    round(avg(cpu_user       )::numeric          ,0) as cpu_user
     ,    round(avg(cpu_sys        )::numeric          ,0) as cpu_sys
     ,    round(avg(cpu_idle       )::numeric          ,0) as cpu_idle
     ,    100 - round(avg(cpu_idle       )::numeric          ,0)  as cpu
     ,    round(avg(load0          )::numeric          ,1) as load0
     ,    round(avg(load1          )::numeric          ,1) as load1
     ,    round(avg(load2          )::numeric          ,1) as load2
     ,    round(avg(disk_rb_rate/1024/1024   ),0) as disk_rb_rate_mb
     ,    round(avg(disk_wb_rate/1024/1024   ),0) as disk_wb_rate_mb
     ,    round(avg(net_rb_rate/1024/1024    ),0) as net_rb_rate_mb
     ,    round(avg(net_wb_rate/1024/1024    ),0) as net_wb_rate_mb
  from    public.system_history
  where  hostname like 'sdw%'
  and    ctime >= '20141201'::timestamp
--  and    ctime <  '20110910'::timestamp
  and    to_char(ctime, 'd') not in ('1', '6')
group by 1,2
order by 1, 2
) a
group by 1,2
order by 1,2;
" | tee  $LOGFILE


