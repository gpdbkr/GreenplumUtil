select 'SELECT '''||a.schemaname||'.'||a.tablename||''' tb_nm, sum(row_count) t_cnt, Avg(Row_Count) avg_cnt , max(Row_Count) max_cnt, min(Row_Count) min_cnt,(1-(Avg(Row_Count)/Max(Row_Count)))*100 as Skew_Pct FROM (SELECT gp_segment_id, count(*) as Row_Count FROM '||a.schemaname||'.'||a.tablename||' GROUP BY gp_segment_id ) A;' qry
from   pg_tables a
       left outer join pg_partitions b
       on a.tablename = b.tablename
       left outer join pg_class c
       on a.tablename = c.relname
where  b.tablename is null 
and    relstorage <> 'x'
group by a.schemaname, a.tablename
order by 1

