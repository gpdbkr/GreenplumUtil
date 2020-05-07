psql -c "select public.udf_sync_cdc_log2();" -d pocdb
psql -c "select * from public.cdc_log order by id;" -d pocdb