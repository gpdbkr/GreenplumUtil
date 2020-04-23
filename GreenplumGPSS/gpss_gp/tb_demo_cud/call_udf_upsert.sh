psql -c "select gpss_test.udf_sync_gpss_test_tb_demo_cud_upsert();"
psql -c "select * from gpss_test.tb_demo_cud_target order by 1;"
