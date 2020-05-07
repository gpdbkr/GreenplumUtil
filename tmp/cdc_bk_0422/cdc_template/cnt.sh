psql -ec "select now(), count(*) cnt from public.template_target;" -d pocdb
psql -ec "select now(), count(*) cnt from public.template_target where c1 like 'v2%' ;" -d pocdb
psql -ec "select * from public.cdc_log order by start_ts ;" -d pocdb
