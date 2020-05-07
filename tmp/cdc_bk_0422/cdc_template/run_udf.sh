psql -c "select public.udf_template_sync_update_all();" -d pocdb
psql -c "select * from public.template_target order by id;" -d pocdb