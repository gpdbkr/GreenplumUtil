. ~/.bash_profile

psql -AXtc "select
       'analyze '||a.schemaname||'.'||a.tablename||' ;'
  from
       pg_tables a
  left outer join
       pg_partitions b
    on a.tablename = b.partitiontablename
 where
       b.partitiontablename is null
   and a.schemaname not in ('pg_catalog','gp_toolkit','public','dba') order by a.schemaname,a.tablename" | psql -e -U gpadmin
