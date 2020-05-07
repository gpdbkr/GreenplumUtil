psql -c "select public.udf_durable (); " pocdb
psql -c "select * from public_cdc_log_check order by start_ts desc; " pocdb
