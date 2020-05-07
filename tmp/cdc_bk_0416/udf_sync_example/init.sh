psql -c "truncate table public.cdc_org;" -d pocdb
psql -c "truncate table public.cdc_log;" -d pocdb
psql -c "truncate table public.cdc_log_tmp;" -d pocdb

psql -ec "select * from public.cdc_org order by id;" -d pocdb
psql -ec "select * from public.cdc_log order by id;" -d pocdb
psql -ec "select * from public.cdc_log_tmp order by ts;" -d pocdb
