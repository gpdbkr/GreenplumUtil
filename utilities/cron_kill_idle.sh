export PGHOST=MDW_VIP
export PGDATABASE=postgres
TGDATE=`date +%Y%m%d`

date >> /data/dba/utilities/statlog/killed_idle.${TGDATE} 2>&1 
psql -AXtc " select 'select pg_terminate_backend('||procpid||');'  from pg_stat_activity where now()-query_start >= '02:00:00' ;" >> /data/dba/utilities/statlog/killed_idle.${TGDATE} 2>&1
echo >> /data/dba/utilities/statlog/killed_idle.${TGDATE}  
