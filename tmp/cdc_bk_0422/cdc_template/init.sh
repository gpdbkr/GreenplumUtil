psql -c "truncate table public.template_src;" -d pocdb
psql -c "truncate table public.template_target;" -d pocdb
psql -c "truncate table public.cdc_log;" -d pocdb
psql -c "delete from public.template_stg;" -d pocdb
psql -ec "select * from public.template_src order by id;" -d pocdb
psql -ec "select * from public.template_target order by id;" -d pocdb
psql -ec "select * from public.template_stg order by ts;" -d pocdb
time psql -c "vacuum public.template_stg;" -d pocdb